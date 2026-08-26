# Cursor-only skills (`.cursor/skills-cursor/`)

Cursor loads two skill directories from this repo via `setup-symlinks.sh`:

| Symlink | Canonical path | Audience |
|---------|----------------|----------|
| `~/.cursor/skills` | `.agents/skills/` | Shared across Cursor, Codex, Claude, Gemini, and other tools |
| `~/.cursor/skills-cursor` | `.cursor/skills-cursor/` | Cursor IDE only (meta-skills, Canvas, SDK, loops) |

Do **not** copy these into `.agents/skills/` or the skill-factory sync workflow. They are versioned here and exposed only through `~/.cursor/skills-cursor`.

For shared skills, use [skill-factory-skills.md](skill-factory-skills.md) and [skill-domain-routing.md](skill-domain-routing.md).

## Inventory

| Skill | Category | Purpose |
|-------|----------|---------|
| automate | ide | Create Cursor Automations through the Automations editor handoff, with trigger, tool, prompt, and integration completeness checks. |
| autopilot | ide | Keep a PR merge-ready by triaging comments, resolving clear conflicts, and fixing CI in a loop. |
| canvas | ide | Live React Canvas beside the chat for analytical artifacts, charts, tables, and MCP-heavy deliverables; also required when editing `.canvas.tsx` files. |
| goal | ide | Set a durable objective that Cursor pursues across turns until an evidence-based completion audit passes. |
| loop | ide | Run a prompt or skill repeatedly through cloud subscription timers or monitored local shell output. |
| new-repo | ide | Create and push a Cursor-hosted repository for a project that has no existing remote. |
| onboard | ide | Focused Cursor onboarding flow that learns basic preferences, picks a first goal, and routes the user to the right next action (`/onboard`). |
| origin | ide | Install, authenticate, update, and repair the CLI for Cursor-hosted repositories. |
| rename-chat | ide | Rename the current Cursor chat to a concise topic title when the user explicitly invokes `/rename-chat`. |
| review | ide | Route a code review request to either Bugbot or Security Review. |
| review-bugbot | ide | Review code changes with the Bugbot subagent. |
| review-security | ide | Review code changes with the Security Review subagent. |
| sdk | ide | Build on the Cursor SDK (`@cursor/sdk`, `cursor-sdk`) from scripts, CI, or backends; agents, streaming, MCP, and errors. |
| share | ide | Save or share a project through a private Cursor-hosted repository, with novice-friendly framing. |
| shell | ide | Run the rest of a `/shell` request as a literal shell command when the user explicitly invokes it. |
| split-to-prs | ide | Split current work into small reviewable PRs from a chat, branch, or PR. |
| statusline | ide | Configure a custom CLI status line (`statusline`, `statusLine`, prompt footer). |
| create-hook | meta | Create Cursor hooks (`hooks.json`, lifecycle automation around agent events). |
| create-rule | meta | Create Cursor rules for persistent AI guidance (`.cursor/rules/`). |
| create-skill | meta | Author Agent Skills; points canonical shared skills at `.agents/skills/`. |
| create-subagent | meta | Create custom subagents for specialized tasks. |
| migrate-to-skills | meta | Convert Cursor rules (`.mdc`) and slash commands to Agent Skills. |
| update-cli-config | config | View and modify `~/.cursor/cli-config.json`. |
| update-cursor-settings | config | Modify Cursor/VSCode `settings.json` preferences. |

## Maintenance

When adding, removing, or renaming a skill under `.cursor/skills-cursor/`:

1. Update this inventory table in the same change.
2. Run `./validate-cursor-skills.sh` or `make validate-cursor-skills`.
3. Do **not** update skill-factory catalogs, `skill-domain-routing.md`, or `pull-and-sync-skills.sh`.

After pulling Cursor IDE updates that touch `skills-cursor`, commit the repo changes so other machines pick them up via `./setup-symlinks.sh setup`.
