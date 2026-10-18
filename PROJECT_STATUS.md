# Arnesto - Project Status

**Last Updated**: 2026-10-18
**Overall Status**: 🟢 **Ready and evolving** - The core harness is operational; new clients and routing ideas remain evidence-gated experiments.

This update reviews repository artifacts and documented evidence. Runtime
observations retain their original dates; it does not certify today's provider
availability or complete unfinished acceptance tasks.

---

## Executive Summary

| Component | Status | Progress | Blocking |
|---|---|---:|---|
| Shared rules, skills, and commands | ✅ Complete | 100% | - |
| Candidate-led coding practice | ✅ Complete | Seven-stage template and explicit RED/GREEN review checkpoints | Independent readiness requires a completed mock |
| Progressive instruction loading | ✅ Complete | 100% | - |
| Setup and canonical validation | ✅ Complete | 100% | - |
| OpenSpec and durable planning | ✅ Complete | 100% | - |
| Hermes, OpenCode, and OmniRoute integration | 🟢 Ready | Operational | Provider health can change |
| AI Studio Android workbench | 🟢 Validated edge | Health tracking build/install loop | Hosted capabilities can change |
| Multi-entry routing contract | 🟡 In Progress | Adapter and partial entry paths implemented | Cursor entry, portable Hermes profile, attribution, and final acceptance remain |
| Behavioural evaluation | 🟡 In Progress | Truthfulness cases and one recorded Promptfoo case | Broader model/client and outcome comparisons remain |
| Artifact classification | ✅ Complete | README inventory reviewed on 2026-10-16 | Proposed capability gaps remain separate from implemented mechanisms |
| Orca evaluation | 🟡 In Progress | Level-1 trial | Needs evidence from real tasks |
| Grok Agent evaluation | ⚠️ Pending | 0% | Starts after the Orca trial |

**Current Readiness**: Arnesto is ready for daily use in its current personal environment. It is published as a reference implementation, not as a universal drop-in distribution.

---

## ✅ Completed Components

### Portable operating core

- One compact universal rulebook with narrower repository and contextual rules.
- Shared skills and commands routed on demand instead of loaded globally.
- Shared `madrid-avisos` workflow covers drafting, authorized browser submission,
  status checks, and native browser-session reuse with manual sign-in. The public
  form was inspected without sending a report; authenticated persistence,
  end-to-end verification, and model comparison remain pending. Hermes/OpenCode
  still need a verified persistent browser integration for municipal access.
- Shared `codex-model-routing` policy for explicit Codex model, effort, Fast,
  and spending decisions, with local evidence and an initial evaluation plan;
  empirical outcome benchmarking remains pending.
- Conditional Codex/Astra instructions cover follow-through, skill conflicts,
  communication, delegation, and verification while retaining Terra Medium.
- Versioned templates and adapters for supported clients.
- Stable `~/.agents` entry point with deterministic symlink validation.
- Separate runtime ownership for credentials, sessions, databases, trust state, and mutable preferences.

### Reusable coding interview practice

- The shared [starting prompt](.agents/skills/ai-coding-interview/references/candidate-led-pairing-prompt.md)
  preserves candidate ownership through understanding, contract, approved plan,
  one RED test and review, minimum GREEN implementation and review, next slice,
  and evidence-based close.
- Each RED/GREEN review shows actual project code diffs, executed commands and
  results. Revisions require rerunning relevant checks. Timers start only on
  explicit instruction; mock assistance remains limited to designated AI tasks.
- Shared skill assets use employer-neutral examples. Interview-specific rubrics,
  constraints and recruiter evidence belong to each preparation project.
- Cursor's skill inventory no longer advertises the removed deployment skill.
  Local Cursor validation and the complete `make check` passed on 2026-10-18.
  These checks validate repository contracts, not candidate readiness.

### Durable delivery workflow

- OpenSpec for requirements, architecture decisions, tasks, and acceptance evidence.
- File-backed research and implementation plans for work that outlives one context window.
- Behaviour-level contracts for setup, skill governance, routing, and failure semantics.
- Canonical `make check` locally and `make ci-check` in GitHub Actions.
- Pinned local Promptfoo evaluator with one behavioral case for honest
  reporting of unexecuted validation. Passed with Codex / `gpt-5.6-terra`
  on 2026-09-16; this is a single-case result, not broad behavioral coverage.
- Native `promptfoo-evals` skill routes LLM behavioral evaluations and defines
  grader controls, comparison boundaries, and honest provider-error reporting.
- External `typesafe-ai` skill is installed in the shared library with its
  upstream license, pinned source commit, content hash, and routing entries.
- Scoped `ponytail` skill adapts the upstream reuse ladder with its MIT notice,
  pinned provenance, and evaluation cases; model-comparison evidence is pending.

### Agent execution and remote entry

- Codex remains the frontier planning, integration, and review surface.
- Bounded, non-sensitive work can use the governed OpenCode free-worker adapter.
- Hermes provides a persistent Telegram entry surface with explicit provider boundaries.
- OmniRoute routes only explicitly admitted free-worker models; semantic failure is not accepted as success.
- Coordination artifact guidance and a normalized provisional launcher snapshot
  are documented in [the reference guide](docs/free-worker-coordination/README.md)
  (2026-10-05). Active model admission and the supported launcher are unchanged.

