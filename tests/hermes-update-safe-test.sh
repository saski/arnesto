#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$REPO_DIR/hermes-update-safe.sh"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

mkdir -p "$TEST_DIR/bin" "$TEST_DIR/home/hermes-agent"
printf 'gitdir: /tmp/fake-common-dir/worktrees/hermes-agent\n' >"$TEST_DIR/home/hermes-agent/.git"

cat >"$TEST_DIR/bin/git" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
while [[ "${1:-}" == "-C" ]]; do shift 2; done
case "$1" in
  fetch) exit 0 ;;
  status) exit 0 ;;
  merge-base)
    if [[ "${FAKE_GIT_STATE:-behind}" == "behind" && "$3" == "HEAD" ]]; then exit 0; fi
    if [[ "${FAKE_GIT_STATE:-behind}" == "current" ]]; then exit 0; fi
    exit 1
    ;;
  rev-parse)
    if [[ "${2:-}" == "--git-dir" ]]; then
      printf '.git\n'
      exit 0
    fi
    if [[ "${FAKE_GIT_STATE:-behind}" != "current" && "$2" == "origin/main" ]]; then
      printf 'upstream-revision\n'
    else
      printf 'test-revision\n'
    fi
    ;;
  *) printf 'unexpected git invocation: %s\n' "$*" >&2; exit 64 ;;
esac
EOF

cat >"$TEST_DIR/bin/hermes" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$FAKE_CALL_LOG"
EOF

cat >"$TEST_DIR/bin/launchctl" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$FAKE_CALL_LOG"
EOF

chmod +x "$TEST_DIR/bin/git" "$TEST_DIR/bin/hermes" "$TEST_DIR/bin/launchctl"

assert_contains() {
  local actual="$1"
  local expected="$2"

  if [[ "$actual" != *"$expected"* ]]; then
    printf 'expected output to contain: %s\nactual output: %s\n' "$expected" "$actual" >&2
    exit 1
  fi
}

run() {
  PATH="$TEST_DIR/bin:$PATH" \
  HERMES_HOME="$TEST_DIR/home" \
  HERMES_UPDATE_BACKUP_DIR="$TEST_DIR/backups" \
  FAKE_CALL_LOG="$TEST_DIR/calls.log" \
  FAKE_GIT_STATE="${FAKE_GIT_STATE:-behind}" \
  "$SCRIPT" "$@"
}

check_output="$(run check)"
[[ "$check_output" == *'Update available'* ]]

current_output="$(FAKE_GIT_STATE=current run check)"
assert_contains "$current_output" 'already current'

stage_output="$(run stage)"
[[ "$stage_output" == *'Staged update at test-revision'* ]]
[[ -f "$TEST_DIR/home/run/safe-update/staged-revision" ]]
[[ -n "$(find "$TEST_DIR/backups" -type f -name '*.tar.gz')" ]]

run activate >/dev/null
grep -Fx 'update --backup --yes' "$TEST_DIR/calls.log" >/dev/null
grep -Fx 'kickstart -k gui/'"$(id -u)"'/ai.hermes.gateway' "$TEST_DIR/calls.log" >/dev/null

if FAKE_GIT_STATE=diverged run check >"$TEST_DIR/diverged.out" 2>&1; then
  printf 'expected divergent history to fail\n' >&2
  exit 1
fi
grep -F 'histories diverge' "$TEST_DIR/diverged.out" >/dev/null

printf 'hermes-update-safe tests passed\n'
