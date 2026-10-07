---
name: headroom
description: >
  Evaluate or integrate Headroom for large repetitive tool outputs, JSON, logs,
  or retrieved context. Use when the user names Headroom or asks to measure
  context compression in an application they control. Start with a local
  library trial; not a default proxy, provider switch, prose-shortening mode,
  or solution for an ordinary small command result.
---

# Headroom

Treat compression as a transformation that must preserve task-critical
evidence. Start with a synthetic local example, then compare representative
payloads before changing any running agent's request path.

## Choose the integration

- Prefer upstream query filtering, bounded reads, or RTK for simple shell
  output. Avoid stacking compressors without measuring the combined result.
- Use the Python library when the application owns the request payload. The
  reviewed package is `headroom-ai==0.39.1`, requiring Python 3.10 or newer.
- A proxy, `headroom wrap`, or MCP installation is a separate integration:
  those paths can change provider routing, credentials handling, configuration,
  and stored context. Inspect those changes before applying them; this skill
  does not authorize a client migration or imply desktop-client compatibility.

## Start locally

Use the project's dependency manager, or an isolated environment for a trial.
Install the pinned base package, not `[all]`, for the example in
[local trial](references/local-trial.md). Disable telemetry and update checks
before running it. The example uses no API key and makes no LLM request.

```python
from headroom import CompressConfig, compress

result = compress(
    messages,
    model="gpt-4o",  # Tokenizer selection for this example; no model request.
    config=CompressConfig(
        kompress_model="disabled",
        compress_system_messages=False,
        compress_user_messages=False,
        protect_recent=4,
    ),
)
```

Use the actual target model's supported tokenizer for a real evaluation. A
first tokenizer load can require a vocabulary download. Do not report estimated
counts as measured tokens. Disabling Kompress avoids its ML-model download;
it does not make initial package/tokenizer installation offline.

## Check evidence preservation

1. Retain the original payload separately. Library compression is lossy; full
   retrieval requires a working retained store and retrieval integration.
2. Verify system instructions, current user intent, and recent messages remain
   intact. Protect tool-call IDs, relevant errors, rare outliers, and exact data
   needed by the task. Do not truncate away permission or policy information.
3. Compare downstream answers and required assertions with and without
   compression. Token reduction alone is not success.
4. If data is missing, counts are estimates, the store is unavailable, or
   correctness regresses, use the original payload and report the limitation.

## Report and contain the trial

Report package version, configuration, original and compressed token counts,
preservation checks, and whether a provider was actually tested. Keep cache,
logs, retained payloads, and databases outside Git. In-memory retrieval ends
with the process; do not promise reversible recovery after it exits.

Arnesto supplies this optional runbook. It does not enable a proxy, install an
MCP server, change OmniRoute, or claim end-to-end savings from a local fixture.
