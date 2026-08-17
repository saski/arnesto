# Arnesto - Project Status

**Last Updated**: 2026-08-17
**Overall Status**: 🟢 **Ready** - Arnesto is an independent multi-tool agent harness with portable setup, progressive instruction loading, deterministic hygiene contracts, and isolated client runtime state.

---

## Executive Summary

| Component | Status | Notes |
|---|---|---|
| Universal rulebook (`base.md`) | ✅ Single global source | Home-level cross-repository baseline via `~/AGENTS.md`, `~/CLAUDE.md`, `~/GEMINI.md`, and `~/.codex/AGENTS.md` |
| Repository rulebook (`repository.md`) | ✅ Scoped bootstrap | Root `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` expose project purpose, validation, and skill governance |
| Cursor `.cursor/rules/` | ✅ Reduced 13 → 1 | Workspace-only topology guidance in `cursor-config-management`; global and repository rules arrive through `AGENTS.md` |
| Workflows as skills | ✅ Migrated | `tdd`, `refactoring`, `diagnose`, `fic-*`, `project-status-maintenance`, `agent-config-hygiene` |
| Conditional rules | ✅ Single source | `.agents/rules/{python,makefile,react}-project.md`, loaded on demand per `base.md §2` |
| RTK guidance and hooks | ✅ Compact pointer in `base.md §5`; shared hook wired | Recursive `@-include` removed; Codex and Claude Bash hooks use `.agents/hooks/rtk-rewrite.sh` |
| Skill governance | ✅ Aligned | Index, catalog, and provenance lock validated |
| Local healthchecks | ✅ Passing | `make check` covers tests, shell lint, skill validation, Cursor inventory, OpenSpec validation, symlink validation, and tracked-ignored reporting |
| Marmalade team rules | ⚠️ Pending | Still loading via Eventbrite team config; awaiting admin removal |
| Hermes Telegram and OmniRoute operations | ✅ Locally verified | Frontier reset, explicit free model switch, secret-scope patch, dashboard, and recovery runbook documented; mutable local configuration remains out of repo |

**Current Readiness**: Arnesto is stable for daily use across Cursor, Codex, Claude Code, Gemini, Antigravity, Hermes, OpenCode, OmniRoute, and Langflow. The public canonical repository is `saski/arnesto`; the checkout intentionally remains at its legacy local path until a separate physical-path decision.

### 2026-07-30: Hermes Telegram and OmniRoute operational slice ✅

- Verified Telegram ingress routes the configured chat to the `coding` Hermes profile; `/new` starts `gpt-5.6-sol` through `openai-codex`.
- Verified the explicit, session-only free lane: `/model oc/deepseek-v4-flash-free --provider custom` followed by a non-sensitive `RUTA_FREE_OK` smoke completion.
- Replaced stale broad free-route use with the direct verified model in local runtime configuration. `auto/*` and `free-stack` remain unsuitable defaults; `free-deterministic` is active but semantically unhealthy as of 2026-08-06.
- Fixed the multiplex secret-scope defect in the local Hermes `/model` text handler. The patch preserves per-profile isolation; it must be retained or upstreamed before a future Hermes update.
- Eliminated duplicate Telegram adapter startup by keeping Telegram ingress on the default profile and disabling Telegram on the routed `coding` profile.
- Added [Hermes, OmniRoute, and Telegram Operations](docs/hermes-omniroute-operations.md), including Mermaid diagrams, command sequencing, recovery, and local-state boundaries.

**Validation**: Gateway supervised by launchd; Telegram connected; dashboard returned HTTP 200 on `127.0.0.1:9119`; direct OmniRoute completion and routed Telegram free completion both returned non-empty expected text. Hermes source regression test was added but could not run because the release virtualenv lacks `pytest`.

---

## Recent Changes

### 2026-08-17: Arnesto standalone transition ✅

- Graduated the harness to the independent public `saski/arnesto` repository
  while preserving complete Git history and Eduardo Ferro provenance.
- Kept the original fork as the `legacy` remote for rollback and preserved its
  stars, child fork, and historical identity.
- Made `setup-symlinks.sh` derive its checkout from the script location and
  added a behavior-level portability contract for arbitrary directory names.
- Kept the current physical checkout path and live symlinks unchanged so the
  public identity migration does not force a client reconfiguration.

