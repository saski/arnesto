#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FACTORY="${SKILL_FACTORY:-$REPO_DIR/../skill-factory}"
OUTPUT_SKILLS="$SKILL_FACTORY/output_skills"
CANONICAL_SKILLS="$REPO_DIR/.agents/skills"
LOCK_PATH="$REPO_DIR/.agents/upstreams/skill-factory/components.lock.json"
LOCAL_SIBLING_LOCK="$REPO_DIR/.agents/upstreams/local-saski-skills/components.lock.json"

is_managed_sibling_symlink() {
    local name="$1"

    if [[ ! -f "$LOCAL_SIBLING_LOCK" ]]; then
        return 1
    fi

    python3 - <<'PY' "$LOCAL_SIBLING_LOCK" "$name"
import json
import sys
from pathlib import Path

lock_path = Path(sys.argv[1])
name = sys.argv[2]
payload = json.loads(lock_path.read_text())
raise SystemExit(0 if name in payload.get("skills", {}) else 1)
PY
}

usage() {
    cat << EOF
Usage: $(basename "$0") [--dry-run]

Imports skill-factory output_skills into this repo's .agents/skills/ as tracked
directories. Native skills and sibling-repo symlinks (see local-saski-skills lock)
are preserved. Previously imported skill-factory skills are refreshed in place
when the checkout descends from the recorded pin. Reviewed adaptations and
packages absent upstream retain their provenance.

  SKILL_FACTORY  Default: \$REPO/../skill-factory (sibling directory)
  --dry-run      List what would be refreshed or imported without writing files

Example:
  SKILL_FACTORY=/path/to/skill-factory ./sync-skill-factory.sh
EOF
}

DRY_RUN=false
case "${1:-}" in
    --help|-h)
        usage
        exit 0
        ;;
    --dry-run)
        DRY_RUN=true
        ;;
    "")
        ;;
        *)
        printf 'error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        exit 1
        ;;
esac

if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required to sync skill-factory" >&2
    exit 1
fi

if [[ ! -d "$OUTPUT_SKILLS" ]]; then
    echo "❌ skill-factory output_skills not found: $OUTPUT_SKILLS"
    echo "   Set SKILL_FACTORY to the skill-factory repo root, or clone it as a sibling."
    exit 1
fi

if [[ ! -d "$CANONICAL_SKILLS" ]]; then
    echo "❌ Canonical skills dir not found: $CANONICAL_SKILLS"
    exit 1
fi

source_commit="$(git -C "$SKILL_FACTORY" rev-parse HEAD)"
source_repository="$({ git -C "$SKILL_FACTORY" config --get remote.origin.url || true; } | python3 -c '
import re
import sys

match = re.fullmatch(
    r"(?:https://github\.com/|(?:ssh://)?git@github\.com(?:-[\w-]+)?[:/])([\w.-]+/[\w.-]+?)(?:\.git)?/?",
    sys.stdin.read().strip(),
)
if match:
    print(match[1])
')"
source_type=github
if [[ -z "$source_repository" ]]; then
    source_repository=local-checkout
    source_type=local-git
fi
if [[ -f "$LOCK_PATH" ]]; then
    pinned_commit="$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["source"]["sourceCommit"])' "$LOCK_PATH")"
    if ! git -C "$SKILL_FACTORY" merge-base --is-ancestor "$pinned_commit" "$source_commit"; then
        printf 'error: skill-factory checkout %s does not descend from reviewed pin %s. Review the upstream changes before refreshing.\n' "$source_commit" "$pinned_commit" >&2
        exit 1
    fi
fi
if [[ -n "$(git -C "$SKILL_FACTORY" status --porcelain -- output_skills)" ]]; then
    echo "error: skill-factory output_skills has uncommitted changes; the recorded commit would not describe the copied bytes." >&2
    exit 1
fi

previous_imports_file="$(mktemp)"
current_imports_file="$(mktemp)"
reviewed_imports_file="$(mktemp)"
trap 'rm -f "$previous_imports_file" "$current_imports_file" "$reviewed_imports_file"' EXIT

python3 - <<'PY' "$LOCK_PATH" > "$previous_imports_file"
import json
import sys
from pathlib import Path

lock_path = Path(sys.argv[1])
if not lock_path.exists():
    raise SystemExit(0)

payload = json.loads(lock_path.read_text())
for name in sorted(payload.get("skills", {})):
    print(name)
PY

python3 - "$LOCK_PATH" > "$reviewed_imports_file" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
if path.exists():
    for name, entry in json.loads(path.read_text()).get("skills", {}).items():
        if entry.get("adapted") or entry.get("upstreamReview"):
            print(name)
PY

added=0
refreshed=0
skipped=0