### Specialised build workbenches

- AI Studio is validated through the Health tracking project as a
  GitHub-synchronised Android generation, build, and phone-installation
  workbench.
- Codex and OpenSpec retain requirements, implementation, tests, privacy
  decisions, and review in the canonical repositories; AI Studio does not
  become another source of truth or orchestration owner.

### Repository identity

- Arnesto is an independent public repository with complete Git provenance.
- The former `augmentedcode-configuration` fork is archived with a migration pointer.
- Setup no longer depends on the physical checkout name.

### Free-model routing hygiene

- `codex-free` provides an isolated free-model entry without changing the
  normal Codex and Orca model choices. Terra/Medium remains the repository
  template default; setup preserves local model/effort selections.
- The ordered `free-coding` desired state is versioned separately from mutable
  OmniRoute runtime state, with fixed diagnostic pins and drift-safe setup.
- Historical `free-coding` installation and semantic probes are recorded in the
  runtime guides. They do not verify current provider health or v2 behaviour.
- Hermes and OpenCode templates now expose `combo/free-coding-v2`, whose
  membership and selection policy remain local OmniRoute state. Codex/Orca
  terminals retain `codex-free` and the tracked `free-coding` desired state.
- The bounded worker adapter retains the separate direct-model allowlist in
  `.agents/free-agent-routing.json`; entry combo aliases do not expand admission.
- The inactive `free-stack` and `free-deterministic` runtime combos were
  removed after a recoverable local backup.
- A portable company-environment bug-fixing skill is tracked for future use
  without embedding company-specific identifiers or credentials.

---

## 🚧 In Progress

### Evaluate optional token-efficiency tools

Shared `codegraph` and `headroom` skills provide version-pinned, on-demand
runbooks. CodeGraph has bounded navigation evidence; Headroom passed a local
compression fixture with evidence-preservation assertions. These checks do not
establish total-session savings, production MCP lifecycle, or proxy/provider
compatibility.
Client configuration and provider routes are unchanged. See the
[evaluation and integration decisions](docs/token-efficiency-tools.md).

### Complete the multi-entry routing contract

The active `codex-led-agent-routing` OpenSpec change still tracks:

- a shared Cursor entry path;
- a fully portable Hermes profile contract;
- clean-worktree attribution evidence;
- final end-to-end validation; and
- measurement before introducing any dynamic free-model pool.

### Evaluate Orca

Orca is an optional workspace and terminal surface. It remains isolated from the critical path while five real tasks test whether it materially improves supervision, worktree visibility, long-running execution, or recovery.

No Hermes-to-Orca bridge, automatic task mirroring, or merged Codex runtime is approved.

### Classify the remaining capability gaps

The [README artifact taxonomy](README.md#artifact-categories) now distinguishes
instructions and context, execution and integrations, and control and evidence.
It identifies candidate work on agent/handoff definitions, authorization and
tool trust, execution isolation and recovery, behavioural evaluation,
observability/evidence retention, and distribution compatibility.

These are review directions, not implemented services or approved build plans.
There is no general agent registry, central schema registry, Arnesto-owned
gateway, or unified audit service. Existing client runtimes retain ownership
of credentials, sessions, trust state, and personal memory.

---

## 📋 Next Steps

1. Complete the Orca trial with evidence from real development tasks.
2. Evaluate Grok Agent as another possible surface without assuming integration or credential sharing.
3. Evaluate route changes against the client-specific baseline: Hermes/OpenCode
   templates select v2, Codex/Orca retain their explicit `codex-free` lane, and
   bounded worker admission remains separate.
4. Close or split the remaining `codex-led-agent-routing` tasks once the entry-surface experiments settle.
5. Select the next artifact/control gap only when a recurring task supplies
   concrete acceptance criteria; use the existing adapter before adding another
   registry, router, or coordinator.

---

## 🐛 Known Issues

- External model catalogs and free routes are inherently volatile; every promoted route needs a semantic smoke test.
- Codex lacks native model metadata for the `combo/free-coding` alias and uses
  fallback metadata. OmniRoute does not currently expose enough context data to
  define accurate values without guessing.
- The active routing OpenSpec contains unfinished Cursor and acceptance work.
- Worker file-scope checking happens after execution and excludes paths already
  dirty before the run. It is not filesystem isolation or automatic rollback.
- Input-token limits depend on completed-call usage reports and cannot prevent
  an oversized first request. Declared task sensitivity is not automatic data
  classification.
- Live behavioural evaluations are separate from `make check`; passing local
  contracts does not establish a model's quality or a provider's availability.
- The repository is intentionally opinionated and includes local-environment conventions that adopters should review before running setup.

---

## 📝 Notes

- Arnesto is a personal harness published as a reference and source of adaptable patterns.
- “Evolving” is an operating constraint, not an excuse for unverified churn: experimental edges must earn promotion into the stable core.
- Historical milestones live in Git and archived OpenSpec changes rather than in this status document.
