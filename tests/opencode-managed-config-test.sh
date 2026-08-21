#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture_dir=$(mktemp -d)
trap 'status=$?; rm -rf "$fixture_dir"; exit "$status"' EXIT

fixture_repo="$fixture_dir/repo"
home_dir="$fixture_dir/home"
config_dir="$home_dir/.config/opencode"
auth_dir="$home_dir/.local/share/opencode"
mkdir -p "$config_dir" "$auth_dir" \
    "$fixture_repo/.cursor" \
    "$fixture_repo/.agents/rules" \
    "$fixture_repo/.agents/hooks" \
    "$fixture_repo/.claude/hooks" \
    "$fixture_repo/templates/codex" \
    "$fixture_repo/templates/claude" \
    "$fixture_repo/templates/opencode"
touch "$fixture_repo/.agents/mcp.json" \
    "$fixture_repo/.cursor/cli-config.json" \
    "$fixture_repo/.agents/rules/codex-default.rules" \
    "$fixture_repo/.agents/hooks/rtk-rewrite.sh" \
    "$fixture_repo/GEMINI.md"
cp "$repo_dir/templates/codex/config.toml" "$fixture_repo/templates/codex/config.toml"
cp "$repo_dir/templates/codex/hooks.json" "$fixture_repo/templates/codex/hooks.json"
cp "$repo_dir/templates/claude/settings.json" "$fixture_repo/templates/claude/settings.json"
cp "$repo_dir/templates/opencode/free-worker.jsonc" "$fixture_repo/templates/opencode/free-worker.jsonc"
mkdir -p "$fixture_repo/lib"
cp "$repo_dir/lib/install-opencode-free-worker-config.mjs" "$fixture_repo/lib/install-opencode-free-worker-config.mjs"

cat >"$config_dir/opencode.jsonc" <<'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "disabled_providers": ["example"],
  "provider": {
    "other": {"npm": "example-provider"},
    "omniroute": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {"baseURL": "http://localhost:20128/v1"},
      "models": {
        "oc/custom-free": {},
        "oc/deepseek-v4-flash-free": {"name": "User model label"}
      }
    }
  },
  "agent": {
    "existing": {"mode": "primary"}
  }
}
JSON
printf '%s\n' 'credential-must-not-change' >"$auth_dir/auth.json"
auth_before=$(shasum -a 256 "$auth_dir/auth.json" | awk '{print $1}')

HOME="$home_dir" REPO_DIR="$fixture_repo" "$repo_dir/setup-symlinks.sh" opencode-free-worker >/dev/null
HOME="$home_dir" REPO_DIR="$fixture_repo" "$repo_dir/setup-symlinks.sh" validate-opencode-free-worker >/dev/null

node - "$config_dir/opencode.jsonc" <<'NODE'
const fs = require('fs')
const config = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'))
const fail = (message) => { console.error(`FAIL: ${message}`); process.exit(1) }
if (config.$schema !== 'https://opencode.ai/config.json') fail('schema must be preserved')
if (JSON.stringify(config.disabled_providers) !== JSON.stringify(['example'])) fail('unrelated top-level fields must be preserved')
if (config.provider?.other?.npm !== 'example-provider') fail('unrelated provider must be preserved')
if (!config.provider?.omniroute?.models?.['oc/custom-free']) fail('unrelated OmniRoute model must be preserved')
if (config.provider?.omniroute?.options?.baseURL !== 'http://localhost:20128/v1') fail('existing local endpoint must be preserved')
if (config.provider?.omniroute?.models?.['oc/deepseek-v4-flash-free']?.name !== 'User model label') fail('existing model metadata must be preserved')
for (const model of ['combo/free-coding', 'oc/deepseek-v4-flash-free', 'oc/big-pickle']) {
  if (!config.provider?.omniroute?.models?.[model]) fail(`managed model ${model} missing`)
}
if (config.agent?.existing?.mode !== 'primary') fail('unrelated agent must be preserved')
if (config.agent?.['free-worker']?.maxSteps !== 3) fail('managed free-worker agent missing')
NODE

auth_after=$(shasum -a 256 "$auth_dir/auth.json" | awk '{print $1}')
if [ "$auth_before" != "$auth_after" ]; then
    echo "FAIL: OpenCode credentials changed" >&2
    exit 1
fi

first_config=$(shasum -a 256 "$config_dir/opencode.jsonc" | awk '{print $1}')
HOME="$home_dir" REPO_DIR="$fixture_repo" "$repo_dir/setup-symlinks.sh" opencode-free-worker >/dev/null
second_config=$(shasum -a 256 "$config_dir/opencode.jsonc" | awk '{print $1}')
if [ "$first_config" != "$second_config" ]; then
    echo "FAIL: OpenCode managed installation is not idempotent" >&2
    exit 1
fi

new_home_dir="$fixture_dir/new-home"
HOME="$new_home_dir" REPO_DIR="$fixture_repo" "$repo_dir/setup-symlinks.sh" opencode-free-worker >/dev/null
HOME="$new_home_dir" REPO_DIR="$fixture_repo" "$repo_dir/setup-symlinks.sh" validate-opencode-free-worker >/dev/null
node - "$new_home_dir/.config/opencode/opencode.jsonc" <<'NODE'
const fs = require('fs')
const config = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'))
const provider = config.provider?.omniroute
if (!provider?.models?.['combo/free-coding'] || !provider?.models?.['oc/deepseek-v4-flash-free'] || !provider?.models?.['oc/big-pickle']) {
  console.error('FAIL: new configuration missing managed model set')
  process.exit(1)
}
if (config.agent?.['free-worker']?.maxSteps !== 3) {
  console.error('FAIL: new configuration missing managed agent')
  process.exit(1)
}
NODE

echo "PASS: managed OpenCode free-worker installation preserves user configuration and credentials"