while IFS= read -r -d '' skill_md; do
    skill_dir="$(dirname "$skill_md")"
    name="$(basename "$skill_dir")"
    target="$CANONICAL_SKILLS/$name"

    if [[ -L "$target" ]] || is_managed_sibling_symlink "$name"; then
        ((skipped++)) || true
        if [[ "$DRY_RUN" == true ]]; then
            echo "  skip (sibling symlink) $name"
        else
            echo "  = $name (sibling symlink preserved)"
        fi
        continue
    fi

    if [[ -e "$target" && ! -L "$target" ]] && ! grep -qx "$name" "$previous_imports_file"; then
        ((skipped++)) || true
        if [[ "$DRY_RUN" == true ]]; then
            echo "  skip (native/custom) $name"
        fi
        continue
    fi

    if grep -Fxq -- "$name" "$reviewed_imports_file"; then
        ((skipped++)) || true
        echo "  skip (reviewed package) $name"
        continue
    fi

    if [[ -e "$target" ]] && ! python3 - "$LOCK_PATH" "$target" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

lock = json.loads(Path(sys.argv[1]).read_text())
package = Path(sys.argv[2])
expected = lock["skills"][package.name].get("computedHash")
digest = hashlib.sha256()
for file in sorted(package.rglob("*")):
    if file.is_file():
        digest.update(file.relative_to(package).as_posix().encode())
        digest.update(file.read_bytes())
raise SystemExit(0 if package.is_dir() and expected == digest.hexdigest() else 1)
PY
    then
        ((skipped++)) || true
        echo "  skip (local edits or unverified package) $name"
        continue
    fi

    printf '%s\n' "$name" >> "$current_imports_file"

    if [[ "$DRY_RUN" == true ]]; then
        if grep -qx "$name" "$previous_imports_file"; then
            echo "  refresh $name"
            ((refreshed++)) || true
        else
            echo "  import $name"
            ((added++)) || true
        fi
        continue
    fi

    rm -rf "$target"
    cp -R "$skill_dir" "$target"
    if grep -qx "$name" "$previous_imports_file"; then
        echo "  ~ $name"
        ((refreshed++)) || true
    else
        echo "  + $name"
        ((added++)) || true
    fi
done < <(find "$OUTPUT_SKILLS" -name "SKILL.md" -type f -print0 2>/dev/null | sort -z)

if [[ "$DRY_RUN" == true ]]; then
    echo ""
    echo "Dry run: would import $added skill(s), refresh $refreshed, skip $skipped."
    exit 0
fi

mkdir -p "$(dirname "$LOCK_PATH")"

python3 - <<'PY' "$OUTPUT_SKILLS" "$LOCK_PATH" "$current_imports_file" "$source_commit" "$source_repository" "$source_type"
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

output_skills = Path(sys.argv[1])
lock_path = Path(sys.argv[2])
imports_file = Path(sys.argv[3])
source_commit = sys.argv[4]
source_repository = sys.argv[5]
source_type = sys.argv[6]
skill_names = [line.strip() for line in imports_file.read_text().splitlines() if line.strip()]

payload = json.loads(lock_path.read_text()) if lock_path.exists() else {"version": 1, "source": {}, "skills": {}}
source = payload["source"]
source.setdefault("repository", source_repository)
source.setdefault("sourceType", source_type)
skills = payload["skills"]

for name in sorted(set(skill_names)):
    matches = list(output_skills.glob(f"**/{name}/SKILL.md"))
    if not matches:
        continue
    source_dir = matches[0].parent
    digest = hashlib.sha256()
    for path in sorted(source_dir.rglob("*")):
        if path.is_file():
            digest.update(str(path.relative_to(source_dir)).encode())
            digest.update(path.read_bytes())
    skills[name] = {
        "source": source_repository,
        "sourceType": source_type,
        "sourceCommit": source_commit,
        "sourcePath": str(source_dir.relative_to(output_skills.parent)).replace("\\", "/"),
        "computedHash": digest.hexdigest(),
        "syncedAt": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
    }

source["sourceCommit"] = source_commit
if (source["repository"], source["sourceType"]) != (source_repository, source_type):
    source["lastSyncRepository"] = source_repository
    source["lastSyncSourceType"] = source_type
else:
    source.pop("lastSyncRepository", None)
    source.pop("lastSyncSourceType", None)
payload["skills"] = dict(sorted(skills.items()))
content = json.dumps(payload, indent=2, ensure_ascii=False) + "\n"
tmp_path = lock_path.with_name(lock_path.name + ".tmp")
tmp_path.write_text(content)
tmp_path.replace(lock_path)
PY

echo ""
echo "✅ Synced: imported $added skill(s), refreshed $refreshed, skipped $skipped."

if [[ "$DRY_RUN" == false && $added -gt 0 ]]; then
    echo ""
    echo "ℹ️  New skills imported: update .agents/docs/skill-domain-routing.md before commit."
    echo "   Run ./validate-skill-library.sh to verify index, catalogs, and routing stay in sync."
fi
