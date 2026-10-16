# CodeGraph and rg comparison in Agent Systems Lab

The local pilot supports keeping `rg` as the default in `agent-systems-lab`.
CodeGraph returned useful caller relationships, but the exploratory agent run
retrieved only 4.6% fewer evidence tokens, used more queries, and missed an
individual call site. CodeGraph remains suitable for occasional structural
questions, with source verification and explicit index synchronization.

## Scope and isolation

- Date: 2026-10-13, Europe/Madrid.
- Repository: `/Users/saski/Code/agent-systems-lab`.
- Commit: `4078a2216864f0f94c692489149c69f3b9af445b`; clean checkout.
- Corpus: 14 source and 10 test Python files, plus `pyproject.toml`, copied
  byte-for-byte into a temporary directory. The 25 copied files total 4,778
  lines including packaging metadata. Frontend files, documentation, agent
  definitions, ignored runtime state, credentials, and Git internals were not
  included in the index.
- Tools: CodeGraph `1.6.0`, ripgrep `15.2.0`.

CodeGraph was installed under the temporary experiment directory with
`npm install --prefix ... --ignore-scripts --no-audit --no-fund`; no global
package installation or agent installer was used. Every invocation set
`DO_NOT_TRACK=1`, `CODEGRAPH_TELEMETRY=0`, and
`CODEGRAPH_NO_UPDATE_CHECK=1`. The snapshot had no Git repository, so indexing
could not install hooks into the original checkout. No MCP registration,
watcher, provider-routing change, or application execution was part of the
experiment. The daemon inventory reported no running CodeGraph daemons.

Initialization reported 24 indexed Python files, 463 nodes, 1,168 edges, and
729 ms of indexing work. The database occupied 1,654,784 bytes. This excludes
package installation time, CLI startup, and interactive preparation.

## Exploratory agent comparison

Two fresh agents used the same model (`gpt-6-luna`) and reasoning effort
(`medium`). Both received the same four questions and the same source corpus.
Each agent retained its own context between questions; they did not see each
other's answers. One arm used raw `rg` and bounded source reads. The other
used CodeGraph CLI queries and the same bounded source reader. All repository
evidence passed through a logging wrapper.

The wrapper recorded command arguments, exit codes, execution time, and
delivered output. Both arms had a 24,000-character output cap; no recorded
result reached it. Tokens below were counted over the delivered evidence with
`tiktoken 0.12.0` and `o200k_base`. They exclude prompts, conversation rereads,
tool-call metadata, reasoning, generated answers, cache billing, and provider
cost. They are a common content-size measure, not the workers' billed tokens.

**Protocol deviation:** both agents were instructed to stop at 22 evidence
queries. The `rg` arm used 22; CodeGraph used 31, including one malformed CLI
query. CodeGraph also had two earlier argument-validation failures that
returned no repository evidence and were not logged by the wrapper. The cap
was not enforced in code. Consequently, this is an exploratory comparison of
two observed search strategies, not a controlled estimate of CodeGraph's
effect. The CodeGraph arm used `query`, `callers`, `files`, and source reads;
it did not exercise `explore` or `node` during this run.

| Question | rg queries | CodeGraph queries | rg evidence tokens | CodeGraph evidence tokens |
| --- | ---: | ---: | ---: | ---: |
| Definition and calls of `workflow` | 5 | 4 | 8,374 | 5,362 |
| Governed execution and authorization | 8 | 11 | 8,525 | 11,887 |
| Review-capacity exports and tests | 5 | 7 | 12,209 | 8,548 |
| Human approval, persistence, and resume | 4 | 9 | 3,871 | 5,666 |
| Total | 22 | 31 | 32,979 | 31,463 |

CodeGraph retrieved 1,516 fewer evidence tokens (4.6%) and made nine more
queries (40.9%). It retrieved less for two questions and more for two.
Differences in answer completeness prevent treating the total as a quality-
preserving savings result.

## Correctness review

The primary agent independently inspected source and tests and enumerated
`workflow` call sites with Python's AST. The verified definition is
`src/systems_lab/orchestrator.py:156`. Its five invocation sites are
`src/systems_lab/cli.py:92,139` and `tests/test_workflow.py:20,43,57`.

| Question | rg answer | CodeGraph answer |
| --- | --- | --- |
| Workflow calls | Identified all five call sites. | Omitted `cli.py:139` and incorrectly claimed only one production call. |
| Governed execution | Explained the worker/runtime/HTTP chain and authorization checks, including revocation through run status. | Explained the core checks; did not explicitly trace `worker.main` or the implementation of `Store.revoke`. |
| Export path | Identified JSON artifacts, integrity checks, and the manifest completion marker; included the CLI regression test. | Identified the same artifact format and completion marker; omitted the CLI regression test. |
| Approval and history | Identified SQLite checkpoints and resume checks; explicitly left Store decision internals uninspected. Its final statement about absent callback registration conflicts with `graph.add_node`. | Gave a fuller explanation of `Store.decide` and the separation between gateway history and workflow checkpoints. |

