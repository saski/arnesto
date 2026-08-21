#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
skill_path="$repo_dir/.agents/skills/source-command-bug-fixing-agent/SKILL.md"

require_text() {
    local text="$1"
    if ! grep -Fiq "$text" "$skill_path"; then
        echo "FAIL: corporate bug-fixing skill is missing: $text" >&2
        exit 1
    fi
}

forbidden_pattern='55e54f92|3d3e0a9b|think step-by-step|<setup_mode>|<plan_mode>|<act_mode>|90% confidence'
if grep -Eiq "$forbidden_pattern" "$skill_path"; then
    echo "FAIL: corporate bug-fixing skill retains source-specific IDs or rigid prompt artifacts" >&2
    exit 1
fi

require_text 'company environment'
require_text 'diagnose'
require_text 'Jira'
require_text 'internal documentation'
require_text 'private repositories'
require_text 'behavior-level test'
require_text 'production mutation'
require_text 'CODEOWNERS'
require_text 'rollback'
require_text 'Do not fabricate access'

echo "PASS: corporate bug-fixing skill has a portable evidence and safety contract"
