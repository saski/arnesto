# OpenCode Free-Agent Entry

OpenCode supports an explicit interactive free route and a constrained worker
mode. It does not switch to either one automatically.

## Interactive free route

Select `omniroute/combo/free-coding` for ordinary, non-sensitive coding work.
OpenCode only declares that single model identifier; OmniRoute owns the ordered
free-only selection and fallback policy. The normal OpenCode model remains
unchanged.

## Frontier work

Sensitive, ambiguous, or multi-step work stays in Codex App or Codex CLI.
Those frontier sessions use Codex directly and do not pass through OmniRoute.
The frontier principal owns planning, OpenSpec, delegation, review, and
integration.

## Bounded free work

Use the free route only for an explicitly authorized, non-sensitive bounded
task. Copy the provider and worker policy from
[`templates/opencode/free-worker.jsonc`](../templates/opencode/free-worker.jsonc).
The constrained worker adapter retains direct pins rather than inheriting combo
fallback. Its only admitted models are:

- `omniroute/oc/deepseek-v4-flash-free`
- `omniroute/oc/big-pickle`

## Managed local installation

Install only the managed OpenCode fields with:

```bash
./setup-symlinks.sh opencode-free-worker
./setup-symlinks.sh validate-opencode-free-worker
```

The installer updates `~/.config/opencode/opencode.jsonc` atomically. It adds
the shared `combo/free-coding` route, the two direct worker pins, and the
constrained `free-worker` agent if they are missing. It preserves unrelated
top-level configuration, providers, models, agent definitions, and the existing
local OmniRoute endpoint when it uses either supported loopback form
(`localhost` or `127.0.0.1`). It never reads or writes OpenCode credential
storage.

The local configuration must be strict JSON. A comment-bearing or malformed
JSONC file, a different OmniRoute endpoint, or an incompatible managed agent
is a visible conflict and leaves the file unchanged.

Dispatch the work through a versioned contract, then return the result to the
frontier principal for diff and validation review:

```json
{
  "contract_version": "1",
  "mode": "free",
  "execution_role": "worker",
  "parent_role": "frontier",
  "parent_run_id": "run-example",
  "delegation_depth": 1,
  "task_id": "task-example",
  "task_class": "bounded_code",
  "sensitivity": "non_sensitive",
  "working_directory": "/absolute/path/to/clean-worktree",
  "requirement": "Implement one precise, bounded change.",
  "require_changes": true,
  "allowed_files": ["relative/path/to/file"],
  "validation": { "command": ["bash", "tests/example-test.sh"] },
  "model": "omniroute/oc/deepseek-v4-flash-free",
  "timeout_seconds": 180
}
```

Run it with:

```bash
.agents/skills/free-agent-execution/scripts/run-free-worker /absolute/path/to/contract.json
```

This adapter is the single supported Codex-to-OpenCode dispatcher. Do not
replace it with a direct `opencode run` when Codex delegates work: that bypasses
the role envelope, policy limits, file attribution, and structured result.

The `bounded_code` policy currently caps a worker at three steps, 50,000
cumulative input tokens, and 180 seconds. The adapter reports a stable
`termination_reason`, stops after observed usage exceeds the context budget,
and rejects a no-op when `require_changes` is true. Usage is visible only after
a provider call emits its `step_finish` event, so the first oversized request
may cross the threshold; the guard prevents repeated oversized iterations.

The historical `free-deterministic` combo failed a minimal semantic probe with
`payment_required` at pipeline step 3 (`longcat/LongCat-2.0`). It and
`free-stack` were inactive and removed from the local OmniRoute store on
2026-08-21. They are retired, not fallback candidates. Keep the direct verified
worker pins until a replacement passes the same semantic and bounded-edit
conformance.

## Hard prohibitions

The free route must not receive credentials, secrets, environment values,
personal data, or other sensitive content. It must not use `auto/*`, paid
models, shell access, recursive delegation, or automatic fallback.

## Recovery

If the selected free route is unavailable or semantically unhealthy, surface
the failure and do not retry on a paid model. Continue through direct Codex
frontier work only when that is an explicit decision; otherwise stop and report
the blocker.