**Validation**: Arnesto reports `fork: false`; local, `origin/main`, and
`legacy/main` matched at the cutover revision; GitHub Actions and canonical
`make check` passed.

### 2026-08-14: Agent configuration hygiene and runtime boundary ✅

- Removed the two always-applied Cursor wrappers that reloaded canonical rules
  or promoted the feedback loop from conditional to permanent.
- Narrowed contextual rules to tasks that touch their language or build
  surface, and changed skill routing to prefer the active client's catalog.
- Added `agent-config-hygiene` as an explicit review skill; deterministic
  loading, routing, and Codex/Orca invariants remain in the existing
  healthcheck test instead of another permanent rule.
- Kept Codex and Orca runtime state separate, documented their safe
  synchronization boundary, and made `templates/codex/config.toml` the single
  versioned source for shared model defaults.

**Validation**: `bash tests/healthcheck-automation-test.sh`, skill-library
validation, and canonical `make check` pass.

### 2026-08-12: Global and repository rule scope split ✅

- Reduced the always-loaded `base.md` from 166 lines and 1,651 words to 85
  lines and 642 words while preserving the four operating principles and
  explicit safety routes.
- Added `repository.md` for this checkout's project description, canonical
  `make check` / `make ci-check` commands, and skill-library governance.
- Rewired home-level instruction files to global `base.md` and the root
  `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` shims to `repository.md`.
- Removed nonexistent generic Make targets from the contextual Makefile rule.
- Consolidated Context7 routing in `documentation-lookup`: MCP tools are
  preferred and the CLI is the fallback.
- Added regression contracts for instruction budget, routing, documented Make
  targets, and global/repository symlink scope.

**Validation**: Canonical `make check` passes, including rule, routing,
skill-library, Cursor inventory, shell-syntax, OpenSpec, and live symlink
checks.

### 2026-08-12: Cursor-managed skill refresh consolidated ✅

- Replaced the retired `migrate-to-builds` skill with the slash-only
  `rename-chat` command and aligned the governed Cursor-only skill index.
- Refreshed the Canvas SDK declarations and Cursor CLI configuration guidance
  from the same managed update snapshot.
- Kept these Cursor-only assets out of the shared skill-factory catalogs, as
  required by the repository's separate Cursor inventory contract.

**Validation**: `make validate-cursor-skills` and canonical `make check` pass.

### 2026-08-06: Shared OpenSpec runtime resolution and local UI cleanup ✅

- Persisted NVM-aware OpenSpec CLI resolution in the shared `openspec` skill
  consumed by Codex, Cursor, Claude, Gemini, and the other managed clients.
  Agents now load `~/.nvm/nvm.sh` and retry before diagnosing OpenSpec as
  missing; the NVM default is used without hard-coding a Node version.
- Added regression coverage to `tests/openspec-install-test.sh` so the shared
  resolution procedure cannot disappear silently.
- Stopped tracking repository-local `.obsidian/` UI and plugin state and
  ignored the complete directory. No Obsidian runtime state remains versioned;
  the local core settings that still exist are preserved outside Git.

**Validation**: Canonical `make check` passes, including the OpenSpec
installer/runtime regression, OpenSpec validation, skill inventories, managed
symlinks, and tracked-ignore reporting.

### 2026-08-06: Deterministic free-worker dispatch hardening ✅

- Confirmed failed direct OpenCode attempts bypassed the constrained worker:
  one request carried 133 messages, 318 KB, and 11 tools, then repeated
  80k-150k-token calls despite healthy HTTP 200 provider responses.
- Kept `run-free-worker` as the single dispatcher and moved the `bounded_code`
  ceilings into the routing manifest: 3 steps, 50,000 cumulative input tokens,
  and 180 seconds.
- Added live context-budget termination, stable `termination_reason` values,
  timeout-policy rejection, and `require_changes` no-op rejection.
- Verified three live dispatcher smokes: DeepSeek no-edit (1,659 input tokens),
  DeepSeek one-file edit (2,002), and Big Pickle no-edit (6,128); scope and
  validation passed in all three.
- Confirmed `free-deterministic` is catalog-active, but its minimal semantic
  probe failed with `payment_required` at pipeline step 3
  (`longcat/LongCat-2.0`). It remains a candidate rather than a verified route.

