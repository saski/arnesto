#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR="${REPO_DIR:-$SCRIPT_DIR}"
TEMPLATES_DIR="$REPO_DIR/templates"
CODEX_CONFIG_TEMPLATE="$TEMPLATES_DIR/codex/config.toml"
CODEX_HOOKS_TEMPLATE="$TEMPLATES_DIR/codex/hooks.json"
CLAUDE_SETTINGS_TEMPLATE="$TEMPLATES_DIR/claude/settings.json"
OPENCODE_FREE_WORKER_TEMPLATE="$TEMPLATES_DIR/opencode/free-worker.jsonc"
OPENCODE_CONFIG_PATH="$HOME/.config/opencode/opencode.jsonc"
OPENCODE_CONFIG_INSTALLER="$REPO_DIR/lib/install-opencode-free-worker-config.mjs"
CODEX_FREE_WRAPPER="$REPO_DIR/bin/codex-free"
CODEX_FREE_SHELL_LINK="$HOME/.local/bin/codex-free"

# Dev/AI tools under ~ that get a direct "$HOME/$tool/skills" symlink.
# Cursor and Codex are handled separately due tool-specific directory layouts.
# Add or remove dot-dir names to cover any dev tool config (e.g. .copilot, .kiro).
TOOLS_WITH_SKILLS=".antigravity .gemini .langflow"

usage() {
    cat << EOF
Usage: $(basename $0) [command]

Commands:
  setup     - Create all symlinks (first-time setup or repair)
  opencode-free-worker - Safely install managed OpenCode free-worker fields
  validate  - Verify all symlinks are correct
  validate-opencode-free-worker - Verify managed OpenCode free-worker fields
  status    - Show git status of config changes
  commit    - Stage, commit, and push config changes
  help      - Show this help message

Examples:
  $(basename $0) setup      # Initial setup on new machine
  $(basename $0) validate   # Check symlinks are intact
  $(basename $0) commit     # Commit and push config changes
EOF
    exit 1
}

# Verify we're in the right place
check_environment() {
    if [ ! -d "$REPO_DIR" ]; then
        echo "❌ Repository not found at $REPO_DIR"
        exit 1
    fi

    if [ ! -d "$REPO_DIR/.cursor" ]; then
        echo "❌ .cursor directory not found in repo"
        exit 1
    fi

    if [ ! -f "$REPO_DIR/.agents/mcp.json" ]; then
        echo "❌ .agents/mcp.json not found in repo"
        exit 1
    fi

    if [ ! -f "$REPO_DIR/.cursor/cli-config.json" ]; then
        echo "❌ .cursor/cli-config.json not found in repo"
        exit 1
    fi

    if [ ! -f "$CODEX_CONFIG_TEMPLATE" ]; then
        echo "❌ templates/codex/config.toml not found in repo"
        exit 1
    fi

    if [ ! -f "$CODEX_HOOKS_TEMPLATE" ]; then
        echo "❌ templates/codex/hooks.json not found in repo"
        exit 1
    fi

    if [ ! -f "$REPO_DIR/.agents/rules/codex-default.rules" ]; then
        echo "❌ .agents/rules/codex-default.rules not found in repo"
        exit 1
    fi

    if [ ! -f "$REPO_DIR/.agents/hooks/rtk-rewrite.sh" ]; then
        echo "❌ .agents/hooks/rtk-rewrite.sh not found in repo"
        exit 1
    fi

    if [ ! -f "$REPO_DIR/GEMINI.md" ]; then
        echo "❌ GEMINI.md not found in repo"
        exit 1
    fi

    if [ ! -d "$REPO_DIR/.claude/hooks" ]; then
        echo "❌ .claude/hooks directory not found in repo"
        exit 1
    fi

    if [ ! -f "$CLAUDE_SETTINGS_TEMPLATE" ]; then
        echo "❌ templates/claude/settings.json not found in repo"
        exit 1
    fi

    if [ ! -f "$OPENCODE_FREE_WORKER_TEMPLATE" ]; then
        echo "❌ templates/opencode/free-worker.jsonc not found in repo"
        exit 1
    fi

    if [ ! -f "$OPENCODE_CONFIG_INSTALLER" ]; then
        echo "❌ lib/install-opencode-free-worker-config.mjs not found in repo"
        exit 1
    fi

    if [ ! -x "$CODEX_FREE_WRAPPER" ]; then
        echo "❌ bin/codex-free is missing or not executable"
        exit 1
    fi
}

