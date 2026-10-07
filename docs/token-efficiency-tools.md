# Token-efficiency tools

Evaluation date: 2026-09-27. Starting point:
[the shared Google AI Mode comparison](https://share.google/aimode/8kQdoqFeRpLDvqszO).
Its five names identify candidates; the upstream projects and local tests
provide the evidence below.

## Decisions

| Tool | Existing coverage | Arnesto decision |
| --- | --- | --- |
| RTK | Shared shell rule, rewrite hook, setup contracts; local version 0.45.0 | Keep the existing integration. RTK filters command output; it is not a general conversation-history compressor. |
| Caveman | Shared skill from the Matt Pocock pack | Keep user-triggered concise communication. Shorter prose alone does not establish total-token savings. |
| Ponytail | General simplicity rules and refactoring workflows, but no named skill | Add a scoped adaptation for reuse before implementation, with upstream license, source pin, and evaluation cases. |
| CodeGraph | No integration | Add an optional skill for local code navigation; verify the CLI on a synthetic repository before any real-project adoption. |
| Headroom | No integration | Add an optional skill and runnable local fixture. Keep application/proxy integration experimental until correctness is measured on representative payloads. |

The shared skills are available through Arnesto's existing Codex, Claude, and
Cursor skill-directory links; a client may need to refresh its skill catalog.
No extra always-loaded rules, global MCP registrations, or provider routing
changes are needed for these additions. CLI/runtime packages are optional;
the verification installations were isolated in temporary directories.

## How to choose

- Use RTK for noisy output from compatible shell commands.
- Invoke `caveman` when the user wants compressed prose.
- Invoke `ponytail` to examine reuse and platform capabilities before adding code.
- Use `codegraph` when repeated symbol/caller questions justify maintaining an index.
- Use `headroom` when large tool payloads remain after sensible filtering and
  the application can compare compressed input against the original.

Ponytail does not replace a requested feature with a smaller one. CodeGraph
does not replace source verification. Headroom does not guarantee lossless
recovery merely because a compressed result contains a retrieval marker.

## Verification and limits

- CodeGraph 1.6.0 indexed one synthetic JavaScript file into four nodes and
  five edges, then returned the expected symbol and its two known callers.
  It was not registered as an MCP server or run against a real repository.
- Headroom 0.39.1 compressed a 1,000-record synthetic tool response from 26,101
  to 9,116 tokens using the real cached tokenizer. The rare error marker,
  system instructions, recent four messages, and original input passed
  preservation assertions. The base package used pure-Python content detection;
  no ML model or LLM provider was involved.
- Ponytail's adapted instructions have routing and behavior evaluation cases;
  no baseline-versus-skill model run has been performed.

These are bounded functionality checks. Upstream percentage claims concern
their own benchmarks and do not establish savings for Arnesto. Measure total
tokens, cached-token behavior, time, quality, and setup overhead on the same
tasks before promoting either experimental runtime integration.

## Ownership and maintenance

- [Ponytail skill](../.agents/skills/ponytail/SKILL.md): Arnesto-maintained
  adaptation of [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail).
  Preserve the MIT notice and refresh the pinned provenance when updating.
- [CodeGraph skill](../.agents/skills/codegraph/SKILL.md): native runbook for
  [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph), MIT.
  The runbook disables telemetry and separates indexing from agent installation
  and Git-hook changes.
- [Headroom skill](../.agents/skills/headroom/SKILL.md): native runbook for
  [headroomlabs-ai/headroom](https://github.com/headroomlabs-ai/headroom), Apache-2.0.
  Its trial disables telemetry, update checks, ML compression, and persistent
  payload storage. Keep the original payload available for correctness checks.

Review package versions, runtime effects, and these examples before upgrading.
Run the skill-library validator and `make check` after changing the integration.
