# Project-owned coordination artifacts

Recorded on 2026-10-05 from the Review Capacity experiment in Agent Systems Lab.
The canonical launcher remains
[`run-free-worker`](../../.agents/skills/free-agent-execution/scripts/run-free-worker),
with admission controlled by
[the routing manifest](../../.agents/free-agent-routing.json).

## Ownership and storage

| Material | Owner and location |
| --- | --- |
| Requirements, reusable task contracts, prompts and selected evidence | The project repository, beside its experiment documentation |
| Expanded host-specific contracts, raw streams and temporary client settings | The project's ignored `.lab/coordination/<run-id>/` |
| Reusable launchers, admission policies and execution procedures | Arnesto |
| Runtime credentials and client sessions | Their existing runtime or gateway; never a versioned recipe |

Keep reusable project recipes independent of the coordinating client. A task
coordinated from Codex does not make its instructions Codex-owned. Replace
machine paths with explicit placeholders in published templates; preserve raw
records locally and document normalization and source hashes.

The project recipes in
[Agent Systems Lab](https://github.com/saski/agent-systems-lab), under
`experiments/review-capacity/coordination/`, contain selected contracts and
receipts. They preserve failed and no-change
outcomes as well as returned changes, without treating a worker response as
independent validation.

## Provisional launcher reference

`reference/coordinate-worker.py.txt` is an archived text snapshot of the
provisional coordinator used during that experiment. Host paths are replaced
with placeholders. It is not installed, advertised as a supported command or
executed by setup. `reference/manifest.json` records its source and published
hashes. This preserves the implementation for review without adding another
active launcher.

The accompanying OpenCode configuration is an example, not a provider-plan
check. `reference/rejected-routing.example.json` records a candidate rejected
by the canonical validator, whose admitted provider prefixes are `oc` and
`opencode-zen`. It must not replace the live routing manifest. The archived
coordinator's optional five-step ceiling also differs from the canonical
three-step `bounded_code` policy; archiving it grants no policy exception.

Useful ideas for a separately validated adapter change are content fingerprints
for already-dirty files, file-specific edit permissions, final usage accounting
and rejecting responses that make no required change. The snapshot also has
limitations: it does not use canonical model admission or validation commands,
does not narrow reads to an exact file allowlist, and uses a runtime-specific
credential source. Input usage arrives after completed calls, so an oversized
first call can exceed the threshold before the coordinator notices it. File
scope checks do not replace filesystem isolation.

Do not adopt that snapshot merely because it produced edits. Any promotion to
the supported adapter requires contract validation, account-specific free-route
verification, behavior tests and the harness's canonical checks. Keep active
execution unchanged while reviewing these ideas.
