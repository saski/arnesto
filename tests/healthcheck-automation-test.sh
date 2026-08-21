#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

assert_file_exists() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        echo "expected file to exist: $path" >&2
        exit 1
    fi
}

assert_file_absent() {
    local path="$1"

    if [[ -e "$path" || -L "$path" ]]; then
        echo "expected file to be absent: $path" >&2
        exit 1
    fi
}

assert_executable() {
    local path="$1"

    if [[ ! -x "$path" ]]; then
        echo "expected file to be executable: $path" >&2
        exit 1
    fi
}

assert_contains() {
    local path="$1"
    local expected="$2"

    if ! grep -Fq "$expected" "$path"; then
        echo "expected $path to contain: $expected" >&2
        exit 1
    fi
}

assert_not_contains() {
    local path="$1"
    local unexpected="$2"

    if grep -Fq "$unexpected" "$path"; then
        echo "expected $path not to contain: $unexpected" >&2
        exit 1
    fi
}

assert_symlink_target() {
    local path="$1"
    local expected="$2"

    if [[ ! -L "$path" ]]; then
        echo "expected symlink: $path" >&2
        exit 1
    fi

    local actual
    actual="$(readlink "$path")"
    if [[ "$actual" != "$expected" ]]; then
        echo "expected $path to point to $expected, got: $actual" >&2
        exit 1
    fi
}

test_healthcheck_automation_contract() {
    local makefile="$REPO_DIR/Makefile"
    local hook="$REPO_DIR/hooks/pre-commit"

    assert_file_exists "$makefile"
    assert_contains "$makefile" "check:"
    assert_contains "$makefile" "test:"
    assert_contains "$makefile" "lint-shell:"
    assert_contains "$makefile" "validate-skills:"
    assert_contains "$makefile" "validate-openspec:"
    assert_contains "$makefile" "validate-symlinks:"
    assert_contains "$makefile" "check-tracked-ignored:"
    assert_contains "$makefile" "install-hooks:"
    assert_contains "$makefile" "git rev-parse --git-path hooks/pre-commit"

    assert_file_exists "$hook"
    assert_executable "$hook"
    assert_contains "$hook" "git rev-parse --show-toplevel"
    assert_contains "$hook" "make check"
}

test_repository_rule_scope_contract() {
    local rules="$REPO_DIR/.agents/rules/repository.md"

    assert_file_exists "$rules"
    assert_contains "$rules" "A portable, multi-tool agent harness for AI-assisted work."
    assert_contains "$rules" 'Read and follow `.agents/rules/base.md`'
    assert_contains "$rules" '`make check`'
    assert_contains "$rules" '`make ci-check`'
    assert_not_contains "$rules" "## Contextual Rules"
    assert_not_contains "$rules" "Route task-specific work through"
}

test_arnesto_identity_contract() {
    local readme="$REPO_DIR/README.md"
    local repository_rules="$REPO_DIR/.agents/rules/repository.md"
    local cursor_rules="$REPO_DIR/.cursor/rules/cursor-config-management.mdc"
    local review_command="$REPO_DIR/.agents/commands/review-pr.md"
    local repo_inventory="$REPO_DIR/saski-github-repos.tsv"

    assert_contains "$readme" '<h1 align="center">Arnesto</h1>'
    assert_contains "$readme" 'git clone https://github.com/saski/arnesto.git'
    assert_contains "$readme" "Eduardo Ferro's augmented-code configuration"
    assert_contains "$repository_rules" "# Arnesto"
    assert_contains "$cursor_rules" "github.com/saski/arnesto"
    assert_not_contains "$cursor_rules" "github.com/saski/augmentedcode-configuration"
    assert_contains "$review_command" "repo: arnesto"
    assert_contains "$repo_inventory" $'augmentedcode-configuration\torigin\tmain\tmain\t-'
}

test_portable_public_defaults_contract() {
    local mcp_config="$REPO_DIR/.agents/mcp.json"
    local codex_rules="$REPO_DIR/.agents/rules/codex-default.rules"

    assert_not_contains "$mcp_config" "eventbrite-be.glean.com"
    assert_not_contains "$codex_rules" "/Users/saski/Documents/"
    assert_not_contains "$codex_rules" "invoke-release"
    assert_not_contains "$codex_rules" "luciastuy.com"
    assert_file_absent "$REPO_DIR/.codex/config.toml"
}

