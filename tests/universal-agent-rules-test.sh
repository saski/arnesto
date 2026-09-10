#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
rules="$repo_dir/.agents/rules/base.md"

for expected_rule in \
    'Never invent or conceal facts/context; label claims verified, inferred, or unknown.' \
    'Correct errors with evidence; apologies do not correct.'; do
    if ! grep -Fq -- "$expected_rule" "$rules"; then
        echo "FAIL: universal agent rules are missing required truthfulness guidance" >&2
        exit 1
    fi
done

echo "PASS: universal agent rules enforce truthfulness guidance"
