<h1 align="center">Arnesto</h1>

<p align="center">
  The agent harness that got out of hand: a portable, multi-tool operating layer for AI-assisted work.
</p>

<p align="center">
  <a href="https://github.com/saski/arnesto/blob/main/LICENSE">
    <img alt="License: Unlicense" src="https://img.shields.io/badge/license-Unlicense-lightgrey">
  </a>
  <img alt="Status: ready" src="https://img.shields.io/badge/status-ready-brightgreen">
  <img alt="AI tools" src="https://img.shields.io/badge/tools-Cursor%20%7C%20Codex%20%7C%20Claude%20%7C%20Gemini-blue">
  <img alt="Workflow: XP TDD FIC" src="https://img.shields.io/badge/workflow-XP%20%2B%20TDD%20%2B%20FIC-purple">
</p>

---

## Why this exists

AI coding tools are useful, but each one tends to grow its own private pile of rules, commands, memories, hooks, and local configuration. That becomes hard to audit and even harder to move between tools.

Arnesto keeps the reusable parts in one place: rules, skills, planning,
OpenSpec changes, tool adapters, and the wiring that connects them across
Codex, Cursor, Claude, Gemini, Hermes, OpenCode, and OmniRoute.

The goal is not to create a giant prompt library. The goal is to keep a small, explicit, versioned configuration system that helps agents:

- think before acting;
- make the smallest safe change;
- use the right skill or workflow for the task;
- save durable research and plans outside transient chat context;
- verify work before claiming it is done.