These differences are agent-answer errors or omissions, not proof that either
retrieval tool necessarily causes them. In particular, `codegraph callers
workflow --json` correctly returned the enclosing production function
`execute` and both test functions, plus two file-level entries. Its function
records identify caller definitions, not every invocation line. Reading
`execute` reveals both production calls. File-level entries must not be
counted as additional function call sites.

The graph's `callees workflow` also listed `validate` and `human_review`.
Source shows those functions passed to `graph.add_node`; their presence in a
relationship trail does not establish direct Python execution order. The
runtime-to-gateway HTTP boundary likewise still requires reading the client
request and server dispatch code. Neither a static graph nor text search
alone proves the complete execution flow.

Tests were inspected as evidence, not executed. This comparison establishes
source navigation and answer fidelity, not runtime behavior or passing tests.

## Repeated CLI queries

After the agent runs, two lookup pairs were repeated with two warmups and ten
measured runs per arm. Execution order alternated between arms. Both commands
searched the same snapshot for uses of the same symbol:

```text
rg -n '\bworkflow\s*\(' src tests
codegraph callers workflow --json --path SNAPSHOT

rg -n '\bexport_attempt\s*\(' src tests
codegraph callers export_attempt --json --path SNAPSHOT
```

| Symbol | rg median CLI time | CodeGraph median CLI time | rg output tokens | CodeGraph output tokens |
| --- | ---: | ---: | ---: | ---: |
| `workflow` | 9.43 ms | 166.45 ms | 156 | 238 |
| `export_attempt` | 10.35 ms | 165.52 ms | 637 | 921 |

These are query-process timings, not agent task durations. The outputs have
different semantics: `rg` returns textual occurrences, including a definition;
CodeGraph returns distinct caller symbols and file records. The measurements
show CLI startup/lookup overhead and output size in this small corpus, not
equivalent answer quality. An already-running local MCP server could have
different latency; it was not measured or configured.

A supplemental `node workflow` query returned numbered source and caller/
callee trails. A supplemental `explore 'review capacity export report'
--max-files 3` returned relevant export code but also telemetry and
orchestrator code, while leaving the CLI implementation and export tests for
follow-up queries. These paths may support a better strategy than the agent's
initial `query` plus read sequence; no comparative agent rerun was performed.

## Index freshness

A temporary `benchmark_workflow_caller` function was appended to the copied
`tests/test_workflow.py`, never to the original repository.

1. `rg` immediately found the new invocation at line 64.
2. `codegraph callers workflow` did not report the new function before sync.
3. `codegraph sync SNAPSHOT` reported one changed file and 71 ms of indexing
   work; the next caller query included `benchmark_workflow_caller` at line 63.
4. The temporary file was restored byte-for-byte and the index synchronized
   again. Restoration was verified against the initial SHA-256 manifest.

For this CLI setup without a watcher, a caller result can be stale until an
explicit sync. This does not test or contradict auto-sync in a configured MCP
session.

## Adoption decision

Keep `rg` for literal search and routine navigation in this repository.
Consider CodeGraph on demand when several structural caller, callee, or impact
questions justify an index. Use its source-bearing `node` or `explore` paths,
inspect returned source, and synchronize after edits. This small Python repo
does not provide enough evidence to replace the default or enable CodeGraph
globally. A larger repository, another language, and an enforced protocol with
multiple independent runs would be separate evaluations.

Original source hashes, repository commit/status, Git hooks, Codex config and
hooks, and the shared MCP config matched their initial values after the
experiment. No commit or push was performed.

## Evidence and reproduction

- Structured measurements: [comparison data](codegraph-vs-rg-2026-10-13.json).
- Raw answers, question/rubric files, source manifest, wrapper, outputs, and
  repeat measurements are retained locally at
  `/private/tmp/codegraph-rg-20261013-f0kjno8y`. Temporary storage is not a
  durable archive. The original repository content was not duplicated into
  Arnesto.
- The temporary `measure.py` accepts an arm, question ID, and `rg`, `cg`, or
  bounded `read` action. `repeat.py` reproduces the warm query timings with the
  temporary CodeGraph binary and metrics environment. The JSON file records
  the exact commands and individual repeat timings.
- No LLM billing or total-token records were collected. No total-cost saving
  is claimed.

Related: [token-efficiency tools](../token-efficiency-tools.md),
[CodeGraph usage](../../.agents/skills/codegraph/references/usage.md).