check_opencode_environment() {
    if [ ! -d "$REPO_DIR" ]; then
        echo "❌ Repository not found at $REPO_DIR"
        exit 1
    fi

    if [ ! -f "$OPENCODE_FREE_WORKER_TEMPLATE" ]; then
        echo "❌ templates/opencode/free-worker.jsonc not found in repo"
        exit 1
    fi

    if [ ! -f "$OPENCODE_CONFIG_INSTALLER" ]; then
        echo "❌ lib/install-opencode-free-worker-config.mjs not found in repo"
        exit 1
    fi
}

ensure_local_directory() {
    local path="$1"

    if [ -L "$path" ]; then
        rm "$path"
    fi

    mkdir -p "$path"
}

install_template_file() {
    local template_path="$1"
    local destination_path="$2"

    mkdir -p "$(dirname "$destination_path")"

    if [ -L "$destination_path" ]; then
        rm "$destination_path"
    fi

    if [ ! -f "$destination_path" ]; then
        cp "$template_path" "$destination_path"
    fi
}

link_managed_path() {
    local source_path="$1"
    local destination_path="$2"

    mkdir -p "$(dirname "$destination_path")"
    ln -sfn "$source_path" "$destination_path"
}

link_codex_free_shell_entry() {
    mkdir -p "$(dirname "$CODEX_FREE_SHELL_LINK")"

    if [ -e "$CODEX_FREE_SHELL_LINK" ] && [ ! -L "$CODEX_FREE_SHELL_LINK" ]; then
        echo "❌ $CODEX_FREE_SHELL_LINK exists and is not a symlink; refusing to replace it"
        return 1
    fi

    ln -sfn "$CODEX_FREE_WRAPPER" "$CODEX_FREE_SHELL_LINK"
    echo "✓ $CODEX_FREE_SHELL_LINK → $CODEX_FREE_WRAPPER"
}

link_managed_binary() {
    local name="$1"
    shift
    local destination_path="$HOME/.agents/bin/$name"
    local candidate

    for candidate in "$@"; do
        if [ -z "$candidate" ] || [ "$candidate" = "$destination_path" ]; then
            continue
        fi

        if [ -x "$candidate" ]; then
            ln -sfn "$candidate" "$destination_path"
            echo "✓ $destination_path → $candidate"
            return 0
        fi
    done

    echo "⚠️  $name executable not found; $destination_path was not linked"
    return 1
}

validate_managed_binary() {
    local name="$1"
    shift
    local destination_path="$HOME/.agents/bin/$name"
    local found_candidate=0
    local candidate

    for candidate in "$@"; do
        if [ -n "$candidate" ] && [ "$candidate" != "$destination_path" ] && [ -x "$candidate" ]; then
            found_candidate=1
            break
        fi
    done

    if [ "$found_candidate" -eq 0 ]; then
        echo "⚠️  $name executable not found in known locations; skipping $destination_path validation"
        return 0
    fi

    if [ ! -L "$destination_path" ]; then
        echo "❌ $destination_path is not a symlink (run ./setup-symlinks.sh setup to repair managed tool shims)"
        return 1
    fi

    if [ ! -e "$destination_path" ]; then
        echo "❌ $destination_path is a broken symlink"
        return 1
    fi

    local target
    target=$(readlink "$destination_path")
    if [ ! -x "$target" ]; then
        echo "❌ $destination_path points to a non-executable target: $target"
        return 1
    fi

    echo "✓ $destination_path → $target"
}

# Resolve a binary on PATH excluding the managed ~/.agents/bin directory,
# so probes do not match the managed shim itself (circular self-match).
resolve_path_binary() {
    local name="$1"
    local stripped=""
    local IFS=':'
    local entry
    for entry in $PATH; do
        [ "$entry" = "$HOME/.agents/bin" ] && continue
        stripped="${stripped:+$stripped:}$entry"
    done
    PATH="$stripped" command -v "$name" 2>/dev/null || true
}