test_progressive_rule_loading_contract() {
    assert_file_absent "$REPO_DIR/.cursor/rules/use-base-rules.mdc"
    assert_file_absent "$REPO_DIR/.cursor/rules/ai-feedback-learning-loop.mdc"
    assert_file_exists "$REPO_DIR/.cursor/rules/cursor-config-management.mdc"
}

test_global_and_repository_rule_wiring_contract() {
    local setup="$REPO_DIR/setup-symlinks.sh"

    assert_symlink_target "$REPO_DIR/AGENTS.md" ".agents/rules/repository.md"
    assert_symlink_target "$REPO_DIR/CLAUDE.md" ".agents/rules/repository.md"
    assert_symlink_target "$REPO_DIR/GEMINI.md" ".agents/rules/repository.md"
    assert_contains "$setup" 'ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/AGENTS.md'
    assert_contains "$setup" 'ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/CLAUDE.md'
    assert_contains "$setup" 'ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/GEMINI.md'
    assert_contains "$setup" 'ln -sfn "$REPO_DIR/.agents/rules/base.md" "$HOME/.gemini/GEMINI.md"'
    assert_contains "$setup" '~/$config should point to .agents/rules/base.md'
}

test_documented_make_targets_exist() {
    local makefile="$REPO_DIR/Makefile"
    local repository_rules="$REPO_DIR/.agents/rules/repository.md"
    local makefile_rules="$REPO_DIR/.agents/rules/makefile-project.md"

    while IFS= read -r target; do
        if ! grep -Eq "^${target}:" "$makefile"; then
            echo "documented make target does not exist: $target" >&2
            exit 1
        fi
    done < <(
        grep -hEo '`make [[:alnum:]_-]+`' "$repository_rules" "$makefile_rules" |
            sed -E 's/`make ([[:alnum:]_-]+)`/\1/' |
            sort -u
    )
}

test_documentation_lookup_routing_contract() {
    local base_rules="$REPO_DIR/.agents/rules/base.md"
    local skill="$REPO_DIR/.agents/skills/documentation-lookup/SKILL.md"
    local mcp_config="$REPO_DIR/.agents/mcp.json"

    assert_contains "$base_rules" "documentation-lookup"
    assert_not_contains "$base_rules" "npx ctx7@latest"
    assert_contains "$skill" "Prefer the Context7 MCP tools when they are available."
    assert_contains "$skill" 'npx ctx7@latest library'
    assert_contains "$skill" 'npx ctx7@latest docs'
    assert_contains "$mcp_config" '"context7"'
}

test_explicit_delegation_routing_contract() {
    local base_rules="$REPO_DIR/.agents/rules/base.md"

    assert_not_contains "$base_rules" "Spawn agents with smaller, lighter models"
    assert_contains "$base_rules" "launching-agent-teams"
    assert_contains "$base_rules" "When the user explicitly requests a bounded, non-sensitive free worker"
}

test_global_rule_budget_contract() {
    local base_rules="$REPO_DIR/.agents/rules/base.md"
    local max_words=900
    local word_count

    assert_not_contains "$base_rules" "catalog-engineering.yaml"
    assert_not_contains "$base_rules" "./validate-skill-library.sh"
    assert_not_contains "$base_rules" "#### Resolution Order"
    assert_contains "$base_rules" "Prefer the skill catalog exposed by the active client"
    assert_not_contains "$base_rules" 'Use `~/.agents/docs/skill-factory-skills.md` to route task-specific work'

    word_count="$(wc -w < "$base_rules" | tr -d ' ')"
    if ((word_count > max_words)); then
        echo "base.md exceeds the ${max_words}-word instruction budget: $word_count" >&2
        exit 1
    fi
}

test_skill_inventory_guidance_contract() {
    local rules="$REPO_DIR/.agents/rules/repository.md"

    assert_file_exists "$rules"
    assert_contains "$rules" "Adding, removing, renaming, or moving any skill"
    assert_contains "$rules" ".agents/docs/skill-factory-skills.md"
    assert_contains "$rules" ".agents/skills/skill-foundry/agents/catalog-engineering.yaml"
    assert_contains "$rules" ".agents/skills/skill-foundry/agents/catalog-product-management.yaml"
    assert_contains "$rules" "./validate-skill-library.sh"
}