**Validation**: Three live direct-pin smokes and canonical `make check` pass,
including the adapter suite, routing-manifest validation, shell syntax, skill
and Cursor inventories, OpenSpec, managed symlinks, and tracked-ignore checks.

### 2026-08-04: Cursor-skills index repair and `.claude/hooks` restore ✅

- Realigned `.agents/docs/cursor-skills.md` with the on-disk `.cursor/skills-cursor/` tree:
  replaced the deleted `babysit` and `env-setup` rows with `autopilot` (the rename
  of `babysit`) and `migrate-to-builds`, keeping the ide/meta/config category groups
  and alphabetical ordering intact.
- Registered the two untracked Cursor skill directories (`autopilot`, `migrate-to-builds`)
  so `validate-cursor-skills.sh` git-tracking check passes.
- Restored `.claude/hooks/rtk-rewrite.sh` as a symlink to `.agents/hooks/rtk-rewrite.sh`,
  which `setup-symlinks.sh` `validate` and `templates/claude/settings.json` expect but
  commit `dd27979` had removed. The obsolete `.rtk-hook.sha256` checksum was not
  restored because nothing references it anymore.
- `make check` now passes end-to-end for the first time since the 2026-07-30 work:
  all test suites, shell lint, skill-library validation, Cursor-skills validation,
  OpenSpec validation, and symlink validation are green.

**Validation**: `make check` exit 0.

### 2026-07-30: Managed OpenCode free entry ✅

- Added `templates/opencode/free-worker.jsonc`: a non-secret OmniRoute
  provider template exposing only the two verified free models and the
  constrained three-step worker policy.
- Added `docs/opencode-free-entry.md` for explicit `frontier` versus `free`
  entry selection, contract invocation, prohibitions, and recovery behavior.
- Added `tests/opencode-free-template-test.sh` to reject automatic routes,
  paid/frontier models, quarantined families, or relaxed worker permissions.
- Added `./setup-symlinks.sh opencode-free-worker` and
  `validate-opencode-free-worker`. They atomically add only missing managed
  fields, preserve unrelated configuration and credential storage, and reject
  incompatible local values without writing.
- The local OpenCode configuration was installed and validated with its
  existing `localhost` OmniRoute endpoint and provider-specific model metadata
  preserved.
- Added `tests/opencode-managed-config-test.sh` for idempotence, new
  configuration creation, unrelated configuration preservation, and credential
  preservation.

### 2026-07-30: Minimal free-worker context ✅

- Constrained the ephemeral OpenCode worker to a short purpose prompt, `read`
  and `edit` only, and a three-step cap. Shell, web, discovery, delegation,
  skills, interactive tools, and external-directory access remain disabled.
- Three bounded smokes on `omniroute/oc/deepseek-v4-flash-free` used
  20,082–20,509 input tokens versus the 90,297-token baseline (77.3–77.8%
  reduction), while retaining structured results, allowed-file attribution,
  and passing validation.
- Added the active OpenSpec change `minimize-free-worker-context`. A token
  budget remains deferred until repeated measurements establish variance.

**Validation**: `bash tests/free-agent-execution-test.sh`, routing-manifest
validation, and `openspec validate --all` pass.

### 2026-07-30: OpenCode Zen conformance and quarantine ✅

- Queried the live local OmniRoute catalog and reconciled the valid prefix as
  `opencode-zen/*`; the earlier `openai-codex-zen/*` identifiers were not live
  provider-qualified OpenCode models.
- Ran isolated, bounded-edit smoke contracts for all six Zen candidates. Each
  failed with OpenCode status 1, zero token usage, no changed files, and no
  paid fallback. A direct diagnostic call returned an OmniRoute server error.
- Quarantined all six from `.agents/free-agent-routing.json`. The free-worker
  allowlist now contains only the two previously verified `omniroute/oc/*`
  models. The validator and its regression suite now accept the actual
  `omniroute/opencode-zen/*` prefix for any future re-conformance run.
- Completed OpenSpec §5.4 as a negative conformance result and §6.4 as
  visible no-fallback evidence. Hermes' explicit free lane remains verified;
  OpenCode's one-shot free acceptance also passed against the stable
  `omniroute/oc/deepseek-v4-flash-free` route.

**Validation**: `bash tests/free-agent-execution-test.sh` and routing-manifest
validation pass. The 2026-07-28 and 2026-07-29 history below is superseded by
this conformance result where it refers to a widened Zen pool.