setup_claude_config() {
    ensure_local_directory "$HOME/.claude"

    link_managed_path "$REPO_DIR/.agents/commands" "$HOME/.claude/commands"
    link_managed_path "$REPO_DIR/.agents/skills" "$HOME/.claude/skills"
    link_managed_path "$REPO_DIR/.claude/hooks" "$HOME/.claude/hooks"

    install_template_file "$CLAUDE_SETTINGS_TEMPLATE" "$HOME/.claude/settings.json"
}

setup_opencode_free_worker_config() {
    node "$OPENCODE_CONFIG_INSTALLER" install "$OPENCODE_FREE_WORKER_TEMPLATE" "$OPENCODE_CONFIG_PATH"
}

validate_opencode_free_worker_config() {
    node "$OPENCODE_CONFIG_INSTALLER" validate "$OPENCODE_FREE_WORKER_TEMPLATE" "$OPENCODE_CONFIG_PATH"
}

validate_codex_config_invariants() {
    local config_path="$HOME/.codex/config.toml"
    local expected_line
    local errors=0

    for expected_line in \
        'model_reasoning_effort = "medium"' \
        'personality = "pragmatic"'; do
        if ! grep -Fqx -- "$expected_line" "$config_path"; then
            echo "❌ $config_path must contain: $expected_line"
            errors=$((errors + 1))
        fi
    done

    if ! awk '
        /^\[features\]$/ { in_features = 1; next }
        /^\[/ { in_features = 0 }
        in_features && $0 == "multi_agent = true" { found = 1 }
        END { exit !found }
    ' "$config_path"; then
        echo "❌ $config_path must enable multi_agent in [features]"
        errors=$((errors + 1))
    fi

    if [ "$errors" -eq 0 ]; then
        echo "✓ $config_path matches required Codex invariants"
        return 0
    fi

    return 1
}

setup_symlinks() {
    echo "🔗 Setting up symlinks..."

    # Create .cursor symlinks (skills → canonical .agents/skills)
    mkdir -p ~/.cursor
    ln -sfn "$REPO_DIR/.cursor/commands" ~/.cursor/commands
    ln -sfn "$REPO_DIR/.agents/skills" ~/.cursor/skills
    ln -sfn "$REPO_DIR/.cursor/skills-cursor" ~/.cursor/skills-cursor
    ln -sfn "$REPO_DIR/.agents" ~/.cursor/.agents
    ln -sfn "$REPO_DIR/.agents/mcp.json" ~/.cursor/mcp.json
    ln -sfn "$REPO_DIR/.cursor/cli-config.json" ~/.cursor/cli-config.json

    # Codex keeps local system skills under ~/.codex/skills/.system.
    # Link shared skills and shared rules into ~/.codex.
    mkdir -p "$HOME/.codex/skills" "$HOME/.codex/rules" "$HOME/.codex/hooks"
    ln -sfn "$REPO_DIR/.agents/skills" "$HOME/.codex/skills/skills"
    install_template_file "$CODEX_CONFIG_TEMPLATE" "$HOME/.codex/config.toml"
    install_template_file "$CODEX_HOOKS_TEMPLATE" "$HOME/.codex/hooks.json"
    ln -sfn "$REPO_DIR/.agents/hooks/rtk-rewrite.sh" "$HOME/.codex/hooks/rtk-rewrite.sh"
    ln -sfn "$REPO_DIR/.agents/rules/codex-default.rules" "$HOME/.codex/rules/default.rules"
    ln -sfn "$REPO_DIR/.agents/rules/base.md" "$HOME/.codex/AGENTS.md"

    # Other dev/AI tools: point skills at canonical .agents/skills
    for tool in $TOOLS_WITH_SKILLS; do
        mkdir -p "$HOME/$tool"
        ln -sfn "$REPO_DIR/.agents/skills" "$HOME/$tool/skills"
    done

    # Gemini: use shared MCP config, commands, and workflows from canonical .agents path.
    mkdir -p "$HOME/.gemini/antigravity"
    ln -sfn "$REPO_DIR/.agents/mcp.json" "$HOME/.gemini/antigravity/mcp_config.json"
    ln -sfn "$REPO_DIR/.agents/rules/base.md" "$HOME/.gemini/GEMINI.md"
    ln -sfn "$REPO_DIR/.agents/workflows" "$HOME/.gemini/antigravity/workflows"
    ln -sfn "$REPO_DIR/.agents/commands" "$HOME/.gemini/antigravity/commands"
    ln -sfn "$REPO_DIR/.agents/skills" "$HOME/.gemini/antigravity/skills"

    # Home-level .agents should always resolve to canonical repo .agents
    # so there is no divergent local skill source.
    if [ -d "$HOME/.agents" ] && [ ! -L "$HOME/.agents" ]; then
        echo "⚠️  Found existing ~/.agents directory (not a symlink)"
        echo "   Please move it to a backup location, then rerun setup."
        exit 1
    fi
    ln -sfn "$REPO_DIR/.agents" "$HOME/.agents"
    mkdir -p "$HOME/.agents/bin"
    link_managed_binary "rtk" \
        "/opt/homebrew/bin/rtk" \
        "/usr/local/bin/rtk" \
        "$(resolve_path_binary rtk)" || true
    link_managed_binary "openspec" \
        "/opt/homebrew/bin/openspec" \
        "$HOME/.bun/bin/openspec" \
        "/usr/local/bin/openspec" \
        "$(resolve_path_binary openspec)" || true
    link_managed_binary "codex-free" "$CODEX_FREE_WRAPPER"
    link_codex_free_shell_entry

    setup_claude_config
    setup_opencode_free_worker_config

    # Create home-level global instruction symlinks.
    ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/CLAUDE.md
    ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/AGENTS.md
    ln -sfn "$REPO_DIR/.agents/rules/base.md" ~/GEMINI.md

    echo "✅ Symlinks created"
}

# Validate all symlinks
validate_symlinks() {
    echo "🔍 Validating symlinks..."

    local errors=0

    if ! validate_opencode_free_worker_config; then
        errors=$((errors + 1))
    fi

    # Check .cursor symlinks
    for link in commands skills skills-cursor .agents; do
        local path="$HOME/.cursor/$link"
        if [ ! -L "$path" ]; then
            echo "❌ $path is not a symlink"
            errors=$((errors + 1))
        elif [ ! -e "$path" ]; then
            echo "❌ $path is a broken symlink"
            errors=$((errors + 1))
        else
            local target
            target=$(readlink "$path")
            if [ "$link" = "skills" ] && [[ "$target" != *".agents/skills" ]]; then
                echo "❌ $path should point to .agents/skills, got: $target"
                errors=$((errors + 1))
            else
                echo "✓ ~/.cursor/$link → $target"
            fi
        fi
    done

    # Check Cursor managed config files
    for file in cli-config.json; do
        local path="$HOME/.cursor/$file"
        if [ ! -L "$path" ]; then
            echo "❌ $path is not a symlink"
            errors=$((errors + 1))
        elif [ ! -e "$path" ]; then
            echo "❌ $path is a broken symlink"
            errors=$((errors + 1))
        else
            local target
            target=$(readlink "$path")
            if [[ "$target" != *".cursor/$file" ]]; then
                echo "❌ $path should point to repo .cursor/$file, got: $target"
                errors=$((errors + 1))
            else
                echo "✓ $path → $target"
            fi
        fi
    done

    # Check Cursor shared MCP config symlink
    local cursor_mcp_path="$HOME/.cursor/mcp.json"
    if [ ! -L "$cursor_mcp_path" ]; then
        echo "❌ $cursor_mcp_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$cursor_mcp_path" ]; then
        echo "❌ $cursor_mcp_path is a broken symlink"
        errors=$((errors + 1))
    else
        local cursor_mcp_target
        cursor_mcp_target=$(readlink "$cursor_mcp_path")
        if [[ "$cursor_mcp_target" != *".agents/mcp.json" ]]; then
            echo "❌ $cursor_mcp_path should point to repo .agents/mcp.json, got: $cursor_mcp_target"
            errors=$((errors + 1))
        else
            echo "✓ $cursor_mcp_path → $cursor_mcp_target"
        fi
    fi

    # Check Codex skills symlink (nested path due ~/.codex/skills/.system)
    local codex_path="$HOME/.codex/skills/skills"
    if [ ! -L "$codex_path" ]; then
        echo "❌ $codex_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$codex_path" ]; then
        echo "❌ $codex_path is a broken symlink"
        errors=$((errors + 1))
    else
        local codex_target
        codex_target=$(readlink "$codex_path")
        if [[ "$codex_target" != *".agents/skills" ]]; then
            echo "❌ $codex_path should point to .agents/skills, got: $codex_target"
            errors=$((errors + 1))
        else
            echo "✓ $codex_path → .agents/skills"
        fi
    fi

    # Check Codex managed config files
    local codex_config_path="$HOME/.codex/config.toml"
    if [ ! -f "$codex_config_path" ]; then
        echo "❌ $codex_config_path is missing"
        errors=$((errors + 1))
    elif [ -L "$codex_config_path" ]; then
        echo "❌ $codex_config_path should be a local file, not a symlink"
        errors=$((errors + 1))
    else
        echo "✓ $codex_config_path is a local managed file"
        validate_codex_config_invariants || errors=$((errors + 1))
    fi

    local codex_hooks_json_path="$HOME/.codex/hooks.json"
    if [ ! -f "$codex_hooks_json_path" ]; then
        echo "❌ $codex_hooks_json_path is missing"
        errors=$((errors + 1))
    elif [ -L "$codex_hooks_json_path" ]; then
        echo "❌ $codex_hooks_json_path should be a local file, not a symlink"
        errors=$((errors + 1))
    elif ! grep -Fq "rtk-rewrite.sh" "$codex_hooks_json_path"; then
        echo "❌ $codex_hooks_json_path should configure the RTK rewrite hook"
        errors=$((errors + 1))
    else
        echo "✓ $codex_hooks_json_path is a local managed file with RTK hook wiring"
    fi

    local codex_hook_path="$HOME/.codex/hooks/rtk-rewrite.sh"
    if [ ! -L "$codex_hook_path" ]; then
        echo "❌ $codex_hook_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$codex_hook_path" ]; then
        echo "❌ $codex_hook_path is a broken symlink"
        errors=$((errors + 1))
    else
        local codex_hook_target
        codex_hook_target=$(readlink "$codex_hook_path")
        if [[ "$codex_hook_target" != *".agents/hooks/rtk-rewrite.sh" ]]; then
            echo "❌ $codex_hook_path should point to .agents/hooks/rtk-rewrite.sh, got: $codex_hook_target"
            errors=$((errors + 1))
        else
            echo "✓ $codex_hook_path → $codex_hook_target"
        fi
    fi

    # Check Codex shared rules symlink
    local codex_rules_path="$HOME/.codex/rules/default.rules"
    if [ ! -L "$codex_rules_path" ]; then
        echo "❌ $codex_rules_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$codex_rules_path" ]; then
        echo "❌ $codex_rules_path is a broken symlink"
        errors=$((errors + 1))
    else
        local codex_rules_target
        codex_rules_target=$(readlink "$codex_rules_path")
        if [[ "$codex_rules_target" != *".agents/rules/codex-default.rules" ]]; then
            echo "❌ $codex_rules_path should point to repo .agents/rules/codex-default.rules, got: $codex_rules_target"
            errors=$((errors + 1))
        else
            echo "✓ $codex_rules_path → $codex_rules_target"
        fi
    fi

    # Check Codex instructions symlink
    local codex_agents_path="$HOME/.codex/AGENTS.md"
    if [ ! -L "$codex_agents_path" ]; then
        echo "❌ $codex_agents_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$codex_agents_path" ]; then
        echo "❌ $codex_agents_path is a broken symlink"
        errors=$((errors + 1))
    else
        local codex_agents_target
        codex_agents_target=$(readlink "$codex_agents_path")
        if [[ "$codex_agents_target" != *"/.agents/rules/base.md" ]]; then
            echo "❌ $codex_agents_path should point to .agents/rules/base.md, got: $codex_agents_target"
            errors=$((errors + 1))
        else
            echo "✓ $codex_agents_path → $codex_agents_target"
        fi
    fi

    # Check skills symlinks for other dev tools (must point to repo .agents/skills)
    for tool in $TOOLS_WITH_SKILLS; do
        local path="$HOME/$tool/skills"
        if [ ! -L "$path" ]; then
            echo "❌ $path is not a symlink"
            errors=$((errors + 1))
        elif [ ! -e "$path" ]; then
            echo "❌ $path is a broken symlink"
            errors=$((errors + 1))
        else
            local target
            target=$(readlink "$path")
            if [[ "$target" != *".agents/skills" ]]; then
                echo "❌ $path should point to .agents/skills, got: $target"
                errors=$((errors + 1))
            else
                echo "✓ $path → .agents/skills"
            fi
        fi
    done

    # Check .claude managed layout
    if [ ! -d "$HOME/.claude" ] || [ -L "$HOME/.claude" ]; then
        echo "❌ ~/.claude should be a local directory"
        errors=$((errors + 1))
    else
        echo "✓ ~/.claude is a local directory"
    fi

    for path in commands skills hooks; do
        local claude_path="$HOME/.claude/$path"
        if [ ! -L "$claude_path" ]; then
            echo "❌ $claude_path is not a symlink"
            errors=$((errors + 1))
        elif [ ! -e "$claude_path" ]; then
            echo "❌ $claude_path is a broken symlink"
            errors=$((errors + 1))
        else
            echo "✓ $claude_path → $(readlink "$claude_path")"
        fi
    done

    local claude_settings_path="$HOME/.claude/settings.json"
    if [ ! -f "$claude_settings_path" ]; then
        echo "❌ $claude_settings_path is missing"
        errors=$((errors + 1))
    elif [ -L "$claude_settings_path" ]; then
        echo "❌ $claude_settings_path should be a local file, not a symlink"
        errors=$((errors + 1))
    else
        echo "✓ $claude_settings_path is a local managed file"
    fi

    # Check Gemini MCP config symlink
    local gemini_mcp_path="$HOME/.gemini/antigravity/mcp_config.json"
    if [ ! -L "$gemini_mcp_path" ]; then
        echo "❌ $gemini_mcp_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$gemini_mcp_path" ]; then
        echo "❌ $gemini_mcp_path is a broken symlink"
        errors=$((errors + 1))
    else
        local gemini_mcp_target
        gemini_mcp_target=$(readlink "$gemini_mcp_path")
        if [[ "$gemini_mcp_target" != *".agents/mcp.json" ]]; then
            echo "❌ $gemini_mcp_path should point to repo .agents/mcp.json, got: $gemini_mcp_target"
            errors=$((errors + 1))
        else
            echo "✓ $gemini_mcp_path → $gemini_mcp_target"
        fi
    fi

    # Check Gemini commands, workflows, and skills symlinks
    for dir in workflows commands skills; do
        local path="$HOME/.gemini/antigravity/$dir"
        if [ ! -L "$path" ]; then
            echo "❌ $path is not a symlink"
            errors=$((errors + 1))
        elif [ ! -e "$path" ]; then
            echo "❌ $path is a broken symlink"
            errors=$((errors + 1))
        else
            local target
            target=$(readlink "$path")
            if [[ "$target" != *".agents/$dir" ]]; then
                echo "❌ $path should point to repo .agents/$dir, got: $target"
                errors=$((errors + 1))
            else
                echo "✓ $path → $target"
            fi
        fi
    done

    # Check Gemini instructions symlink
    local gemini_rules_path="$HOME/.gemini/GEMINI.md"
    if [ ! -L "$gemini_rules_path" ]; then
        echo "❌ $gemini_rules_path is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$gemini_rules_path" ]; then
        echo "❌ $gemini_rules_path is a broken symlink"
        errors=$((errors + 1))
    else
        local gemini_rules_target
        gemini_rules_target=$(readlink "$gemini_rules_path")
        if [[ "$gemini_rules_target" != *"/.agents/rules/base.md" ]]; then
            echo "❌ $gemini_rules_path should point to .agents/rules/base.md, got: $gemini_rules_target"
            errors=$((errors + 1))
        else
            echo "✓ $gemini_rules_path → $gemini_rules_target"
        fi
    fi

    # Check ~/.agents canonical link
    if [ ! -L "$HOME/.agents" ]; then
        echo "❌ ~/.agents is not a symlink"
        errors=$((errors + 1))
    elif [ ! -e "$HOME/.agents" ]; then
        echo "❌ ~/.agents is a broken symlink"
        errors=$((errors + 1))
    else
        local agents_target
        agents_target=$(readlink "$HOME/.agents")
        if [ "$agents_target" != "$REPO_DIR/.agents" ]; then
            echo "❌ ~/.agents should point to repo .agents, got: $agents_target"
            errors=$((errors + 1))
        else
            echo "✓ ~/.agents → $agents_target"
        fi
    fi

    local agents_bin_path="$HOME/.agents/bin"
    if [ ! -d "$agents_bin_path" ]; then
        echo "❌ $agents_bin_path is missing (run ./setup-symlinks.sh setup to create it)"
        errors=$((errors + 1))
    else
        echo "✓ $agents_bin_path exists"
    fi

    validate_managed_binary "rtk" \
        "/opt/homebrew/bin/rtk" \
        "/usr/local/bin/rtk" \
        "$(resolve_path_binary rtk)" || errors=$((errors + 1))
    validate_managed_binary "openspec" \
        "/opt/homebrew/bin/openspec" \
        "$HOME/.bun/bin/openspec" \
        "/usr/local/bin/openspec" \
        "$(resolve_path_binary openspec)" || errors=$((errors + 1))
    validate_managed_binary "codex-free" "$CODEX_FREE_WRAPPER" || errors=$((errors + 1))

    if [ ! -L "$CODEX_FREE_SHELL_LINK" ]; then
        echo "❌ $CODEX_FREE_SHELL_LINK is not a symlink (run ./setup-symlinks.sh setup to expose codex-free on PATH)"
        errors=$((errors + 1))
    elif [ "$(readlink "$CODEX_FREE_SHELL_LINK")" != "$CODEX_FREE_WRAPPER" ]; then
        echo "❌ $CODEX_FREE_SHELL_LINK points to $(readlink "$CODEX_FREE_SHELL_LINK"), expected $CODEX_FREE_WRAPPER"
        errors=$((errors + 1))
    else
        echo "✓ $CODEX_FREE_SHELL_LINK → $CODEX_FREE_WRAPPER"
    fi

    # Check root configs
    for config in CLAUDE.md AGENTS.md GEMINI.md; do
        local path="$HOME/$config"
        if [ ! -L "$path" ]; then
            echo "❌ ~/$config is not a symlink"
            errors=$((errors + 1))
        else
            local target
            target=$(readlink "$path")
            if [[ "$target" != *"/.agents/rules/base.md" ]]; then
                echo "❌ ~/$config should point to .agents/rules/base.md, got: $target"
                errors=$((errors + 1))
            else
                echo "✓ ~/$config → $target"
            fi
        fi
    done

    if [ $errors -eq 0 ]; then
        echo ""
        echo "✅ All symlinks valid"
        return 0
    else
        echo ""
        echo "❌ Found $errors symlink issues"
        return 1
    fi
}

