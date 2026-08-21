#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture_dir=$(mktemp -d)
trap 'status=$?; rm -rf "$fixture_dir"; exit "$status"' EXIT

fixture_repo="$fixture_dir/arnesto-fixture"
home_dir="$fixture_dir/home"
mkdir -p \
    "$home_dir" \
    "$fixture_repo/.cursor" \
    "$fixture_repo/.agents/rules" \
    "$fixture_repo/.agents/hooks" \
    "$fixture_repo/.claude/hooks" \
    "$fixture_repo/bin" \
    "$fixture_repo/templates/codex" \
    "$fixture_repo/templates/claude" \
    "$fixture_repo/templates/opencode" \
    "$fixture_repo/lib"

cp "$repo_dir/setup-symlinks.sh" "$fixture_repo/setup-symlinks.sh"
touch \
    "$fixture_repo/.agents/mcp.json" \
    "$fixture_repo/.cursor/cli-config.json" \
    "$fixture_repo/.agents/rules/codex-default.rules" \
    "$fixture_repo/.agents/hooks/rtk-rewrite.sh" \
    "$fixture_repo/GEMINI.md" \
    "$fixture_repo/templates/codex/config.toml" \
    "$fixture_repo/templates/codex/hooks.json" \
    "$fixture_repo/templates/claude/settings.json" \
    "$fixture_repo/templates/opencode/free-worker.jsonc" \
    "$fixture_repo/lib/install-opencode-free-worker-config.mjs"
cp "$repo_dir/bin/codex-free" "$fixture_repo/bin/codex-free"
chmod +x "$fixture_repo/bin/codex-free"
git -C "$fixture_repo" init -q

output=$(HOME="$home_dir" "$fixture_repo/setup-symlinks.sh" status)

if [[ "$output" != *"Configuration changes"* ]]; then
    echo "FAIL: setup-symlinks.sh did not discover its checkout from the script location" >&2
    printf '%s\n' "$output" >&2
    exit 1
fi

if grep -Fq 'augmentedcode-configuration' "$fixture_repo/setup-symlinks.sh"; then
    echo "FAIL: setup-symlinks.sh still contains the legacy repository name" >&2
    exit 1
fi

echo "PASS: setup-symlinks.sh works from an arbitrarily named checkout"
