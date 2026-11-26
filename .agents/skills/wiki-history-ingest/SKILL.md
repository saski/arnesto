---
name: wiki-history-ingest
description: >
  Unified wiki-history-ingest entrypoint for conversation/session sources. Use this when the user says
  "/wiki-history-ingest claude" or "/wiki-history-ingest codex", or asks to ingest agent history without
  naming the underlying skill. This router dispatches to the specialized history skill.
---

# Unified History Ingest Router

This is a thin router for **history sources only**. It does not replace `wiki-ingest` for documents.

## Subcommands

If the user invokes `/wiki-history-ingest <target>` (or equivalent text command), dispatch directly:

| Subcommand | Route To |
|---|---|
| `claude` | `claude-history-ingest` |
| `codex` | `codex-history-ingest` |
| `auto` | infer from context using rules below |

## Routing Rules

1. If the user explicitly says `claude` or `codex`, route directly.
2. If the user provides a path/source:
   - `~/.claude` or Claude memory/session JSONL artifacts -> `claude-history-ingest`
   - `~/.codex` or rollout/session index artifacts -> `codex-history-ingest`
3. If ambiguous, ask one short clarification:
   - "Should I ingest `claude` or `codex` history?"
4. If the user asks for another history source, say that only `claude` and `codex` history ingesters are installed in this repository.

For other agent formats, report that a dedicated ingester is unavailable. If the user supplied an export and wants it ingested, route that file to `data-ingest` instead of assuming another agent’s history layout or opening unrelated sessions.

## Execution Contract

- After routing, execute the destination skill's workflow exactly.
- Do not duplicate destination logic in this file.
- Leave manifest/index/log update semantics to the destination skill.

## UX Convention

- Use `wiki-ingest` for **documents/content sources**
- Use `wiki-history-ingest` for **agent history sources**

Examples:

- `/wiki-history-ingest claude`
- `/wiki-history-ingest codex`
- `$wiki-history-ingest claude` (agents that use `$skill` invocation)