# Show git status
show_status() {
    echo "📊 Configuration changes:"
    cd "$REPO_DIR"
    git status --short .cursor/ .claude/ .gemini/ .agents/ templates/ *.md 2>/dev/null || true
}

# Commit and push changes
commit_changes() {
    cd "$REPO_DIR"

    if git diff --quiet .cursor/ .claude/ .gemini/ .agents/ templates/ *.md 2>/dev/null; then
        echo "ℹ️  No config changes to commit"
        exit 0
    fi

    echo "📝 Changes to commit:"
    git status --short .cursor/ .claude/ .gemini/ .agents/ templates/ *.md
    echo ""

    read -p "Commit message: " -r message

    if [ -z "$message" ]; then
        echo "❌ Commit message required"
        exit 1
    fi

    git add .cursor/ .claude/ .gemini/ .agents/ templates/ *.md
    git commit -m "$message"

    read -p "Push to remote? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push
        echo "✅ Changes pushed"
    else
        echo "ℹ️  Changes committed locally (not pushed)"
    fi
}

# Main
case "${1:-help}" in
    setup)
        check_environment
        setup_symlinks
        ;;
    opencode-free-worker)
        check_opencode_environment
        setup_opencode_free_worker_config
        ;;
    validate)
        check_environment
        validate_symlinks
        ;;
    validate-opencode-free-worker)
        check_opencode_environment
        validate_opencode_free_worker_config
        ;;
    status|commit)
        check_environment
        if [ "${1:-help}" = "status" ]; then
            show_status
        else
            commit_changes
        fi
        ;;
    help|*)
        usage
        ;;
esac
