---
name: free-agent-execution
description: Run an explicitly requested, bounded, non-sensitive coding task through the local free-worker adapter using a verified free OpenCode model. Use only when the user asks to execute a free worker or free agent and accepts the external-model safety boundary.
---

# Free Agent Execution

Use the bundled `scripts/run-free-worker` adapter to execute one bounded worker task. The frontier agent remains responsible for preparing the contract, reviewing the result, and deciding what to keep.

Do not invoke the adapter unless the user explicitly authorizes free-agent execution. Never include secrets, credentials, personal data, or other sensitive material in the requirement or working tree.

## Invocation

Pass one JSON contract file:

```bash
.agents/skills/free-agent-execution/scripts/run-free-worker /absolute/path/to/contract.json
```

The adapter writes one JSON result to standard output. A missing or unreadable contract is a usage error with exit status `2`. Contract, model, worker, scope, and validation failures are returned as JSON with `status: "failed"`.

## Input contract

Use this shape:

```json
{
  "contract_version": "1",
  "mode": "free",
  "execution_role": "worker",
  "parent_role": "frontier",
  "parent_run_id": "run-123",
  "delegation_depth": 1,
  "task_id": "task-1.1",
  "task_class": "bounded_code",
  "sensitivity": "non_sensitive",
  "working_directory": "/absolute/path/to/git-worktree",
  "requirement": "Implement one precise, bounded change.",
  "require_changes": true,
  "allowed_files": [
    "relative/path/to/file"
  ],
  "validation": {
    "command": [
      "make",
      "test"
    ]
  },
  "model": "omniroute/oc/deepseek-v4-flash-free",
  "timeout_seconds": 30
}
```

The adapter requires these values and types:

- `contract_version`: exactly `"1"`.
- `mode`: exactly `"free"`.
- `execution_role`: exactly `"worker"`.
- `parent_role`: exactly `"frontier"`.
- `sensitivity`: exactly `"non_sensitive"`.
- `working_directory`: a non-empty absolute path inside a Git worktree. Prefer the worktree root so Git paths match `allowed_files`.
- `requirement`: a non-empty string containing one bounded implementation task.
- `allowed_files`: an array of worktree-relative file paths. Use exact Git path spelling.
- `validation.command`: a non-empty array of executable and argument strings. It is executed directly, without shell interpolation.
- `model`: one of the verified models below.
- `task_class`: a configured free-worker task class. Version one provides `bounded_code`.
- `parent_run_id`: a non-empty string identifying the delegating frontier run.
- `require_changes`: an optional boolean. Set it to `true` for edit tasks so a non-empty explanation without an attributed file change fails visibly. Omit it or set it to `false` when a no-change result is valid.
- `task_id`: a non-empty string identifying this task within the delegation tree.
- `delegation_depth`: exactly `1` for a worker contract.

Every configured task class declares `max_steps`, `max_input_tokens`, and
`max_timeout_seconds` in the routing manifest. These policy ceilings override
contract preferences. Version one's `bounded_code` values are `3`, `50000`,
and `180`, respectively. The adapter rejects a requested timeout above the
class ceiling.

## Role envelope

The shared version-one role envelope distinguishes entry from worker contracts:

- **Entry contracts** use `mode frontier` or `free`, `execution_role entry`, a non-empty `task_id`, `delegation_depth 0`, and omit `parent_role` and `parent_run_id`.
- **Worker contracts** accepted by this adapter require `mode free`, `execution_role worker`, `parent_role frontier`, a non-empty `parent_run_id`, a non-empty `task_id`, and `delegation_depth 1`.

A context that is already acting as an OpenCode worker must not re-enter as entry. The adapter rejects such contracts before opening another OpenCode invocation.

## Verified free models

The checked-in routing manifest at `.agents/free-agent-routing.json` is the source of truth. Treat the manifest, not this document, as authoritative for which model identifiers the adapter admits: both `verified_free_models` and `free_worker.task_classes.<class>.models`.

Version one (2026-07-26) verified two `omniroute/oc/*` identifiers for `bounded_code`:

