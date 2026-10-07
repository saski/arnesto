# CodeGraph usage and evidence

Reviewed 2026-09-27; package tested: `@colbymchenry/codegraph@1.6.0`.
Release source: `dfccdf62547fcd76d343344d823a0e1998d3a89f`.

## Operating notes

- Initial package installation needs npm network access. Use the project's
  existing package policy; keep cache and binaries outside the repository.
- The published npm package bundles a platform-specific runtime. The source
  repository's development Node engine requirement is a different constraint.
- `init` creates `.codegraph/`, builds an index, and may offer watch/git-hook
  integration. Check the current command and configuration before indexing an
  existing project; do not accept extra setup implicitly.
- `init --yes` can install Git hooks if watching is unavailable. Use an
  interactive terminal and select manual sync instead. It creates an internal
  `.codegraph/.gitignore`; it does not rewrite the repository's root ignore file.
- Index files and any source stored in the local database are runtime state.
  The MCP server synchronizes edits; CLI users can run `sync` explicitly.
- CodeGraph has optional usage telemetry enabled by default. Set
  `DO_NOT_TRACK=1 CODEGRAPH_TELEMETRY=0 CODEGRAPH_NO_UPDATE_CHECK=1` before the
  first invocation. Local indexing requires no LLM provider, but the agent
  using returned source may send that context to its configured provider.
- No global installer, watcher, permission rule, or MCP registration is part
  of this Arnesto skill. Global shared MCP configuration is not a universal
  client installer; Codex keeps its own mutable config.

## Local smoke evidence

On macOS arm64, the pinned npm CLI indexed a temporary JavaScript fixture:
one file, four nodes, five edges. `query double --json` returned `math.js` at
line 1. `callers double --json` returned both `total` (a callback reference) and
`calculate` (a direct call), matching the source. No real project was indexed
and no client registration was changed.

This verifies a small CLI path. MCP lifecycle, large-repository performance,
other languages, and token/cost savings have not been tested locally.

## Evaluation cases before wider use

Compare the same structural questions with `rg` plus source reads and with the
index. Check correct files/symbols, missed dynamic references, stale-index
behavior after an edit, tool calls, total tokens, latency, index size, and
initialization cost. Include a simple lookup where indexing should be skipped.
Keep only if the same answer quality justifies the added local state.

## Primary sources

- [Project and usage](https://github.com/colbymchenry/codegraph)
- [Pinned CLI source](https://github.com/colbymchenry/codegraph/blob/dfccdf62547fcd76d343344d823a0e1998d3a89f/src/bin/codegraph.ts)
- [Telemetry policy](https://github.com/colbymchenry/codegraph/blob/main/TELEMETRY.md)
- [Pinned npm package](https://www.npmjs.com/package/@colbymchenry/codegraph/v/1.6.0)

This is a native Arnesto runbook, not a copy of the upstream skill or installer.
