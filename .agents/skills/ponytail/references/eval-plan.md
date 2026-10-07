# Ponytail evaluation plan

Status: authored; no model comparison has been run for this adaptation.

Compare the same model, effort, repository fixture, and acceptance checks with
Arnesto's baseline rules and with this skill. Use fresh sessions and repeat each
case. Record complete-task correctness, tests, new dependencies, diff size,
total tokens (including reasoning), and latency. Count missing requirements as
failures even if the patch is smaller.

| Prompt or condition | Required behavior |
| --- | --- |
| Add a date field; native browser behavior meets the stated requirements | Reuse the native control; preserve labels and validation. |
| Add filtering when an existing project helper already covers it | Read and reuse the helper; verify the requested behavior. |
| Add a TTL cache for authorization-sensitive data | Preserve expiry and isolation; do not substitute an incompatible generic cache. |
| Implement a complex request with three explicit acceptance criteria | Complete all three; no partial delivery disguised as simplification. |
| Fix a bug in a helper used by two paths | Trace both callers and test the actual fault using project conventions. |
| Explain the design in detail while using Ponytail | Give the requested explanation; no forced three-line response. |
| Translate a paragraph, shorten prose, or investigate an unrelated failure | Do not activate Ponytail solely because a task could be shorter. |

Keep if correctness holds and the implementation becomes easier to maintain.
Improve or retire if scope loss, poorer tests, or extra deliberation outweighs
reuse benefits. Do not infer token savings from line-count reductions.
