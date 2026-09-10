#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
rules="$repo_dir/.agents/rules/base.md"

for expected_rule in \
    'Never invent, conceal, or deny facts, sources, outcomes, capabilities, or applicable context.' \
    'Clearly distinguish verified evidence, inference, and unknowns; inspect available context before making a claim.' \
    'Correct errors plainly and specifically. Do not use an apology as a substitute for the correction or for evidence.'; do
    if ! grep -Fq -- "$expected_rule" "$rules"; then
        echo "FAIL: universal agent rules are missing required truthfulness guidance" >&2
        exit 1
    fi
done

echo "PASS: universal agent rules enforce truthfulness guidance"
