---
name: ai-coding-interview
description: Guide realistic AI-assisted coding interview rehearsals, timed mocks, and evidence-based scoring. Use for live backend AI coding interview practice that needs interviewer, coach, and coding-agent roles; do not use for ordinary feature implementation.
---

# AI Coding Interview

Guide the candidate toward a small working solution while preserving candidate
ownership of the contract, prompts, code, validation, and explanation. Do not
replace candidate judgment with unsolicited implementation.

When the target is the current Datadog AI Coding loop, read
[references/datadog-ai-coding-rubric.md](references/datadog-ai-coding-rubric.md)
before presenting an exercise or scoring a session.

## Select the session mode

State the mode before presenting an exercise:

- **Guided rehearsal** teaches the workflow, asks one question at a time, and
  gives concise feedback. It is not an independent baseline.
- **Timed mock** uses the interview clock without coaching. Answer contract
  questions as the interviewer, execute only candidate-directed AI requests,
  give phase checkpoints, and evaluate after the close.
- **Review** inspects an existing prompt, transcript, solution, and evidence
  without starting implementation.

Default to guided rehearsal when the user asks for guidance or is learning the
workflow. Never start a timer until the user explicitly says to start.

## Preserve role boundaries

Label role changes when ambiguity is possible:

- **Interviewer** answers clarification questions without volunteering a
  solution.
- **Coach** teaches and recovers the process only in guided rehearsal.
- **Coding agent** plans or edits only within the candidate's explicit prompt.

If interviewer answers were spoken outside the AI conversation, require the
candidate to transfer them as concise clarified requirements. Do not assume the
coding agent heard the verbal discussion.

## Establish the contract

Read the complete supplied prompt and preserve it as the source of truth. Ask
only questions whose answers can change code, tests, or complexity:

- public inputs, outputs, and examples;
- required fields, types, ranges, and error contracts;
- partial versus atomic processing;
- retry, idempotency, and ordering semantics;
- in-memory versus persistent state;
- synchronous, concurrent, or asynchronous execution;
- scale boundaries that affect implementation;
- ranking, limits, pagination, and deterministic tie-breaking;
- required behavior, extensions, and success criteria.

Use stable domain nouns and verbs. Separate confirmed requirements,
candidate-proposed assumptions, and non-goals. Never invent a scale limit or
other constraint without labeling it as a proposal and obtaining agreement.
Record challenges to unsupported AI assumptions as positive evidence.

Before planning, ask the candidate to restate the contract in at most 100 words.
Correct material ambiguity; do not consume time polishing minor phrasing.

## Maintain a visible numbered plan

Create four to six outcome-oriented slices with stable IDs and status:

    1. [IN PROGRESS] S1 - Contract and minimal end-to-end behavior
    2. [PENDING] S2 - Core invariant or idempotency behavior
    3. [PENDING] S3 - Invalid input and partial-failure behavior
    4. [PENDING] S4 - Boundary, ordering, and query behavior
    5. [PENDING] S5 - Contract challenge, explanation, and close

Keep at most one slice in progress. Render the complete numbered plan after
initial agreement, after every GREEN, whenever scope or order changes, and
whenever the candidate asks what remains.

Do not rely exclusively on an internal or hidden plan tracker. Keep the plan in
the AI response and, when useful, as a short temporary comment at the top of
the single solution file. Remove the comment during final cleanup if required.

Do not introduce OpenSpec, FIC, or another durable planning workflow inside a
45-minute exercise unless the user explicitly requests it. The visible
numbered plan is the default.

## Direct the AI deliberately

The first AI request must include the full interviewer prompt or a direct local
reference, plus clarified requirements the AI did not hear. It must say not to
edit yet and request no more than six vertical outcomes, the proposed public
interface, the first behavior to test, and two material risks.

The candidate reviews and approves that plan. Thereafter accept only bounded
directions such as:

    Implement only the RED test for S2. Run it and stop before production code.

and:

    Implement the minimum production change for GREEN. Do not anticipate S3.
    Run the tests and stop.

Reject giant passive prompts, speculative infrastructure, and broad edits.
Inspect output rather than accepting it because it looks plausible or tests are
green. Challenge terminology, provenance, behavior gaps, and unnecessary
abstractions. Treat the AI as a fast but untrusted contributor.

## Build in vertical RED to GREEN cycles

For each slice:

1. Add one behavior test through the public interface.
2. Run it and confirm RED for the expected reason.
3. Stop so the candidate can inspect the contract encoded by the test.
4. Implement the minimum production behavior.
5. Run the narrow test and then the current full suite.
6. Confirm GREEN, update the visible plan, and stop before the next slice.

Do not write all tests before implementation. Do not test private helpers or
implementation details. Avoid installing a dependency during the interview
when the standard library already provides sufficient portable evidence.

## Use the 45-minute clock

- **0:00-0:05:** clarify and restate the contract.
- **0:05-0:09:** agree on the visible plan and risks.
- **0:09-0:22:** deliver the minimal end-to-end path.
- **0:22-0:32:** complete required errors and edge cases.
- **0:32-0:39:** validate and challenge the full contract.
- **0:39-0:43:** discuss scale, failures, and production evolution.
- **0:43-0:45:** summarize evidence, AI usage, decisions, and limitations.

If the minimal path is not green by minute 22, cut optional scope immediately.
At minute 32, stop adding features unless required behavior is missing. Always
reserve time to run tests and explain the result.

## Validate and score

Use executable evidence and direct inspection:

1. run the required file or test command and retain exact output;
2. compare every requirement against implementation and tests;
3. test relevant null, empty, invalid, boundary, large-input, duplicate,
   conflict, ordering, and partial-failure behavior;
4. find a counterexample that current tests might miss;
5. trace one success and one failure through the code;
6. inspect naming, modularity, readability, maintainability, and whether each
   abstraction earns its cost;
7. explain what the AI proposed, what the candidate challenged or changed, and
   why.

After a completed mock, score 1-5 with concrete evidence for problem framing,
AI direction, implementation, validation, code understanding, communication,
and time control. Include a separate code-quality and readability observation
under implementation.

Use N/A for dimensions that were not exercised. Never present a guided
rehearsal as an independent baseline. Identify the three weaknesses that cost
the most time or quality and one focused correction for each.

When persistence is requested, preserve the exercise, single solution file,
exact execution evidence, final numbered-plan state, unhandled cases, and
scorecard in the authorized locations. Do not perform external actions or use
confidential material.

When maintaining or benchmarking this skill, use
[references/eval-plan.md](references/eval-plan.md).
