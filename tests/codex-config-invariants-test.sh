#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
template="$repo_dir/templates/codex/config.toml"
fixture_dir=$(mktemp -d)
trap 'status=$?; rm -rf "$fixture_dir"; exit "$status"' EXIT

fixture_repo="$fixture_dir/arnesto"
fixture_home="$fixture_dir/home"

for expected_line in \
    'model = "gpt-5.6-terra"' \
    'model_reasoning_effort = "medium"' \
    'personality = "pragmatic"' \
    'multi_agent = true'; do
    if ! grep -Fqx -- "$expected_line" "$template"; then
        echo "FAIL: Codex template is missing required invariant: $expected_line" >&2
        exit 1
    fi
done

cp -R "$repo_dir" "$fixture_repo"
mkdir "$fixture_home"

HOME="$fixture_home" "$fixture_repo/setup-symlinks.sh" setup >/dev/null

validation_output=$(HOME="$fixture_home" "$fixture_repo/setup-symlinks.sh" validate)
if ! grep -Fq 'matches required Codex invariants' <<<"$validation_output"; then
    echo "FAIL: setup validation did not accept a seeded Codex config" >&2
    exit 1
fi

ruby -e 'path = ARGV.fetch(0); File.write(path, File.read(path).sub(/^model = "gpt-5.6-terra"$/, "model = \"gpt-6-astra\""))' "$fixture_home/.codex/config.toml"

if ! HOME="$fixture_home" "$fixture_repo/setup-symlinks.sh" validate >/dev/null; then
    echo "FAIL: setup validation rejected the local Astra model selection" >&2
    exit 1
fi

HOME="$fixture_home" "$fixture_repo/setup-symlinks.sh" setup >/dev/null
if ! grep -Fqx 'model = "gpt-6-astra"' "$fixture_home/.codex/config.toml"; then
    echo "FAIL: setup overwrote the local model selection" >&2
    exit 1
fi

ruby -e 'path = ARGV.fetch(0); File.write(path, File.read(path).sub(/^personality = "pragmatic"\n/, ""))' "$fixture_home/.codex/config.toml"

if HOME="$fixture_home" "$fixture_repo/setup-symlinks.sh" validate >/dev/null; then
    echo "FAIL: setup validation accepted a Codex config missing personality" >&2
    exit 1
fi

echo "PASS: setup validation enforces required Codex invariants"
