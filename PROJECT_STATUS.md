# Arnesto - Project Status

**Last Updated**: 2026-08-21
**Overall Status**: 🟢 **Ready and evolving** - The core harness is operational; new clients and routing ideas remain evidence-gated experiments.

---

## Executive Summary

| Component | Status | Progress | Blocking |
|---|---|---:|---|
| Shared rules, skills, and commands | ✅ Complete | 100% | - |
| Progressive instruction loading | ✅ Complete | 100% | - |
| Setup and canonical validation | ✅ Complete | 100% | - |
| OpenSpec and durable planning | ✅ Complete | 100% | - |
| Hermes, OpenCode, and OmniRoute integration | 🟢 Ready | Operational | Provider health can change |
| AI Studio Android workbench | 🟢 Validated edge | Health tracking build/install loop | Hosted capabilities can change |
| Multi-entry routing contract | 🟡 In Progress | 27/38 tasks | Cursor entry and final acceptance remain |
| Orca evaluation | 🟡 In Progress | Level-1 trial | Needs evidence from real tasks |
| Grok Agent evaluation | ⚠️ Pending | 0% | Starts after the Orca trial |

**Current Readiness**: Arnesto is ready for daily use in its current personal environment. It is published as a reference implementation, not as a universal drop-in distribution.

---

## ✅ Completed Components

### Portable operating core

- One compact universal rulebook with narrower repository and contextual rules.
- Shared skills and commands routed on demand instead of loaded globally.
- Versioned templates and adapters for supported clients.
- Stable `~/.agents` entry point with deterministic symlink validation.
- Separate runtime ownership for credentials, sessions, databases, trust state, and mutable preferences.

### Durable delivery workflow

- OpenSpec for requirements, architecture decisions, tasks, and acceptance evidence.
- File-backed research and implementation plans for work that outlives one context window.
- Behaviour-level contracts for setup, skill governance, routing, and failure semantics.
- Canonical `make check` locally and `make ci-check` in GitHub Actions.

### Agent execution and remote entry

- Codex remains the frontier planning, integration, and review surface.
- Bounded, non-sensitive work can use the governed OpenCode free-worker adapter.
- Hermes provides a persistent Telegram entry surface with explicit provider boundaries.
- OmniRoute routes only explicitly admitted free-worker models; semantic failure is not accepted as success.

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
  Terra/Medium Codex and Orca defaults.
- The ordered `free-coding` desired state is versioned separately from mutable
  OmniRoute runtime state, with fixed diagnostic pins and drift-safe setup.
- The local combo is installed and passed exact-text, structured tool-call, and
  read-only Codex, Hermes, and OpenCode entry probes with non-zero usage.
- Hermes and OpenCode expose the shared combo by identifier, while Codex and
  Orca terminals reuse `codex-free`; no client duplicates the preference order.
- The inactive `free-stack` and `free-deterministic` runtime combos were
  removed after a recoverable local backup.
- A portable company-environment bug-fixing skill is tracked for future use
  without embedding company-specific identifiers or credentials.

---

## 🚧 In Progress

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

---

## 📋 Next Steps

1. Complete the Orca trial with evidence from real development tasks.
2. Evaluate Grok Agent as another possible surface without assuming integration or credential sharing.
3. Evaluate whether `free-coding` should ever replace a client default; it is
   currently an explicit shared lane.
4. Close or split the remaining `codex-led-agent-routing` tasks once the entry-surface experiments settle.

---

## 🐛 Known Issues

- External model catalogs and free routes are inherently volatile; every promoted route needs a semantic smoke test.
- Codex lacks native model metadata for the `combo/free-coding` alias and uses
  fallback metadata. OmniRoute does not currently expose enough context data to
  define accurate values without guessing.
- The active routing OpenSpec contains unfinished Cursor and acceptance work.
- The repository is intentionally opinionated and includes local-environment conventions that adopters should review before running setup.

---

## 📝 Notes

- Arnesto is a personal harness published as a reference and source of adaptable patterns.
- “Evolving” is an operating constraint, not an excuse for unverified churn: experimental edges must earn promotion into the stable core.
- Historical milestones live in Git and archived OpenSpec changes rather than in this status document.
