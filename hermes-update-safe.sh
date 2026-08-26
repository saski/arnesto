#!/usr/bin/env bash
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
HERMES_AGENT_DIR="${HERMES_AGENT_DIR:-$HERMES_HOME/hermes-agent}"
GATEWAY_LABEL="${HERMES_GATEWAY_LABEL:-ai.hermes.gateway}"
BACKUP_DIR="${HERMES_UPDATE_BACKUP_DIR:-$HOME/.hermes-update-backups}"
STATE_DIR="$HERMES_HOME/run/safe-update"
STATE_FILE="$STATE_DIR/staged-revision"

usage() {
  printf 'Usage: %s {check|stage|activate}\n' "${0##*/}" >&2
}

require_agent_checkout() {
  if ! git -C "$HERMES_AGENT_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    printf 'Hermes checkout not found: %s\n' "$HERMES_AGENT_DIR" >&2
    exit 2
  fi
}

update_state() {
  git -C "$HERMES_AGENT_DIR" fetch --prune origin

  if [[ -n "$(git -C "$HERMES_AGENT_DIR" status --porcelain)" ]]; then
    printf 'Refusing update: Hermes checkout has local source changes.\n' >&2
    exit 3
  fi

  local current_revision upstream_revision
  current_revision="$(git -C "$HERMES_AGENT_DIR" rev-parse HEAD)"
  upstream_revision="$(git -C "$HERMES_AGENT_DIR" rev-parse origin/main)"
  if [[ "$current_revision" == "$upstream_revision" ]]; then
    printf 'Hermes is already current.\n'
    exit 0
  fi

  if git -C "$HERMES_AGENT_DIR" merge-base --is-ancestor HEAD origin/main; then
    printf 'Update available: current revision is behind origin/main.\n'
    return
  fi

  if git -C "$HERMES_AGENT_DIR" merge-base --is-ancestor origin/main HEAD; then
    printf 'Hermes is already current or contains origin/main.\n'
    exit 0
  fi

  printf 'Refusing update: local and origin/main histories diverge.\n' >&2
  printf 'Create a parallel migration; do not run hermes update in place.\n' >&2
  exit 3
}

stage_update() {
  update_state

  mkdir -p "$BACKUP_DIR" "$STATE_DIR"
  local timestamp archive revision temporary_state
  timestamp="$(date -u '+%Y%m%dT%H%M%SZ')"
  archive="$BACKUP_DIR/hermes-home-$timestamp.tar.gz"
  revision="$(git -C "$HERMES_AGENT_DIR" rev-parse HEAD)"

  tar -C "$(dirname "$HERMES_HOME")" -czf "$archive" "$(basename "$HERMES_HOME")"
  chmod 600 "$archive"
  temporary_state="$(mktemp "$STATE_FILE.XXXXXX")"
  printf '%s\n' "$revision" >"$temporary_state"
  mv "$temporary_state" "$STATE_FILE"

  printf 'Staged update at %s\n' "$revision"
  printf 'Local backup: %s\n' "$archive"
}

activate_update() {
  if [[ ! -f "$STATE_FILE" ]]; then
    printf 'No staged update. Run %s stage first.\n' "${0##*/}" >&2
    exit 2
  fi

  local staged_revision current_revision
  staged_revision="$(<"$STATE_FILE")"
  current_revision="$(git -C "$HERMES_AGENT_DIR" rev-parse HEAD)"
  if [[ "$staged_revision" != "$current_revision" ]]; then
    printf 'Refusing activation: Hermes changed after staging. Run stage again.\n' >&2
    exit 3
  fi

  update_state
  hermes update --backup --yes
  launchctl kickstart -k "gui/$(id -u)/$GATEWAY_LABEL"
  rm -f "$STATE_FILE"
  printf 'Hermes update activated and %s restarted.\n' "$GATEWAY_LABEL"
}

require_agent_checkout

case "${1:-}" in
  check) update_state ;;
  stage) stage_update ;;
  activate) activate_update ;;
  *) usage; exit 2 ;;
esac
