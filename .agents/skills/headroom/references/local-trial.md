# Headroom local trial

Reviewed 2026-09-27. Package: `headroom-ai==0.39.1` (Apache-2.0).
Release source: `d13e1966f820220b482a33c30bde1e926743939a`.
The script beside this document is a native Arnesto fixture, not upstream code.

## Run the fixture

Use Python 3.10+ and the project's dependency manager. For a standalone trial,
create a temporary virtual environment and install `headroom-ai==0.39.1` there.
Use its explicit Python path; never install into the system Python. This base
package still brings substantial dependencies. Proxy/MCP/ML extras are not
required for the fixture.

The script sets telemetry/update opt-outs, an in-memory compression store, and
disables Kompress before importing Headroom. It preserves system and user
messages and the last four messages. First populate a chosen temporary
`TIKTOKEN_CACHE_DIR` with the public `o200k_base` vocabulary using that Python:

```bash
TIKTOKEN_CACHE_DIR=/path/to/temporary/tokenizer-cache /path/to/venv/bin/python -c 'import tiktoken; tiktoken.get_encoding("o200k_base")'
```

Then run, substituting the actual paths:

```bash
HEADROOM_OFFLINE=1 HF_HUB_OFFLINE=1 \
TIKTOKEN_CACHE_DIR=/path/to/temporary/tokenizer-cache \
/path/to/venv/bin/python /path/to/arnesto/.agents/skills/headroom/references/local-smoke.py
```

No provider credentials or request are needed. `HEADROOM_OFFLINE` is a tool
setting, not a network sandbox; enforce network isolation separately when
required. Fail the trial if tokenizer loading falls back to estimation.

## Observed result

Tested on macOS arm64 with Python 3.14.7, the pinned package, and a populated
tiktoken vocabulary cache. The 1,000-record synthetic JSON fixture went from
26,101 to 9,116 tokens. Assertions passed for:

- a rare error marker still present;
- unchanged system instructions and the last four messages;
- the original caller-owned input remaining unchanged;
- a positive token reduction.

The base install reported a pure-Python content-detection fallback because
optional ONNX Runtime was absent. No ML model or LLM provider was used. This
single synthetic result does not establish downstream answer quality, typical
session savings, or proxy/MCP compatibility.

The first trial attempted the default persistent compression store and fell
back to memory because the sandbox disallowed writing `~/.headroom`. The
rerun explicitly selected `HEADROOM_CCR_BACKEND=memory`; use this for a local
fixture, and never promise persistence or full recovery after process exit.

## Evaluation before adoption

Compare complete answers on representative payloads: repeated JSON with one
critical outlier, logs with a rare causal error, source code requiring exact
lines, and already-small inputs. Verify tool-call/result pairing and frozen
cache prefixes for the target application. Measure total tokens, latency,
cache misses, compression overhead, and correctness against the original.
Test unavailable retrieval and an expired store; both must fall back to
available original data or be disclosed as missing evidence.

## Primary sources

- [Project and integration choices](https://github.com/headroomlabs-ai/headroom)
- [Pinned compression API](https://github.com/headroomlabs-ai/headroom/blob/d13e1966f820220b482a33c30bde1e926743939a/headroom/compress.py)
- [Package metadata](https://pypi.org/project/headroom-ai/0.39.1/)
- [Tokenizer cache behavior](https://github.com/openai/tiktoken/blob/main/tiktoken/load.py)
