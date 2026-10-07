---
name: ponytail
description: >
  Apply Ponytail's reuse-first ladder when the user invokes /ponytail, asks for
  the simplest implementation, or wants to avoid over-engineering and new
  dependencies in a coding task. Preserve all requested behavior and required
  checks. Not a default for every coding task, a prose-compression mode, or a
  replacement for the repository's debugging, testing, or refactoring workflow.
license: MIT
---

# Ponytail

Choose the smallest maintainable implementation that meets the complete request.
This is Arnesto's scoped adaptation of DietrichGebert/ponytail; see
[provenance](references/provenance.md) for the pinned source and differences.

## Establish the behavior

Read the relevant code, callers, tests, and project conventions first. Identify
the acceptance criteria, boundaries, and failure cases. For a bug, trace its
root cause before choosing where to change it. Scope this skill to the current
task; extend it across turns only when the user asks for a persistent mode.

## Choose an implementation

Stop at the first option that satisfies the acceptance criteria:

1. Omit speculative work outside the request.
2. Reuse an existing helper, type, component, or established project pattern.
3. Use the language's standard library.
4. Use a native platform feature that meets the actual requirements.
5. Use an already installed dependency.
6. Write the smallest clear implementation needed.

Read the candidate's behavior before reusing it. A native date input, a database
constraint, or a standard cache is suitable only if its accessibility, data,
concurrency, lifetime, and product behavior match the request. A short snippet
that misses those requirements is not a solution. Add a dependency when its
benefit justifies its cost; explain that concrete tradeoff briefly.

## Preserve quality and scope

- Implement every requested acceptance criterion. Do not ship a reduced feature
  and ask the user to request the rest again.
- Prefer readable code over one-liners. Avoid speculative abstraction, clever
  compression, unrelated deletion, and invented future extension points.
- Keep validation at trust boundaries, security, accessibility, and error
  handling that protects data. Preserve documented compatibility constraints.
- Follow the repository's test tools and required validation. For behavior
  changes, use its existing TDD workflow when practical; do not impose a
  one-test limit or replace its suite with ad hoc assertions.
- Do not insert branded comments. Explain a non-obvious limitation only when
  the limitation matters to a maintainer.

## Report the result

State what changed, why the chosen implementation fits, and what was verified.
Name any remaining limitation. Match the user's requested explanation depth;
Ponytail does not activate Caveman or change the communication language.

Savings are a hypothesis to measure, not a guarantee. Use the comparison cases
in [the evaluation plan](references/eval-plan.md) before claiming improvement.
