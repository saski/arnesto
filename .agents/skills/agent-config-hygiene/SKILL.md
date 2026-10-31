---
name: agent-config-hygiene
description: Audit, update, and publish cross-tool agent configuration through Arnesto. Use for agent configuration instructions, AGENTS.md hierarchies, always-loaded rules, skill routing, client wrappers, local runtime boundaries, or instruction/context cleanup.
---

# Agent Configuration Hygiene

Audit first. Do not modify configuration unless the user explicitly asks for
changes. Preserve unrelated worktree changes and distinguish repository state
from mutable local runtime state.

## Review workflow

1. Identify the instruction surfaces that the active clients actually load:
   global instructions, repository instructions, directory rules, client
   wrappers, selected skills, templates, and local runtime configuration.
2. Classify each artifact as one of:
   - universal invariant;
   - repository contract;
   - task- or language-specific instruction;
   - explicit skill or workflow;
   - maintainer documentation;
   - mutable local runtime state.
3. Measure the always-loaded and routed word counts. Count transitive includes
   and pointers when they instruct the client to load another file.
4. Look for duplicate loading paths, broad triggers, unreferenced rules,
   machine-specific values in portable rules, and multiple sources of truth.
5. Prefer deletion, a narrower trigger, or an existing artifact before adding
   a new rule, skill, wrapper, or script.
6. Put deterministic invariants in the repository's existing validation suite.
   Keep judgment and trade-off analysis in this skill.
7. Run focused checks while iterating and the repository's canonical validation
   after meaningful changes.

## Decision rules

- Always-loaded rules contain only behavior needed across most tasks.
- Repository rules contain only project-specific entry points and invariants.
- Language guidance loads when the task touches that language, not because a
  vendored example happens to use it.
- Skills load from the active client's catalog. A full inventory is a
  maintenance artifact, not a routine routing prerequisite.
- Runtime paths, credentials, sessions, trust data, and mutable preferences stay
  local. Versioned templates define portable defaults without absorbing local
  runtime state.
- A safety boundary belongs in documentation plus a targeted workflow unless it
  must affect most tasks.

## Shared Ownership and Publication

- All agent configuration instructions have their authoritative source in
  Arnesto `.agents`, including communication preferences. Do not keep an
  independent policy in client-specific memory or configuration.
- Client-specific syntax and capabilities may require adapters or versioned
  templates in Arnesto. They implement shared policy rather than creating a
  separate source of instructions. Keep credentials and mutable runtime state
  local; do not merge client runtime homes or publish private data.
- Every authorized Arnesto update includes validation, a scoped commit, and a
  push to the configured Arnesto remote. The user granted this standing
  publication authorization on 2026-10-31; a later explicit local-only request
  takes precedence. It does not authorize unrelated changes or changes in
  other repositories.
- Read the worktree and index before staging. Preserve unrelated changes,
  including hunks in shared files. Review the exact staged diff for scope and
  sensitive data, update existing version metadata where applicable, and run
  the canonical checks. Do not bypass failed checks or hooks.
- Verify the remote and branch before pushing, using the `github-host-alias`
  skill. Never force-push or rewrite unrelated history. If remote changes,
  authentication, permissions, or checks block publication, report the exact
  blocker and keep local/published status distinct.
- After pushing, verify that the remote branch contains the committed update
  and report the commit. Check available CI without treating push success as
  evidence that CI passed. Do not create release tags unless requested.

## Report

Lead with prioritized findings and cite exact files and lines. For each finding,
state the observed loading path, its ongoing cost, and the smallest reversible
improvement. Separate verified facts from client-behavior assumptions. End with
the checks run, skipped validation, and whether current changes are ready to
commit.

Do not turn this skill into an always-loaded rule. Its value comes from explicit,
occasional review.
