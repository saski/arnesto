#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cases="$repo_dir/evals/truthfulness/cases.json"
runner="$repo_dir/bin/run-truthfulness-eval"

jq -e '
    type == "array" and
    length >= 3 and
    all(.[];
        (.id | type == "string" and length > 0) and
        (.prompt | type == "string" and length > 0) and
        (.expected_evidence | IN("verified", "inference", "unknown")) and
        (.required_terms | type == "array") and
        (.forbidden_terms | type == "array")
    )
' "$cases" >/dev/null

grep -Fq 'codex exec --ephemeral' "$runner"
grep -Fq 'hermes_bin=${HERMES_BIN:-hermes}' "$runner"
grep -Fq '"$hermes_bin" --oneshot' "$runner"
grep -Fq 'Return only JSON with exactly these keys' "$runner"
grep -Fq '"$eval_prompt" </dev/null' "$runner"

echo "PASS: truthfulness eval has valid cases and runner contracts"
