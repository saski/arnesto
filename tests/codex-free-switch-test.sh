#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture_dir=$(mktemp -d)
trap 'status=$?; rm -rf "$fixture_dir"; exit "$status"' EXIT

fake_bin="$fixture_dir/bin"
log_path="$fixture_dir/omniroute.log"
state_path="$fixture_dir/omniroute.state"
mkdir -p "$fake_bin"

if ! grep -Fq 'CODEX_FREE_SHELL_LINK="$HOME/.local/bin/codex-free"' "$repo_dir/setup-symlinks.sh"; then
    echo "FAIL: setup does not expose codex-free on the normal interactive shell PATH" >&2
    exit 1
fi

cat > "$fake_bin/codex" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

cat > "$fake_bin/omniroute" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$OMNIROUTE_TEST_LOG"
case "${1:-}" in
    health)
        [ "$(cat "$OMNIROUTE_TEST_STATE" 2>/dev/null || true)" = ready ]
        ;;
    serve)
        printf '%s\n' ready > "$OMNIROUTE_TEST_STATE"
        ;;
    --output)
        if [ "${OMNIROUTE_TEST_COMBO:-ready}" = ready ]; then
            printf '%s\n' '{"combos":[{"name":"free-coding","models":[{"model":"opencode-zen/laguna-s-2.1-free"}]}],"active":null}'
        else
            printf '%s\n' '{"combos":[],"active":null}'
        fi
        ;;
    launch-codex)
        ;;
esac
EOF
chmod +x "$fake_bin/codex" "$fake_bin/omniroute"

run_switch() {
    PATH="$fake_bin:/usr/bin:/bin" \
        OMNIROUTE_TEST_LOG="$log_path" \
        OMNIROUTE_TEST_STATE="$state_path" \
        "$repo_dir/bin/codex-free" "$@"
}

: > "$log_path"
rm -f "$state_path"
run_switch exec --json "check default route"
grep -Fxq 'serve --daemon --no-open' "$log_path"
grep -Fxq 'launch-codex -- --model combo/free-coding exec --json check default route' "$log_path"

: > "$log_path"
printf '%s\n' ready > "$state_path"
fallback_output=$(PATH="$fake_bin:/usr/bin:/bin" \
    OMNIROUTE_TEST_LOG="$log_path" \
    OMNIROUTE_TEST_STATE="$state_path" \
    OMNIROUTE_TEST_COMBO=missing \
    "$repo_dir/bin/codex-free" exec "check bootstrap fallback" 2>&1)
grep -Fxq 'launch-codex -- --model opencode-zen/laguna-s-2.1-free exec check bootstrap fallback' "$log_path"
[[ "$fallback_output" = *"managed combo is not installed; using the Laguna pin"* ]]

assert_switch() {
    local switch_name=$1
    local expected_model=$2

    : > "$log_path"
    printf '%s\n' ready > "$state_path"
    run_switch "$switch_name" exec "check alternate route"
    grep -Fxq "launch-codex -- --model $expected_model exec check alternate route" "$log_path"
    if grep -Fq 'serve --daemon --no-open' "$log_path"; then
        echo "FAIL: healthy OmniRoute should not be restarted" >&2
        exit 1
    fi
}

assert_switch --laguna opencode-zen/laguna-s-2.1-free
assert_switch --mimo oc/mimo-v2.5-free
assert_switch --hy3 oc/hy3-free
assert_switch --big-pickle oc/big-pickle

if run_switch --model paid/model exec "unsafe override" >/dev/null 2>&1; then
    echo "FAIL: codex-free accepted a caller-supplied model override" >&2
    exit 1
fi

help_output=$(run_switch --help-free)
if [[ "$help_output" != *"combo/free-coding"* ]] || [[ "$help_output" != *"--laguna"* ]] ||
    [[ "$help_output" != *"--mimo"* ]] || [[ "$help_output" != *"--hy3"* ]] ||
    [[ "$help_output" != *"--big-pickle"* ]]; then
    echo "FAIL: codex-free help does not document the managed route and manual pins" >&2
    exit 1
fi

echo "PASS: codex-free selects an explicit free OmniRoute lane"
