---
name: promptfoo-evals
description: Design and run promptfoo evaluations for LLM behavior regressions or comparisons across prompts, agent rules, and models. Use for repeatable behavioral cases with explicit assertions, not ordinary unit tests or static configuration checks.
---

# Promptfoo Evaluations

Use promptfoo when the question concerns observable LLM behavior across a
repeatable set of inputs. A deterministic function or configuration invariant
usually belongs in the project's ordinary test suite instead.

## Define what is being evaluated

State the behavior, available evidence, and unacceptable outcome before writing
the case. Choose the evaluation boundary explicitly:

- **Prompt only:** send the candidate prompt and controlled context to a model.
- **Configured client:** invoke the real agent entry point with its instructions,
  tools, and runtime configuration. Attribute the result to that combination.

A client passing a case does not prove the harness caused the behavior. To test
that claim, compare with and without the relevant instructions while keeping
the cases, model, and runtime settings stable. Preserve a user's requested
provider; report unavailable models rather than silently replacing them.

## Build a useful case and grader

Start with a representative failure mode from actual use. Include enough
evidence to determine the expected behavior without putting the expected answer
in the evaluated prompt. Add ambiguity or pressure only when it models a real
risk. Expand coverage from observed gaps, not arbitrary case counts.

Prefer deterministic assertions for structure, exact facts, and prohibited
actions. Check the substantive claim as well as the format: valid JSON alone
is not success. Avoid exact prose matching when equivalent wording is valid.
For tool-use claims, inspect execution traces rather than the agent's self-report.

Exercise the grader with a known correct response and plausible incorrect
responses before trusting it. Use an LLM judge only for properties that need
semantic judgment; record its model and rubric and check its judgments against
examples reviewed by a person. Do not weaken assertions just to obtain green runs.

## Run and interpret

Use the project's existing installation, configuration, and execution targets.
For new integrations, pin the evaluator and commit the dependency lockfile.
Check current official documentation when adding unfamiliar provider or
assertion configuration; avoid copying guessed API syntax.

Keep live provider calls separate from fast deterministic checks. Respect the
task's data and spending boundaries. Record model, relevant runtime settings,
case revision, and cache use so comparisons can be interpreted. Use fresh
responses when claiming a new live verification. For variable behavior, report
repeated runs and their counts rather than treating one pass as reliability.

Report behavioral failures separately from provider errors, timeouts, missing
credentials, and empty responses. Unavailable providers are not passes, and
retries must not conceal earlier failures. Retain local reports for inspection;
do not commit credentials, private prompts, or runtime databases.

## Arnesto starting point

When working in the Arnesto checkout, inspect `evals/promptfoo/promptfooconfig.yaml`
and `docs/development-guide.md` before changing the evaluation. The existing
case checks honest reporting of unexecuted validation through the Codex client.

```sh
make install-promptfoo
make eval-promptfoo
```

These targets are Arnesto-specific; discover equivalent commands in other
repositories. The initial case and provider are examples, not a requirement
to use Codex, structured JSON, or a particular model for every evaluation.
