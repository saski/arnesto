---
name: codegraph
description: >
  Use the local CodeGraph CLI or an already configured MCP server to find
  symbols, callers, dependencies, and change impact in a repository. Use when
  the user names CodeGraph or repeated structural code exploration would benefit
  from a reusable index. Not for a simple text lookup, prose-only repositories,
  or automatic installation into every agent.
---

# CodeGraph

Use a local structural index to locate relevant code, then read the actual
source and tests before drawing conclusions or editing. The index is evidence
for navigation, not proof that every dynamic reference has been found.

## Choose the scope

1. Identify the exact repository and the question to answer. Prefer `rg` for a
   simple literal lookup; do not create an index merely because the tool exists.
2. Inspect an existing `.codegraph/` and its configuration before changing it.
   Never index a home directory, filesystem root, or unrelated repositories.
3. Indexing creates local SQLite state and an internal `.codegraph/.gitignore`.
   Review exclusions first, especially secrets, generated files, and vendor
   code. Keep the index out of Git; do not loosen exclusions to increase counts.

## Use the CLI

The reviewed package is `@colbymchenry/codegraph@1.6.0` (MIT). The npm
distribution includes a platform runtime; npm still needs Node to launch the
shim. See [usage and sources](references/usage.md) for setup and test evidence.

Set these for every invocation, including through a client MCP environment:

```bash
export DO_NOT_TRACK=1
export CODEGRAPH_TELEMETRY=0
export CODEGRAPH_NO_UPDATE_CHECK=1
```

From the selected repository, after checking the initialization side effects:

```bash
npx --yes @colbymchenry/codegraph@1.6.0 init .
npx --yes @colbymchenry/codegraph@1.6.0 status .
npx --yes @colbymchenry/codegraph@1.6.0 query 'symbol_name' --path . --json
npx --yes @colbymchenry/codegraph@1.6.0 callers 'symbol_name' --path . --json
```

Run initialization interactively. Choose manual synchronization if it offers
Git hooks. Do not pass `init --yes` in a Git repository: that flag can install
hooks when the native watcher is unavailable. The `npx --yes` above only accepts
the package download; it is a different flag.

For an existing index after edits, run `sync .` with the same version and
environment. Use `--help` for `explore`, `node`, `callees`, or `impact` before
constructing a more specific query. Do not treat an empty or stale index as
evidence of no callers. Fall back to source search if indexing fails or the
language is unsupported.

## Optional MCP

Prefer an already configured server when its repository scope is known. The
server command is `codegraph serve --mcp`, run with the selected repository as
its working directory and the environment above. Registration is separate from
using the CLI: inspect the client's current configuration and prepare a scoped
change only when the task calls for it. `codegraph install` can edit agent
instructions, MCP settings, and tool permissions; do not run it as an implicit
prerequisite. Never auto-allow tools to make setup convenient.

## Verify and report

Confirm non-zero indexed files/nodes, resolve a known symbol to its real file,
and check at least one known caller. Read source around returned locations and
run the project's required checks for changes. Report missing coverage,
indexing errors, and stale results. A successful process exit alone is not a
useful index, and upstream savings are not an Arnesto benchmark.