Arnesto grew from
[Eduardo Ferro's augmented-code configuration](https://github.com/eferro/augmentedcode-configuration).
Its complete Git history is preserved here, while the original fork remains as
a public provenance record.

## What you get

| Capability | What it gives you |
|------------|-------------------|
| Shared rules | A compact baseline rulebook plus contextual rules for specific kinds of work. |
| Shared skills | Portable task guidance for XP/TDD, FIC, OpenSpec, documentation lookup, PR review, vault/wiki work, bounded free-worker execution with a declarative routing policy, AI adoption, and more. |
| Shared commands | Slash-command style prompts where the target tool supports them. |
| Shared MCP config | One canonical MCP configuration consumed by local tools. |
| Tool adapters | Cursor, Codex, Claude, Gemini, Antigravity, and Langflow wiring through symlinks or local template-backed files. |
| Durable context | `thoughts/` stores research, plans, and PR notes so long-running work does not depend on one overloaded chat. |
| Local validation | `make check` keeps symlinks, shell scripts, skills, OpenSpec artifacts, and tracked ignored files honest. |

## 30-second architecture

```mermaid
flowchart LR
    repo["Arnesto"]
    agents[".agents<br/>rules / skills / commands<br/>workflows / MCP / hooks"]
    thoughts["thoughts/<br/>research / plans / PR notes"]
    templates["templates/<br/>safe local defaults"]
    tools["Cursor / Codex / Claude<br/>Gemini / Antigravity / Langflow"]
    local["local mutable config<br/>(not canonical)"]

    repo --> agents
    repo --> thoughts
    repo --> templates
    agents --> tools
    templates -. copied .-> local
```

The important boundary: `.agents/` is canonical. Local runtime state, editor state, sessions, machine-specific paths, and mutable credentials stay outside the shared repo.

## Agent routing architecture

The entry surface does not own the work. Codex is the frontier control plane; OmniRoute is restricted to explicitly authorized, bounded free-worker execution.

```mermaid
flowchart LR
    user["User"]

    subgraph entry["Entry surfaces"]
        telegram["Telegram"] --> hermes["Hermes"]
        opencode_entry["OpenCode"]
        codex_entry["Codex App / CLI"]
        cursor["Cursor"]
    end

    contract{"Explicit mode"}
    hermes --> contract
    opencode_entry --> contract
    codex_entry --> contract
    cursor --> contract

    contract -->|"frontier"| codex["Codex principal\nGPT-5.6 Sol"]
    contract -->|"free, bounded, non-sensitive"| adapter["Free-worker adapter"]

    codex --> openspec["OpenSpec\nplan · tasks · acceptance"]
    codex --> review["Frontier review\nand integration"]
    codex -->|"eligible subtask"| adapter

    adapter --> worker["OpenCode one-shot worker"]
    worker --> omniroute["OmniRoute\nverified free-model policy"]
    omniroute --> models["Free models"]
    models --> result["Result\ndiff · validation · usage"]
    result --> review

    codex_auth["ChatGPT OAuth\nCodex store"] -.-> codex
    free_auth["Free-provider credentials"] -.-> omniroute
```

### Frontier-to-free task lifecycle

```mermaid
sequenceDiagram
    participant U as User / entry surface
    participant C as Codex frontier principal
    participant S as OpenSpec
    participant A as Free-worker adapter
    participant O as OpenCode worker
    participant R as OmniRoute free route

    U->>C: Start or continue frontier task
    C->>S: Define requirement, scope, and validation
    C->>C: Classify sensitivity and ambiguity
    alt Eligible bounded task
        C->>A: Worker contract (role=worker, depth=1)
        A->>A: Validate routing policy and file scope
        A->>O: One-shot execution
        O->>R: Explicit verified free model
        R-->>O: Completion
        O-->>A: Final text, diff, usage
        A-->>C: Stable result and validation evidence
        C->>C: Review and integrate or reject
    else Sensitive, ambiguous, or unsafe task
        C->>C: Keep work on the frontier lane
    end
```

The detailed policy, contracts, and risks live in [the active OpenSpec design](docs/openspec/changes/codex-led-agent-routing/design.md).
The verified local Telegram/Hermes/OmniRoute procedure and recovery steps live
in [Hermes, OmniRoute, and Telegram Operations](docs/hermes-omniroute-operations.md).

### Requesting a bounded free worker

Codex remains the frontier owner for scope preparation and final diff review. There is no paid fallback; free workers handle only explicitly authorized, bounded, non-sensitive tasks.

```
Use a free worker for this bounded, non-sensitive task: lint and fix only README.md, then run ["git","diff","--check","--","README.md"].
```

Codex must translate that request into the versioned contract and invoke
`.agents/skills/free-agent-execution/scripts/run-free-worker`. That adapter is
the single supported Codex-to-OpenCode dispatcher; a direct `opencode run` is
neither a native Codex subagent nor an equivalent safe handoff. Set
`require_changes: true` for edit tasks so a worker that only explains or
exhausts its steps cannot be accepted as an implementation.

The `bounded_code` policy currently allows three steps, 50,000 cumulative input
tokens, and 180 seconds. The verified pool contains
`omniroute/oc/deepseek-v4-flash-free` and `omniroute/oc/big-pickle`.
`free-deterministic` is active in the 2026-08-06 OmniRoute catalog, but its
semantic probe failed with `payment_required` at `longcat/LongCat-2.0`, so it
remains a candidate rather than a production route. The frontier agent reviews
every structured result before integration. See the
[free-agent-execution skill](.agents/skills/free-agent-execution/SKILL.md) for
the full contract and failure semantics.

For an explicit OpenCode entry contract, see [OpenCode Free-Agent Entry](docs/opencode-free-entry.md).

## Quick start

Clone the repository wherever you keep source checkouts:

```bash
git clone git@github.com-saski:saski/arnesto.git ~/Code/arnesto
cd ~/Code/arnesto
```

Set up local tool links and checks:

```bash
./setup-symlinks.sh setup
make install-hooks
make check
```

The script discovers the checkout from its own location. Automation may still
provide an explicit root when needed:

```bash
REPO_DIR=/path/to/arnesto ./setup-symlinks.sh setup
```

## Daily use

### Check the system

```bash
make check
```

That is the main local healthcheck. It runs tests, shell linting, skill validation, OpenSpec validation, symlink validation, and tracked-ignored reporting.

For narrower checks:

| Need | Command |
|------|---------|
| Full local validation | `make check` |
| Symlink health | `./setup-symlinks.sh validate` |
| Shared skill catalog/index validation | `make validate-skills` |
| Cursor-only skills validation | `make validate-cursor-skills` |
| Shell syntax checks | `make lint-shell` |
| OpenSpec validation | `make validate-openspec` |
| Local config status | `./setup-symlinks.sh status` |
| Local GitHub repo sync report | `make sync-saski-repos` |

### Change shared configuration

```bash
./setup-symlinks.sh status
make check
./setup-symlinks.sh commit
```

### Refresh imported skills

```bash
./pull-and-sync-skills.sh --dry-run
./pull-and-sync-skills.sh
make validate-skills
```

Imported `skill-factory` components are refreshed only from `.agents/upstreams/skill-factory/components.lock.json`. Native skills and other external skill packs are not overwritten by that sync.

### Sync local GitHub repos

```bash
make sync-saski-repos
make sync-saski-repos-apply
./sync-saski-repos.sh --discover
```

The sync script uses [saski-github-repos.tsv](saski-github-repos.tsv) as an explicit manifest for GitHub repos under `~/Code`. It fetches source refs and fast-forwards only clean matching branches; dirty, detached, wrong-branch, and diverged worktrees are reported and left untouched. Forks can be pushed back to their fork remotes only when `--push` is passed explicitly.

## Repository map

```text
.
├── .agents/                  # Canonical shared agent assets
│   ├── rules/                # Global, repository, and contextual rules
│   ├── skills/               # Native, imported, and sibling-repo skills
│   ├── commands/             # Shared slash-command prompts
│   ├── workflows/            # Structured delivery workflows
│   ├── hooks/                # Shared hook scripts, including RTK
│   ├── upstreams/            # Provenance for imported components
│   └── mcp.json              # Shared MCP server configuration
├── .cursor/                  # Cursor adapters; skills-cursor/ for IDE-only skills
├── .claude/                  # Claude shims to canonical shared assets
├── .gemini/                  # Gemini shims to canonical shared assets
├── docs/                     # Maintainer docs and OpenSpec artifacts
├── hooks/                    # Git hook templates
├── templates/                # Copied defaults for mutable local config
├── thoughts/                 # Shared research and implementation plans
├── src/thoughts/             # Optional thoughts CLI source
├── Makefile                  # Canonical validation targets
├── saski-github-repos.tsv    # Manifest for local GitHub repo sync
├── sync-saski-repos.sh       # Safe fast-forward sync for ~/Code repos
└── setup-symlinks.sh         # Setup, validation, and status for local links
```

Maintainer-facing details live in [docs/development-guide.md](docs/development-guide.md).

## Canonical assets

| Asset | Canonical path | Notes |
|-------|----------------|-------|
| Universal rules | `.agents/rules/base.md` | Installed at home level for cross-repository behavior. |
| Repository rules | `.agents/rules/repository.md` | Exposed through this repo's `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` shims. |
| Contextual rules | `.agents/rules/*.md` | Python, Makefile, React, Codex defaults, feedback loop, and other scoped rules. |
| Shared skills | `.agents/skills/` | Native skills, imported packs, and sibling-repo skill references. |
| Cursor-only skills | `.cursor/skills-cursor/` | Canvas, SDK, loops, and meta-skills; see `cursor-skills.md`. |
| Skill routing docs | `.agents/docs/` | `skill-domain-routing.md` and `skill-factory-skills.md` for shared skills; `cursor-skills.md` for Cursor-only. |
| Commands | `.agents/commands/` | FIC commands plus project command prompts such as `review-pr`. |
| Workflows | `.agents/workflows/` | Context-driven development and TDD cycle workflows. |
| MCP config | `.agents/mcp.json` | Shared by configured tools. |
| Local tool shims | `~/.agents/bin` | Ignored by git and recreated by `./setup-symlinks.sh setup`. |

## Tool wiring

`setup-symlinks.sh` connects local tool directories to the canonical assets:

| Tool | Managed links |
|------|---------------|
| Cursor | Rules, commands, skills, `.agents`, MCP config, CLI config, and Cursor-only skills. |
| Codex | Shared skills, Codex default rules, home-level `base.md`, copied `config.toml` and `hooks.json` defaults, plus `~/.codex/hooks/rtk-rewrite.sh` for Bash command rewriting through RTK. |
| Claude | Commands, skills, hooks, and copied `settings.json` defaults. `~/CLAUDE.md` points to global `base.md`; the repo shim points to `repository.md`. |
| Gemini | Shared skills, home-level `base.md`, the repo-local `repository.md` shim, plus Antigravity MCP, command, and workflow links. |
| Antigravity and Langflow | Shared skills. |
| Global shell | `~/.agents`, `~/.agents/bin/rtk`, and `~/.agents/bin/openspec`. |

Mutable runtime state, such as Claude sessions, Cursor-managed manifests, Codex local config, and editor workspace state, intentionally stays out of the canonical repo.

## FIC workflow

FIC keeps long AI work understandable by moving through explicit phases and saving durable artifacts between context windows.

```mermaid
flowchart LR
    research["Research<br/>facts and current behavior"]
    save1["Save<br/>thoughts/shared/research"]
    plan["Plan<br/>phased implementation"]
    save2["Save<br/>thoughts/shared/plans"]
    implement["Implement<br/>phase by phase"]
    validate["Validate<br/>evidence and gaps"]

    research --> save1 --> plan --> save2 --> implement --> validate
```

| Command or skill | Purpose |
|------------------|---------|
| `fic-research` | Capture current implementation facts without proposing changes. |
| `fic-create-plan` | Turn research or task context into a phased plan. |
| `fic-implement-plan` | Execute an approved plan with verification. |
| `fic-validate-plan` | Compare implementation evidence against the plan. |

Cursor and Claude can use command prompts from `.agents/commands/`. Codex, Gemini, and other tools should use the matching skills from `.agents/skills/`.

## Skills and commands

The README intentionally does not duplicate the full catalog. Use the canonical indexes instead:

| Need | File |
|------|------|
| Domain-first routing | [.agents/docs/skill-domain-routing.md](.agents/docs/skill-domain-routing.md) |
| Full skill inventory | [.agents/docs/skill-factory-skills.md](.agents/docs/skill-factory-skills.md) |
| Engineering governance catalog | [.agents/skills/skill-foundry/agents/catalog-engineering.yaml](.agents/skills/skill-foundry/agents/catalog-engineering.yaml) |
| Product-management catalog | [.agents/skills/skill-foundry/agents/catalog-product-management.yaml](.agents/skills/skill-foundry/agents/catalog-product-management.yaml) |

Use `agent-config-hygiene` for an explicit audit of instruction loading,
duplicate wrappers, skill routing, and mutable runtime boundaries. It is a
review skill, not an always-loaded rule.

Common command entry points:

| Command | Purpose |
|---------|---------|
| `/fic-research` | Research and document current codebase behavior. |
| `/fic-create-plan` | Create an implementation plan. |
| `/fic-implement-plan` | Execute a plan phase by phase. |
| `/fic-validate-plan` | Verify implementation completeness. |
| `/lustra` | Run structured code-health and due-diligence checks across security, dependencies, tests, design, docs, CI, and structure. |
| `/review-pr` | Guide an interactive PR review. |
| `/bug-fixing-agent` | Investigate and plan security-aware bug fixes. |
| `/install-command` | Install and customize command templates. |

## Thoughts

`thoughts/` stores durable research and plans:

```text
thoughts/
├── shared/
│   ├── research/
│   ├── plans/
│   └── prs/
└── searchable/               # Gitignored hardlinks created by the CLI
```

The optional CLI lives in `src/thoughts/`:

```bash
cd src/thoughts
npm install
npm run build
npx thoughts init
npx thoughts sync
```

## OpenSpec in a consuming repo

Install the shared OpenSpec skill from the canonical global skill path:

```bash
~/.agents/skills/openspec/scripts/install-openspec
```

The installer prefers `docs/openspec/`, then `thoughts/openspec/`, then root `openspec/`. This repository uses `docs/openspec/` with a root `openspec` symlink for CLI compatibility.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Symlinks are broken | Run `./setup-symlinks.sh setup`, then `./setup-symlinks.sh validate`. |
| `rtk` or `openspec` is missing in checks | Run `./setup-symlinks.sh setup` to recreate managed shims under `~/.agents/bin`. |
| Config is not loading in a tool | Run `./setup-symlinks.sh validate` and inspect the tool-specific link from the table above. |
| Skill validation fails after adding or moving a skill | Update the skill index, the relevant governance catalog, and routing docs in the same change. |
| A local template-backed config drifted | Re-copy the relevant file from `templates/`; mutable configs are not symlinked back into the repo. |

## Design principles

These configurations optimize for:

1. **Think before acting** - inspect the task, constraints, and relevant context before changing files.
2. **Simplest surgical change** - prefer small, reversible, auditable edits.
3. **Goal-driven verification** - prove the requested outcome, not just that a command happened to pass.
4. **Checkpoint and escalate** - disclose uncertainty, risks, and incomplete evidence.
5. **Durable context over chat memory** - keep research, plans, and decisions in files that can be reviewed.

## References

- [Development guide](docs/development-guide.md)
- [Skill domain routing](.agents/docs/skill-domain-routing.md)
- [Skill inventory](.agents/docs/skill-factory-skills.md)
- [Context Engineering Article](https://nikeyes.github.io/tu-claude-md-no-funciona-sin-context-engineering-es/)
- [stepwise-dev Plugin](https://github.com/nikeyes/stepwise-dev)
- [Ashley Ha Workflow](https://medium.com/@ashleyha/i-mastered-the-claude-code-workflow-145d25e502cf)

## License

[Unlicense](https://unlicense.org) - Public Domain.
