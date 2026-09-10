# Development Guide

This document covers repository-internal structure, sync workflows, and validation for maintainers.

## Canonical Sources

- `.agents/rules/` is the shared rulebook.
- `.agents/skills/` is the canonical shared skill library.
- `.agents/commands/` is the canonical shared command library.
- `.agents/mcp.json` is the shared MCP configuration.
- `.agents/hooks/` is the canonical shared hook location (including RTK rewrite hook).
- `.agents/bin/` contains ignored local tool shims created by `setup-symlinks.sh`.
- `docs/openspec/` is the OpenSpec artifact root for this tooling repo, exposed through the root `openspec` symlink for CLI compatibility.
- `.cursor/skills-cursor/` contains Cursor-only skills (Canvas, SDK, meta-skills). Inventory: `.agents/docs/cursor-skills.md`. Not part of skill-factory sync or `validate-skill-library.sh`.
- `~/.cursor/skills` points at `.agents/skills/`; it is not a separate tracked tree under `.cursor/skills/`.

## Rule Model

`.agents/rules/base.md` is the compact home-level rulebook shared across repositories. Its universal behavior is organized around four operating principles: Think Before Acting, Simplest Surgical Change, Goal-Driven Verification, and Checkpoint and Escalate.

`.agents/rules/repository.md` is the bootstrap for this checkout: it owns the
project description, canonical validation commands, and skill-library
governance. Root `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` shims point to it.
The universal rulebook owns contextual-rule triggers so repository shims do not
repeat them.