test_base_rule_compaction_contract() {
    local rules="$REPO_DIR/.agents/rules/base.md"

    assert_file_exists "$rules"
    assert_contains "$rules" "Think Before Acting"
    assert_contains "$rules" "Simplest Surgical Change"
    assert_contains "$rules" "Goal-Driven Verification"
    assert_contains "$rules" "Checkpoint and Escalate"
    assert_contains "$rules" ".agents/rules/python-project.md"
    assert_contains "$rules" ".agents/rules/makefile-project.md"
    assert_contains "$rules" "git@github.com-saski:"
    assert_not_contains "$rules" "git@github.com-eventbrite:"
    assert_contains "$rules" "### RTK"
    assert_contains "$rules" "documentation-lookup"
    assert_contains "$rules" "personal-knowledge-routing"
    assert_not_contains "$rules" ".agents/rules/pyth![[REDIS_AUTH_REMEDIATION_HANDOFF]]on-project.md"
}

test_codex_orca_runtime_boundary_contract() {
    local runtime_rule="$REPO_DIR/.agents/rules/codex-orca-runtime-boundary.md"
    local runtime_doc="$REPO_DIR/docs/codex-orca-runtime-boundary.md"
    local architecture_doc="$REPO_DIR/docs/local-agentic-development-architecture.md"
    local codex_template="$REPO_DIR/templates/codex/config.toml"

    assert_file_absent "$runtime_rule"
    assert_file_exists "$runtime_doc"
    assert_contains "$runtime_doc" "templates/codex/config.toml"
    assert_not_contains "$runtime_doc" 'model = "gpt-5.6-terra"'
    assert_contains "$architecture_doc" "codex-orca-runtime-boundary.md"
    assert_contains "$codex_template" 'model = "gpt-5.6-terra"'
    assert_contains "$codex_template" 'model_reasoning_effort = "medium"'
}

test_agent_config_hygiene_skill_contract() {
    local skill="$REPO_DIR/.agents/skills/agent-config-hygiene/SKILL.md"

    assert_file_exists "$skill"
    assert_contains "$skill" "name: agent-config-hygiene"
    assert_contains "$skill" "Classify each artifact"
    assert_contains "$skill" "Do not turn this skill into an always-loaded rule"
}

test_managed_tool_path_contract() {
    local gitignore="$REPO_DIR/.gitignore"
    local makefile="$REPO_DIR/Makefile"
    local readme="$REPO_DIR/README.md"
    local setup="$REPO_DIR/setup-symlinks.sh"
    local development_guide="$REPO_DIR/docs/development-guide.md"

    assert_file_exists "$gitignore"
    assert_file_exists "$makefile"
    assert_file_exists "$readme"
    assert_file_exists "$setup"
    assert_file_exists "$development_guide"

    assert_contains "$gitignore" ".agents/bin/"
    assert_contains "$makefile" '$(HOME)/.agents/bin'
    assert_contains "$makefile" '$(HOME)/.bun/bin'
    assert_contains "$makefile" "/opt/homebrew/bin"
    assert_contains "$setup" 'link_managed_binary "rtk"'
    assert_contains "$setup" 'link_managed_binary "openspec"'
    assert_contains "$setup" 'validate_managed_binary "rtk"'
    assert_contains "$setup" 'validate_managed_binary "openspec"'
    assert_contains "$readme" "~/.agents/bin/openspec"
    assert_contains "$development_guide" "~/.agents/bin/openspec"
}

test_healthcheck_automation_contract
test_repository_rule_scope_contract
test_arnesto_identity_contract
test_portable_public_defaults_contract
test_progressive_rule_loading_contract
test_global_and_repository_rule_wiring_contract
test_documented_make_targets_exist
test_documentation_lookup_routing_contract
test_explicit_delegation_routing_contract
test_global_rule_budget_contract
test_skill_inventory_guidance_contract
test_base_rule_compaction_contract
test_codex_orca_runtime_boundary_contract
test_agent_config_hygiene_skill_contract
test_managed_tool_path_contract