- `omniroute/oc/deepseek-v4-flash-free`
- `omniroute/oc/big-pickle`

Six `omniroute/opencode-zen/*` identifiers were reconciled with the live OmniRoute catalog and tested on 2026-07-30. All returned an OpenCode status-1 failure with no usable completion, so they are quarantined and absent from the manifest. Use only the two original `oc/*` models unless a future conformance run promotes another model.

OmniRoute advertised `free-deterministic` on 2026-08-06, but its minimal
semantic probe failed with `payment_required` at pipeline step 3,
`longcat/LongCat-2.0`. The inactive combo and the obsolete `free-stack` combo
were removed from the local store on 2026-08-21. They are retired and are not
admitted to the manifest.

Do not substitute aliases or newly advertised free models without updating the routing manifest and re-running `validate-routing-manifest`. The adapter still validates that the requested model is both globally verified and admitted for the requested task class.

## Routing manifest

The manifest is non-secret and declares the frontier owner, verified free models, allowed task classes, and frontier-only privacy categories. Validate it after every policy change:

```bash
.agents/skills/free-agent-execution/scripts/validate-routing-manifest .agents/free-agent-routing.json
```

The validator rejects missing or non-positive class limits, missing task policies, non-OmniRoute free-worker models, defaults absent from the verified pool, class models absent from that pool, and common secret-like credential values.

## Result contract

A completed adapter run returns:

```json
{
  "status": "succeeded",
  "model": "omniroute/oc/deepseek-v4-flash-free",
  "termination_reason": "completed",
  "summary": "Implemented the bounded task.",
  "changed_files": [
    "relative/path/to/file"
  ],
  "validation": {
    "command": [
      "make",
      "test"
    ],
    "status": "passed"
  },
  "usage": {
    "input_tokens": 10,
    "output_tokens": 20
  }
}
```

`status` is `"succeeded"` only when OpenCode exits successfully, returns usable final text, satisfies any `require_changes` postcondition, changes no newly dirty paths outside `allowed_files`, stays within policy, and the validation command passes. `termination_reason` is stable for programmatic handling; examples include `completed`, `context_budget_exceeded`, `timeout`, `required_changes_missing`, `scope_violation`, and `validation_failed`. The preferred final format is `FREE_AGENT_RESULT` because it gives a concise structured summary; ordinary non-empty final text is retained as the summary when the worker does not follow that format. Failed runs include a `diagnostic` when the adapter reaches normal result assembly.

`changed_files` contains paths that are dirty after the worker but were not dirty immediately before it ran. Pre-existing tracked and untracked changes are intentionally excluded.

## Safety boundaries

- The adapter configures the worker with delegation (`task`) and shell (`bash`) denied. The frontier agent performs validation after the worker returns.
- The ephemeral worker is intentionally minimal: it has a concise task prompt,
  only `read` and `edit` enabled, and a policy-owned step cap. Do not broaden this
  tool surface without measuring the input-token impact and reviewing the
  safety boundary. Three 2026-07-30 bounded smokes used 20,082–20,509 input
  tokens versus a 90,297-token pre-minimization baseline.
- The adapter monitors cumulative input tokens reported by `step_finish`
  events and stops a worker after the class budget is exceeded. Usage becomes
  visible only after a provider call finishes, so this cannot prevent the
  first oversized request; it prevents the repeated 80k-150k-token loop that
  motivated the guard.
- `allowed_files` is a post-execution check, not a write sandbox. An out-of-scope change fails the result but is not reverted.
- The Git comparison is path-based. A worker change to a path that was already dirty before execution is not attributed or scope-checked. Use a clean worktree for stronger attribution, especially for allowed files.
- The validation command is trusted local code and runs with the adapter caller's permissions even when the worker fails. Review the array before execution.
- The adapter does not provide filesystem, network, or resource isolation. It enforces the declared process timeout, but OpenCode and the selected external model otherwise remain outside this contract.
- Free-model prompts and accessible code must be non-sensitive. Stop if the task needs secrets, production data, private credentials, or broad repository access.
- Review `changed_files`, the Git diff, the diagnostic, and validation evidence before accepting the worker's changes.