The `Codex with Astra` section of `base.md` applies only to that client/model
combination. It adapts the [official Astra prompting guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra#gpt-6-astra-prompting-best-practices),
reviewed on 2026-09-06. Codex already loads this file through its existing
`~/.codex/AGENTS.md` link; no new setup step is required. The Codex template
retains Terra Medium. Model selection remains in `codex-model-routing`.
This instruction adaptation does not migrate API requests or alter runtime
configuration. Behavior with Astra still requires evaluation on real tasks.

The Codex invariant test enforces Terra Medium in the repository template.
Local validation allows a different model selection and setup preserves it.
Medium reasoning, pragmatic personality, and multi-agent enablement remain
required local invariants.

Repo-type details belong in contextual rule files such as `.agents/rules/python-project.md` and `.agents/rules/makefile-project.md`. Task-specific workflows belong in skills. Do not add generic best-practice prose to `base.md` unless it routes concrete behavior that agents cannot reliably infer from the codebase or user request.

Cursor consumes the home-level and repository `AGENTS.md` hierarchy directly.
Do not add an always-applied Cursor wrapper that includes `base.md` or
`repository.md` again. The only repository-wide Cursor rule is
`.cursor/rules/cursor-config-management.mdc`, which documents this checkout's
configuration topology.

## Skill Library Model

The skill library is self-contained:

- Native skills are authored directly in `.agents/skills/`.
- Imported skill-factory skills are copied into `.agents/skills/` and tracked in git.
- Matt Pocock skills are installed into `.agents/skills/` and tracked in git with provenance in `skills-lock.json`.
- Product-management skills are tracked in `.agents/skills/` with provenance in `skills-lock.json`.
- Skill-factory provenance is tracked in `.agents/upstreams/skill-factory/components.lock.json`.
- ECC upstream components are tracked in `.agents/upstreams/ecc/components.lock.json`.

Shared skill governance lives in:

- `.agents/docs/skill-factory-skills.md`
- `.agents/skills/skill-foundry/agents/catalog.yaml`
- `.agents/skills/skill-foundry/agents/catalog-engineering.yaml`
- `.agents/skills/skill-foundry/agents/catalog-product-management.yaml`

Use the skill catalog supplied by the active client for ordinary task routing.
The full index and catalogs above are maintenance inventories; they are not a
required context preamble before loading one matching skill. When a client has
no catalog, search only the relevant section of
`.agents/docs/skill-domain-routing.md`.

Cursor-only skills are inventoried separately:

- `.agents/docs/cursor-skills.md`
- validated by `./validate-cursor-skills.sh` (frontmatter + index only; no skill-foundry catalogs)

## Setup and Validation

```bash
./setup-symlinks.sh setup
make install-hooks
make check
```

`make check` is the canonical local healthcheck and runs:

- `make test`
- `make lint-shell`
- `make validate-skills`
- `make validate-cursor-skills`
- `make validate-openspec`
- `make validate-symlinks`
- `make check-tracked-ignored`

Recommended direct checks when diagnosing a specific failure:

```bash
make lint-shell
make test
./tests/validate-skill-library-test.sh
./validate-skill-library.sh
./validate-cursor-skills.sh
OPENSPEC_TELEMETRY=0 openspec validate --all
```

`check-tracked-ignored` is report-only. It surfaces tracked files that match `.gitignore` so maintainers can decide whether a path is intentional or should be removed from version control.

The TypeScript CLI under `src/thoughts/` is not part of mandatory `make check` until dependency installation is reproducible for this repository.

The Makefile prepends `~/.agents/bin`, `~/.bun/bin`, `/opt/homebrew/bin`, and `/usr/local/bin` to `PATH` so checks can find managed tools from non-login shells.

### Truthfulness evaluation

`make test` verifies the versioned cases and deterministic grader contract. Run
the live behavioral evaluation separately against a configured client:

```bash
make eval-truthfulness TARGET=codex
make eval-truthfulness TARGET=hermes
# When Hermes is not on PATH:
HERMES_BIN=/path/to/hermes make eval-truthfulness TARGET=hermes
```

It checks that the client reports available model context, leaves an
unidentified person as unknown, and corrects a contradicted claim plainly. It
is deliberately outside `make check`: it invokes a provider, can consume quota,
and an unavailable provider is an evaluation failure, not a passing result.

## Verified Local Toolchain Baseline

The 2026-08-26 maintenance pass verified this direct development toolchain:

| Tool | Verified version |
|------|------------------|
| Codex CLI | 0.149.1 (`gpt-5.6-terra`, medium reasoning) |
| Orca Desktop/CLI | 1.4.188 |
| OpenCode Desktop/CLI | 1.18.23 |
| Hermes Agent | 0.20.5 plus the carried multiplexed-profile patch |
| OmniRoute | 3.8.49 |
| Node.js / npm | 24.16.0 LTS / 12.0.2 |
| Pi / OpenSpec | 0.84.3 / 1.10.0 |
| GitHub CLI / RTK / uv | 2.98.0 / 0.45.0 / 0.12.6 |

Use the fully qualified `stablyai/orca/orca` Homebrew cask for Orca. The
unqualified cask name can resolve to an unrelated deprecated Plotly package.
Hermes source updates must preserve the local multiplexing patch: validate a
parallel worktree, switch the canonical install path only after its focused
tests pass, and retain the previous checkout until the new gateway is healthy.

The pass considered a healthy OmniRoute route to require non-empty content, a
terminal finish reason, and non-zero usage. The `combo/free-coding` smoke
resolved to `mimo-v2.5-free`, returned `READY`, stopped normally, and reported
266 total tokens. Package-manager success alone is not semantic verification.
Unrelated outdated Homebrew libraries are intentionally outside this baseline.

## Pre-Commit Hook

The tracked pre-commit template lives at `hooks/pre-commit` and delegates to `make check`.

Install it with:

```bash
make install-hooks
```

The install target uses `git rev-parse --git-path hooks/pre-commit`, so it works from linked worktrees as well as the main checkout.

## Syncing Imported Skills

Use the local `skill-factory` checkout to refresh imported skills:

```bash
SKILL_FACTORY=/path/to/skill-factory ./pull-and-sync-skills.sh
```

What this does:

- pulls the upstream repository
- copies upstream skill directories into `.agents/skills/`
- preserves native repo-owned skills and other external skill packs
- refreshes `.agents/upstreams/skill-factory/components.lock.json`

Preview only:

```bash
SKILL_FACTORY=/path/to/skill-factory ./sync-skill-factory.sh --dry-run
```

## Tool Wiring

`setup-symlinks.sh` manages these local links:

- `~/.cursor/commands` -> repo `.cursor/commands` -> repo `.agents/commands`
- `~/.cursor/skills` -> repo `.agents/skills`
- `~/.cursor/skills-cursor` -> repo `.cursor/skills-cursor`
- `~/.cursor/.agents` -> repo `.agents`
- `~/.cursor/mcp.json` -> repo `.agents/mcp.json`
- `~/.cursor/cli-config.json` -> repo `.cursor/cli-config.json`
- `~/.codex/skills/skills` -> repo `.agents/skills`
- `~/.codex/rules/default.rules` -> repo `.agents/rules/codex-default.rules`
- `~/.codex/AGENTS.md` -> repo `.agents/rules/base.md`
- `~/.codex/hooks/rtk-rewrite.sh` -> repo `.agents/hooks/rtk-rewrite.sh`
- `~/.codex/config.toml` and `~/.codex/hooks.json` are seeded from `templates/codex/`
- `~/.claude/commands` -> repo `.agents/commands`
- `~/.claude/skills` -> repo `.agents/skills`
- `~/.claude/hooks` -> repo `.claude/hooks`
- `~/.claude/hooks/rtk-rewrite.sh` -> repo `.claude/hooks/rtk-rewrite.sh` -> repo `.agents/hooks/rtk-rewrite.sh`
- `~/.gemini/antigravity/mcp_config.json` -> repo `.agents/mcp.json`
- `~/.gemini/GEMINI.md` -> repo `.agents/rules/base.md`
- `~/.agents` -> repo `.agents`
- `~/.agents/bin/rtk` -> `/opt/homebrew/bin/rtk` when Homebrew RTK is present
- `~/.agents/bin/openspec` -> `/opt/homebrew/bin/openspec` or `~/.bun/bin/openspec` when OpenSpec is present
- `~/.agents/bin/codex-free` -> repo `bin/codex-free`
- `~/.local/bin/codex-free` -> repo `bin/codex-free` for interactive shells

Mutable local config such as `~/.codex/config.toml`, `~/.codex/hooks.json`, and `~/.claude/settings.json` is seeded from `templates/` and intentionally not symlinked back into the repo. For Codex, the required portable invariants are Terra, Medium reasoning, pragmatic personality, and `multi_agent = true`; `setup-symlinks.sh validate` checks them without replacing local MCP, plugin, marketplace, desktop, or hook state. `.agents/mcp.json` is shared with Cursor and Gemini, not installed into Codex.

OmniRoute combo state is also mutable local state. Its portable desired state
is tracked in `templates/omniroute/free-coding-combo.json`; apply it explicitly
with `make configure-omniroute-free-coding`. The configurator is idempotent and
stops on drift instead of replacing a locally edited combo.
The former `free-stack` and `free-deterministic` runtime combos were retired on
2026-08-21 and are intentionally absent from portable configuration.
Hermes and OpenCode expose only the `free-coding` combo identifier; Codex and
Orca terminals use `codex-free`. The ordered model policy is not copied into
client configuration.

## Thoughts and Workflow Assets

- `thoughts/shared/research/` stores shared research artifacts.
- `thoughts/shared/plans/` stores implementation plans.
- `src/thoughts/` contains the CLI used to manage the `thoughts/` tree.

## Repository Notes

- The root shims `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` point to `.agents/rules/repository.md`; home-level instruction files point to `.agents/rules/base.md`.
- The validator only passes when filesystem inventory, catalogs, the skills index, and domain routing entries are in sync.
- Adding, removing, renaming, or moving a skill requires the same-change updates to `.agents/docs/skill-factory-skills.md`, the relevant skill-foundry governance catalog, and a bullet in `.agents/docs/skill-domain-routing.md`. Update `README.md`, `PROJECT_STATUS.md`, and provenance lock files when user-facing inventory, status, or source ownership changes.
- `./pull-and-sync-skills.sh` runs `./validate-skill-library.sh` after every sync so missing index, catalog, or routing updates fail immediately.
- If a skill moves from skill-factory to another source, remove it from `.agents/upstreams/skill-factory/components.lock.json`; otherwise the skill-factory sync will refresh and overwrite it.
