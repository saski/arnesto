#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
manifest="$repo_dir/templates/omniroute/free-coding-combo.json"
configurator="$repo_dir/bin/configure-omniroute-free-coding"
operations_doc="$repo_dir/docs/hermes-omniroute-operations.md"
fixture_dir=$(mktemp -d)
trap 'status=$?; rm -rf "$fixture_dir"; exit "$status"' EXIT

expected_models=$(jq -cn '[
    "opencode-zen/laguna-s-2.1-free",
    "opencode/mimo-v2.5-free",
    "opencode/hy3-free",
    "opencode/big-pickle"
]')

actual_models=$(jq -c '[.models[].model]' "$manifest")
[ "$actual_models" = "$expected_models" ] || {
    echo "FAIL: free-coding preference order changed" >&2
    exit 1
}

jq -e '
    .name == "free-coding" and
    .strategy == "priority" and
    .allowedProviders == ["opencode-zen", "opencode"] and
    .config.trackMetrics == true and
    ([.models[].weight] | all(. == 0))
' "$manifest" >/dev/null || {
    echo "FAIL: free-coding manifest does not enforce the expected free-only priority contract" >&2
    exit 1
}

grep -Fq 'The obsolete `free-stack` and `free-deterministic` combos were inactive and' \
    "$operations_doc" || {
    echo "FAIL: operations documentation does not mark obsolete combos as retired" >&2
    exit 1
}

fake_bin="$fixture_dir/bin"
state_path="$fixture_dir/state.json"
log_path="$fixture_dir/omniroute.log"
mkdir -p "$fake_bin"
printf '%s\n' '{"combos":[],"active":null}' > "$state_path"

cat > "$fake_bin/omniroute" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$OMNIROUTE_TEST_LOG"

if [ "$*" = "health" ]; then
    exit 0
fi

if [ "$*" = "--output json combo list" ]; then
    printf '%s\n' 'Loaded local OmniRoute environment'
    cat "$OMNIROUTE_TEST_STATE"
    exit 0
fi

if [ "${1:-}" = api ] && [ "${2:-}" = combos ] &&
    [ "${3:-}" = post-api-combos ] && [ "${4:-}" = --body ]; then
    if [ "${OMNIROUTE_TEST_AUTH_FAIL:-0}" = 1 ]; then
        printf '%s\n' '{"error":{"message":"Authentication required"}}'
        exit 0
    fi
    manifest_path=${5#@}
    jq -c '{combos: [.], active: null}' "$manifest_path" > "$OMNIROUTE_TEST_STATE"
    printf '%s\n' '{"created":true}'
    exit 0
fi

echo "unexpected omniroute invocation: $*" >&2
exit 1
EOF
chmod +x "$fake_bin/omniroute"

run_configurator() {
    PATH="$fake_bin:/usr/bin:/bin" \
        OMNIROUTE_TEST_LOG="$log_path" \
        OMNIROUTE_TEST_STATE="$state_path" \
        "$configurator"
}

: > "$log_path"
run_configurator >/dev/null
grep -Fq 'api combos post-api-combos --body @' "$log_path"
jq -e '.combos[0].name == "free-coding"' "$state_path" >/dev/null

: > "$log_path"
run_configurator >/dev/null
if grep -Fq 'post-api-combos' "$log_path"; then
    echo "FAIL: an already matching combo should not be recreated" >&2
    exit 1
fi

jq '.combos[0].strategy = "random"' "$state_path" > "$fixture_dir/drifted.json"
mv "$fixture_dir/drifted.json" "$state_path"
if run_configurator >"$fixture_dir/drift.out" 2>&1; then
    echo "FAIL: configurator accepted runtime drift" >&2
    exit 1
fi
grep -Fq 'differs from the tracked manifest' "$fixture_dir/drift.out"

printf '%s\n' '{"combos":[],"active":null}' > "$state_path"
if PATH="$fake_bin:/usr/bin:/bin" \
    OMNIROUTE_TEST_LOG="$log_path" \
    OMNIROUTE_TEST_STATE="$state_path" \
    OMNIROUTE_TEST_AUTH_FAIL=1 \
    "$configurator" >"$fixture_dir/auth.out" 2>&1; then
    echo "FAIL: configurator accepted a management authentication failure" >&2
    exit 1
fi
grep -Fq 'management authentication is required' "$fixture_dir/auth.out"
jq -e '.combos == []' "$state_path" >/dev/null

echo "PASS: free-coding combo configuration is ordered, idempotent, and drift-safe"