### 2026-07-26: Bounded free-worker execution ✅

- Added the `free-agent-execution` shared skill and a local adapter that runs one explicitly requested, bounded, non-sensitive task through OpenCode using verified free OmniRoute models.
- Added a secret-free routing manifest and validator for the frontier owner, task classes, verified free models, and privacy boundary. The adapter now reads this policy instead of carrying a model allowlist in code.
- The adapter constructs an ephemeral OpenCode configuration, restricts edits to approved paths, denies shell, network, and recursive delegation, and returns a JSON result with validation and file-attribution data.
- It accepts both the preferred structured `FREE_AGENT_RESULT` output and an ordinary non-empty final worker message, while retaining exit-status, scope, and validation checks.
- Added a behavior-level shell test suite covering successful structured and generic completions, pre-existing worktree changes, and rejection of legacy model identifiers.

**Validation**: `bash tests/free-agent-execution-test.sh`, Bash syntax validation, and skill-library validation pass.

### 2026-07-28: Free-worker pool maximized (option b) ⚠️ Partial

- Expanded the verified free pool from 2 to 7 models in `.agents/free-agent-routing.json`:
  the original `omniroute/oc/deepseek-v4-flash-free` + `omniroute/oc/big-pickle`,
  plus 5 `omniroute/openai-codex-zen/*-free` (deepseek-v4-flash, ling-3.0-flash, mimo-v2.5,
  nemotron-3-ultra, north-mini-code, laguna-s-2.1).
- Modified `validate-routing-manifest` (line 20) from `^omniroute/oc/` to
  `^omniroute/(oc|openai-codex-zen)/` so the adapter accepts the new free models.
- Hermes `coding` profile `config.yaml` (provider `omniroute-local`):
  model pin `auto/best-coding` -> `omniroute/oc/deepseek-v4-flash-free`,
  `discover_models` true -> false, and the `oc/*-free` + `openai-codex-zen/*-free` entries
  added to the models map. Default frontier unchanged: `gpt-5.6-sol` / `openai-codex`.
  Backup: `config.yaml.bak.20260728_000318`.

**PENDING (not done by agent — blocked by tool parser on localhost:20128):**
- Per-request conformance suite (`tasks.md` 5.4: response + tool-use + structured-result
  + bounded-edit checks via `opencode run` against OmniRoute) was NOT executed for the 5
  new `openai-codex-zen/*-free` models. They are admitted by the manifest/adapter but
  not individually verified. Run the smoke loop in a terminal outside the agent:
  for each model, build a contract per `free-agent-execution/SKILL.md` and call
  `.agents/skills/free-agent-execution/scripts/run-free-worker /tmp/contract.json`.
- Spec note: the original design verified only the 2 `oc/*` models (2026-07-26).
  Widening to `openai-codex-zen/*` is a spec change the original design did not foresee.

**Validation**: `validate-routing-manifest` exits 0; all 7 models pass the adapter
acceptance check. `hermes config check` exits 0.

### 2026-07-29: Documentation aligned with widened free pool ✅

- **`free-agent-execution` SKILL.md** — `## Verified free models` no longer hard-codes only the two `oc/*` identifiers. The manifest is now the authoritative source; the section documents the two 2026-07-26 verified models, names the five 2026-07-28 `openai-codex-zen/*` additions as **provisionally admitted**, and tells the reader to prefer one of the two `oc/*` models until §5.4 smoke runs have passed for each `openai-codex-zen/*` identifier.
- **`docs/openspec/changes/codex-led-agent-routing/proposal.md`** — Implementation Status and the closing admission paragraph now describe the seven-identifier allowlist, mark the five `openai-codex-zen/*` entries as provisionally admitted, and explicitly defer full verification to §5.4.
- **`docs/openspec/changes/codex-led-agent-routing/tasks.md` §5.4** — Split into 5.4.1–5.4.6, one sub-task per `omniroute/openai-codex-zen/*-free` identifier, each marked `manifest admitted 2026-07-28; awaiting smoke run`. Anything that passes all four §5.4 checks (response + tool-use + structured-result + bounded-edit) is promoted to fully verified.
- **`README.md`** — Free-worker section now states the seven-identifier pool, the dates of the original verification vs. the config-only widening, and the practical rule (prefer the two `oc/*` models for attested work).
- **`PROJECT_STATUS.md`** — This entry; header `Last Updated` and overall status line now reflect the doc alignment. The 2026-07-28 entry's `PENDING` block is intentionally preserved as the canonical reference for the open §5.4 work.

