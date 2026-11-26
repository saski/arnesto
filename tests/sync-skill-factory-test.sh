#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SYNC="$REPO_DIR/sync-skill-factory.sh"

assert_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" != *"$needle"* ]]; then
        echo "expected output to contain: $needle" >&2
        echo "--- output ---" >&2
        echo "$haystack" >&2
        exit 1
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" == *"$needle"* ]]; then
        echo "expected output to NOT contain: $needle" >&2
        echo "--- output ---" >&2
        echo "$haystack" >&2
        exit 1
    fi
}

# A typo'd --dry-run must be rejected, not silently executed as a real sync.
# Run with a non-existent SKILL_FACTORY so the script never touches real skills;
# the option rejection must happen before the output_skills existence check.
test_rejects_unknown_option() {
    local output
    set +e
    output="$(SKILL_FACTORY=/nonexistent "$SYNC" --dryrun 2>&1)"
    local exit_code=$?
    set -e

    if [[ $exit_code -eq 0 ]]; then
        echo "expected sync-skill-factory to reject unknown option" >&2
        exit 1
    fi

    assert_contains "$output" "unknown option"
}

test_accepts_dry_run_option() {
    local output
    set +e
    output="$(SKILL_FACTORY=/nonexistent "$SYNC" --dry-run 2>&1)"
    local exit_code=$?
    set -e

    assert_not_contains "$output" "unknown option"
}

test_rejects_unknown_option
test_accepts_dry_run_option

python3 - "$SYNC" <<'PY'
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


with tempfile.TemporaryDirectory(prefix="skill-factory-test-") as scratch:
    root = Path(scratch)
    upstream = root / "upstream"
    upstream.mkdir()

    def git(*args):
        return subprocess.check_output(
            ["git", "-C", str(upstream), *args], text=True, stderr=subprocess.STDOUT
        ).strip()

    git("init", "-q", "-b", "main")
    git("config", "user.name", "Fixture")
    git("config", "user.email", "fixture@example.invalid")
    git("remote", "add", "origin", "git@github.com-saski:actual/factory.git")

    output = upstream / "output_skills"
    adapted = output / "adapted" / "SKILL.md"
    adapted.parent.mkdir(parents=True)
    adapted.write_text("upstream original\n")
    git("add", ".")
    git("commit", "-qm", "common ancestor")
    git("checkout", "-qb", "alternate")
    adapted.write_text("from an unrelated branch\n")
    git("commit", "-qam", "divergent commit")
    git("checkout", "-q", "main")
    adapted.write_text("pinned original\n")
    git("commit", "-qam", "tracked pin")
    pin = git("rev-parse", "HEAD")

    repo = root / "arnesto"
    repo.mkdir()
    sync = repo / "sync-skill-factory.sh"
    shutil.copy2(sys.argv[1], sync)
    skills = repo / ".agents" / "skills"
    for name in ("adapted", "withdrawn"):
        path = skills / name / "SKILL.md"
        path.parent.mkdir(parents=True)
        path.write_text(f"preserved {name}\n")
    lock = repo / ".agents" / "upstreams" / "skill-factory" / "components.lock.json"
    lock.parent.mkdir(parents=True)
    initial = {
        "version": 1,
        "source": {
            "repository": "historical/factory",
            "sourceCommit": pin,
            "verifiedUpstream": {"repository": "actual/factory"},
        },
        "skills": {
            "adapted": {"adapted": True, "sourceCommit": pin},
            "withdrawn": {"sourceCommit": pin},
        },
    }
    lock.write_text(json.dumps(initial))

    def run():
        return subprocess.run(
            ["bash", str(sync)],
            env=dict(os.environ, SKILL_FACTORY=str(upstream)),
            capture_output=True,
            text=True,
        )

    git("checkout", "-q", "alternate")
    result = run()
    assert result.returncode and "does not descend" in result.stderr, result
    assert json.loads(lock.read_text()) == initial

    git("checkout", "-q", "main")
    adapted.write_text("uncommitted output\n")
    result = run()
    assert result.returncode and "uncommitted changes" in result.stderr, result
    assert json.loads(lock.read_text()) == initial

    new = output / "new" / "SKILL.md"
    new.parent.mkdir()
    new.write_text("new upstream package\n")
    git("add", ".")
    git("commit", "-qm", "compatible refresh")
    result = run()
    assert result.returncode == 0, result
    updated = json.loads(lock.read_text())
    assert updated["source"]["verifiedUpstream"] == initial["source"]["verifiedUpstream"]
    assert updated["source"]["lastSyncRepository"] == "actual/factory"
    assert updated["skills"]["new"]["sourceCommit"] == git("rev-parse", "HEAD")
    assert updated["skills"]["new"]["source"] == "actual/factory"
    assert (skills / "new" / "SKILL.md").read_bytes() == new.read_bytes()
    for name, entry in initial["skills"].items():
        assert updated["skills"][name] == entry
        assert (skills / name / "SKILL.md").read_text() == f"preserved {name}\n"

    lock.unlink()
    fresh = output / "fresh" / "SKILL.md"
    fresh.parent.mkdir()
    fresh.write_text("fresh package\n")
    git("add", ".")
    git("commit", "-qm", "fresh import")
    result = run()
    assert result.returncode == 0, result
    created = json.loads(lock.read_text())
    assert created["source"]["repository"] == "actual/factory"
    assert created["skills"]["fresh"]["source"] == "actual/factory"

    local_edit = skills / "fresh" / "SKILL.md"
    local_edit.write_text("locally edited package\n")
    fresh.write_text("changed upstream package\n")
    git("remote", "remove", "origin")
    local_source = output / "local" / "SKILL.md"
    local_source.parent.mkdir()
    local_source.write_text("local checkout package\n")
    git("add", ".")
    git("commit", "-qm", "local-only descendant")
    result = run()
    assert result.returncode == 0 and "skip (local edits or unverified package) fresh" in result.stdout, result
    mixed = json.loads(lock.read_text())
    assert mixed["skills"]["fresh"] == created["skills"]["fresh"]
    assert local_edit.read_text() == "locally edited package\n"
    assert mixed["skills"]["local"]["sourceType"] == "local-git"
    assert mixed["source"]["lastSyncSourceType"] == "local-git"
    assert str(upstream) not in lock.read_text()

    local_source.write_text("changed local checkout package\n")
    git("commit", "-qam", "update clean local package")
    result = run()
    assert result.returncode == 0, result
    clean = json.loads(lock.read_text())
    assert clean["skills"]["local"]["sourceCommit"] == git("rev-parse", "HEAD")
    assert (skills / "local" / "SKILL.md").read_bytes() == local_source.read_bytes()

    lock.unlink()
    git("remote", "add", "origin", "https://fixture-token@example.invalid/team/factory.git")
    another = output / "another" / "SKILL.md"
    another.parent.mkdir()
    another.write_text("another local package\n")
    git("add", ".")
    git("commit", "-qm", "non-GitHub import")
    result = run()
    assert result.returncode == 0, result
    raw = lock.read_text()
    local_lock = json.loads(raw)
    assert local_lock["source"]["repository"] == "local-checkout"
    assert local_lock["source"]["sourceType"] == "local-git"
    assert local_lock["skills"]["another"]["sourceType"] == "local-git"
    assert all(value not in raw for value in ("fixture-token", "example.invalid", str(upstream)))
PY
