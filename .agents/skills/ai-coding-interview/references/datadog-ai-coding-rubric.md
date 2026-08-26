# Datadog AI Coding rubric

Use this reference only for the current Datadog AI Coding interview format.
It distills the official evaluation material and recruiter-confirmed guidance
recorded on 2026-08-25. Reverify later recruiter updates before changing the
skill.

## Confirmed format

- The calendar slot is 60 minutes with approximately 45 minutes of active work.
- The exercise is a real-world, functionally described backend problem.
- The candidate works in their own local environment while sharing the screen.
- The candidate uses their own AI coding tool.
- Documentation, search, package installation, and AI use are allowed.
- AI may also be used during productionization follow-up.
- Deliver a minimally working path first.
- Keep the final solution in one file for interviewer reference in CoderPad.
- The candidate must explain every material part of AI-generated code.

Follow current language restrictions from the supplied interview prompt. For
the confirmed 2026-08-25 format, C++, Rust, and Ruby were not supported.

## Evaluation criteria

### Problem Structuring and Approach

Break down the problem clearly, ask thoughtful implementation-changing
questions, outline a logical plan before editing, and move from a minimal
working solution toward a refined design.

Recruiter emphasis:

- spend the first two to five minutes clarifying;
- translate the functional request into a technical problem;
- frame domain models, repositories or data sources, responsibilities, and
  main flows only where the problem benefits from them.

### AI Collaboration and Judgment

Guide AI effectively, validate its output, catch mistakes, refine prompts, and
demonstrate clear understanding and ownership instead of accepting generated
code blindly.

Positive evidence includes challenging an invented requirement, rejecting
unnecessary architecture, constraining edits, inspecting a test before GREEN,
and changing or explaining generated code.

### Implementation Completeness

Deliver a functional solution within the time constraint. Cover relevant null,
empty, invalid, boundary, duplicate, large-input, and failure behavior. Reach a
working path before optional hardening.

### Code Quality and Readability

Use clear names, coherent modules or functions, and helpful abstractions.
Discuss extensibility and maintainability, but do not overbuild before the
required path works.

### Clear Communication

Communicate throughout the session: explain the approach, assumptions, AI
usage, decisions, tests, trade-offs, and improvements. Be able to walk through
the completed solution confidently.

## Follow-up depth

Use remaining time to implement or discuss productionization tied to concrete
requirements:

- testing and edge cases;
- scale and parallelization;
- errors and partial failure;
- logging, metrics, monitoring, and traces;
- security;
- failure modes and recovery;
- maintainability and clearer abstractions.

## Score mapping

| Score dimension | Primary evidence |
| --- | --- |
| problem framing | Problem Structuring and Approach |
| AI direction | AI Collaboration and Judgment |
| implementation | Completeness plus Code Quality and Readability |
| validation | Executable checks and requirement reconciliation |
| code understanding | Explanation and modification of generated code |
| communication | Clear Communication |
| time control | Minimal path, validation reserve, and closure within 45 minutes |