**Validation**: `bash tests/free-agent-execution-test.sh`, `bash tests/check-omniroute-catalog-test.sh`, and the canonical `make validate-skills` run are scheduled next; if any check fails, this entry is downgraded.

### 2026-06-26: Hardening and validation gap closure ✅

Full review-driven remediation across validators, destructive sync scripts, the RTK hook, CI, and tests. Phased plan: `thoughts/shared/plans/2026-06-26-hardening-and-validation-gaps.md`.

- **Phase 0 (stop the bleeding):** Registered the untracked `onboard` Cursor skill in `.agents/docs/cursor-skills.md`; replaced the untracked root `AGENTS.md` regular file with a tracked symlink to `.agents/rules/base.md` (matching `CLAUDE.md`/`GEMINI.md`); fixed managed-binary resolution in `setup-symlinks.sh` so the `command -v` probe excludes `~/.agents/bin` (eliminated the openspec shim false-warning).
- **Phase 1 (validator blind spots):** `validate-skill-library.sh` and `validate-cursor-skills.sh` now do bidirectional `comm` (catch stale index/catalog entries, not just missing ones) and a git-tracking check (catch skill dirs on disk but not committed — the exact failure that broke `make check`). Awk index parser restricted to `[a-z0-9][a-z0-9-]*` skill names so wiring-table rows are no longer mis-parsed. Duplicated Ruby frontmatter block extracted into `lib/validate-skill-frontmatter.sh`. Consolidated the 4× accumulating EXIT trap to one.
- **Phase 2 (destructive-script hardening):** `sync-saski-repos.sh` now uses `set -euo pipefail`, guards `git rev-parse` (broken HEAD reports `error` + `failed=1` instead of silently mis-reporting `skip`/`current`), and parses manifest rows with `IFS=$'\t' read` instead of `set -- $line` (no word-split/glob). `sync-skill-factory.sh` rejects unknown options (a typo'd `--dry-run` no longer performs destructive `rm -rf`/`cp -R`) and writes the provenance lock atomically (temp + rename). `backup-cursor-config.sh` got `set -euo pipefail`, `#!/usr/bin/env bash`, and quoted `$BACKUP_DIR` in printed cleanup.
- **Phase 3 (hook fail-open):** `.agents/hooks/rtk-rewrite.sh` is now uniformly fail-open: a non-zero `--version` exit, malformed/empty stdin, and empty `rtk rewrite` output all exit 0 (passthrough) instead of aborting or emitting an empty command. Version probe switched to `grep -m1` to avoid `head` SIGPIPE under pipefail.
- **Phase 4 (CI + deps + rtk reconciliation):** Added `.github/workflows/check.yml` running a new `make ci-check` target (CI-portable subset) on push/PR. Added `command -v ruby`/`command -v python3` guards with friendly errors. Reconciled the RTK resolution order across `rtk-rewrite.sh`, `setup-symlinks.sh`, and `base.md §8` (added `/usr/local/bin/rtk`; documented the intentional shim-linking vs. runtime-resolution difference).
- **Phase 5 (test hygiene):** Temp-file leaks fixed via a shared global EXIT-trap cleanup pattern across all fixture-based tests; `sed -i ''` (BSD-only, would break ubuntu CI) replaced with portable `sed -i.bak`.

**Validation**: `make check` and `make ci-check` both pass. New tests: `tests/sync-saski-repos-test.sh`, `tests/sync-skill-factory-test.sh`, plus stale-entry/untracked/git-tracking cases in the validator tests and three fail-open cases in `tests/rtk-global-contract-test.sh`.

### 2026-06-17: Codex and Claude RTK hook wiring repaired ✅

- Removed the stale operational reference to `~/.codex/RTK.md`; RTK guidance remains inline in `base.md §8`.
- Added a Codex `hooks.json` template and taught `setup-symlinks.sh` to manage `~/.codex/hooks/rtk-rewrite.sh`.
- Updated Claude and Codex hook commands to use `$HOME` paths instead of machine-specific legacy paths.
- Extended the RTK contract test so Codex hook wiring and the absence of `RTK.md` references are checked.

### 2026-06-17: GitHub access simplified to the `saski` account ✅

- Simplified GitHub SSH rules so all GitHub access uses `git@github.com-saski:`.
- Removed path-based personal/work account selection from `base.md` and `github-host-alias`.
- Updated the healthcheck contract to reject `git@github.com-eventbrite:` in the universal rulebook.
- Updated local GitHub remotes for this checkout so both `origin` and `upstream` use the `github.com-saski` SSH alias.
- Updated related repository documentation and active routing metadata to use `~/Code` and `github.com-saski`.

### 2026-06-17: Canonical repo root migrated to `~/Code` ✅

- Moved local GitHub repositories from `~/saski` into `~/Code`.
- Kept the active `/Users/saski/Code/augmentedcode-configuration` checkout as canonical because it already owned the live home symlinks and had local worktree changes.
- Renamed the remaining clean duplicate checkout root from `~/saski` to `~/saski.legacy-2026-06-17`.
- Updated `setup-symlinks.sh`, `README.md`, `base.md`, and `saski-github-repos.tsv` so new setup and sync workflows default to `~/Code`.
- Refreshed managed home symlinks with `./setup-symlinks.sh setup`; `~/.agents/bin/openspec` now points at the current Node-managed OpenSpec executable.
- Registered Cursor-only review skills in `.agents/docs/cursor-skills.md` so Cursor skill validation reflects the current tree.

**Validation**: `make check` passes from `/Users/saski/Code/augmentedcode-configuration`.

### 2026-06-08: Canonical home symlink setup repaired 🟡

- Ran `REPO_DIR=/Users/saski/Code/augmentedcode-configuration ./setup-symlinks.sh setup`.
- Verified managed links with `make validate-symlinks`; home-level links now point at `/Users/saski/Code/augmentedcode-configuration`.
- Linked `~/.agents/bin/rtk` to `/opt/homebrew/bin/rtk`; `~/.agents/bin/rtk --version` reports `rtk 0.42.3`.
- Updated `Makefile` so `make validate-symlinks` passes the current checkout path through `REPO_DIR="$(pwd)"` instead of relying on the setup script's previous default `~/saski/augmentedcode-configuration`.

Remaining blockers:

- `make test` and `make validate-skills` fail because seven local sibling skill symlinks are broken: `complexity-review`, `hamburger-method`, `micro-steps-coach`, `story-splitting`, `mutation-testing-js`, `mutation-testing-python`, and `test-desiderata`.
- `make validate-openspec` fails because the `openspec` CLI is not installed in `/opt/homebrew/bin`, `~/.bun/bin`, `/usr/local/bin`, or the active shell `PATH`.
- A root `AGENTS.md` file exists as untracked local drift; the tracked root shims are `CLAUDE.md` and `GEMINI.md`, while home-level `~/AGENTS.md` now points directly to `.agents/rules/base.md`.

### 2026-05-28: Lustra governance and routing registration ✅

- Added `lustra` governance metadata to `.agents/skills/skill-foundry/agents/catalog-engineering.yaml`.
- Added `lustra` to the shared skill inventory index in `.agents/docs/skill-factory-skills.md`.
- Added `lustra` routing guidance in `.agents/docs/skill-domain-routing.md`.
- Added `/lustra` command entry to `README.md` so user-facing command docs match the registered skill set.

### 2026-05-25: Cross-tool rulebook deduplication and reorganization ✅

Three commits delivering single-source-of-truth and on-demand-skills architecture.

- **`c0355b1` Dedupe `base.md` sources**
  - Drop workspace-level `AGENTS.md` symlink (Cursor was loading 4 copies of `base.md`).
  - Re-point `~/AGENTS.md` and `~/.codex/AGENTS.md` directly to `.agents/rules/base.md`.
  - Embed `base.md` into `use-base-rules.mdc` via `@-include` so Cursor loads the rulebook once.
- **`6fc0c80` Reorganize agent rules**
  - `.cursor/rules/`: 13 → 3 files. Universal workflows (TDD, refactoring, debugging, FIC, project-status) moved to skills; conditional rules (Python, Makefile, React) consolidated to single source in `.agents/rules/`; redundant `context7.mdc` absorbed into `base.md §8`; Eventbrite-only `tlz-connection.mdc` migrated to `cursor-prompts` repo.
  - New skill `project-status-maintenance` registered in skill-factory index and catalog.
  - `~/.cursor/rules` symlink removed: Cursor rules now apply only when the saski repo is the active workspace; the universal rulebook reaches every Cursor workspace via `~/AGENTS.md`.
- **`bf6a4d2` Inline RTK into `base.md`**
  - Validation in Cursor and Codex showed the recursive `@RTK.md` include never expanded — RTK guidance was missing from agent context. Inlined as `### RTK` subsection in `base.md §8`.
  - Removed `.agents/rules/RTK.md`, `.claude/RTK.md`, `.claude/CLAUDE.md`, and the corresponding home-level symlinks.
  - Updated tests (`rtk-global-contract-test.sh`, `healthcheck-automation-test.sh`) to match the new contract.

**Validation**: All `make check` targets pass. Cursor + Codex CLI cross-tool functional tests confirm 4/4 rulebook sections accessible; RTK verified after the inline change.

---

### 2026-05-13: Healthcheck and four-principle base rules ✅

Compact `base.md` around four operating principles; added healthcheck contract; added Context7 CLI routing; registered local sibling skill references; managed tool PATH shims via `setup-symlinks.sh`.

### 2026-05-12: Shared RTK hook (`rtk-rewrite.sh`) and OpenSpec docs-first installation ✅

Canonical RTK hook at `.agents/hooks/rtk-rewrite.sh`. OpenSpec artifacts under `docs/openspec/`. `~/.agents/bin/rtk` shim added to setup script.

### 2026-04-13 → 2026-05-07: Skill governance and registration consolidation ✅

OpenSpec shared skill, skill inventory governance rules, MCP/Atlassian endpoint update, Codex RTK symlink, several skill catalog updates.

### Earlier (2026-04-06 → 2026-04-29) ✅

Self-contained skill library, validator and contract tests, repository validation and portability cleanup, `mattpocock/skills` and `Ar9av/obsidian-wiki` registration, repo hygiene pass, `personal-knowledge-routing` skill.

---

## Next Steps

1. **§6.6 OpenCode one-shot free acceptance** — re-run only after a healthy OmniRoute free upstream is available. The six Zen candidates were individually tested and quarantined on 2026-07-30; do not re-admit them without a new catalog check and complete conformance evidence.
2. **Marmalade team rules** — escalate to Eventbrite Engineering Cursor admin to remove the `marmalade-*` rules from team config (they are now available as a workspace skill in `~/eventbrite/listings-webapp/.cursor/skills/marmalade-design-system/`).
3. **`tlz-connection` PR** — push the `add-tlz-connection-rule` branch in `~/eventbrite/cursor-prompts` and open a PR.
4. **Benchmark monitored skills** (`pbt-pragmatic-adoption`, `creating-hooks`, `writing-statuslines`) after the next major model update.
5. **Keep governance aligned**: `components.lock.json`, the discovery index, and the skill-foundry catalogs whenever skills change.
6. **Monitor CI** once `.github/workflows/check.yml` runs on the first push/PR; expand `ci-check` toward the full `make check` if sibling-repo skill sources and the openspec CLI are provisioned on the runner.

---

## Known Issues

- **Marmalade team rules in Cursor**: the `marmalade-*` rules pushed by Eventbrite Engineering team config keep loading even when toggled off in the Cursor UI. Workaround in place (skill mirror in `listings-webapp/.cursor/skills/`); definitive fix requires removing the entries from team config upstream.
- **`@-include` in `.mdc` files is non-recursive**: Cursor expands a top-level `@path` reference but does not re-expand `@path` references inside the included file. Codex CLI shows the same behavior. RTK content was inlined into `base.md` to work around this; future cross-tool inclusions should avoid relying on recursive `@-include`.

---

## Notes

- This repo is the canonical source for AI agent configuration across Cursor, Codex, Claude Code, Gemini, Antigravity, and Langflow.
- Mutable runtime state (sessions, caches, workspace state, mutable credentials) intentionally stays local; only rules, skills, commands, workflows, hooks, and validation are versioned.
- After pulling, contributors must re-run `./setup-symlinks.sh setup` so the home-level symlinks are refreshed to the current targets, including `~/AGENTS.md` -> `base.md`, `~/.codex/AGENTS.md` -> `base.md`, and `~/.codex/hooks/rtk-rewrite.sh` -> `.agents/hooks/rtk-rewrite.sh`.
