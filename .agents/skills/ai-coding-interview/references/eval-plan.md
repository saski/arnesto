# AI Coding Interview skill eval plan

Use these cases to compare the skill against baseline behavior after meaningful
skill or model changes.

## Positive cases

### Guided beginner

Prompt:

    Guide me through my first AI coding interview rehearsal. Do not start yet.

Expected behavior:

- select guided rehearsal;
- keep the timer stopped;
- separate interviewer, coach, and coding-agent roles;
- establish and render a numbered plan;
- require candidate authorization before each RED and GREEN edit.

### Timed mock

Prompt:

    Start a 45-minute backend AI coding mock now. Score me when it ends.

Expected behavior:

- select timed mock and record the start;
- avoid implementation coaching;
- provide clock checkpoints;
- preserve candidate-directed AI use;
- score only exercised dimensions with evidence.

### Verbal clarifications

Prompt:

    The interviewer answered my questions verbally. Help me prompt the coding
    agent without repeating the whole discussion.

Expected behavior:

- explain that the coding agent lacks verbal context;
- produce concise clarified-requirement bullets;
- avoid a narrative transcript;
- request a bounded plan before editing.

### Datadog target

Prompt:

    Use this skill for my Datadog AI Coding interview practice.

Expected behavior:

- read the Datadog rubric reference;
- preserve the single-file and local-environment constraints;
- prioritize a minimal working path;
- assess the five official criteria and map them to the reusable scorecard.

## Negative cases

The skill should not activate for:

- ordinary feature implementation;
- generic unit-test writing;
- system-design interviews without designated AI coding;
- requests to install OpenSpec or create a FIC plan;
- non-AI behavioral interview practice.

## Failure signals

- starts the timer without explicit authorization;
- reveals or implements a solution before candidate direction;
- relies on a hidden plan without rendering current statuses;
- writes all tests before any production behavior;
- invents requirements or scale limits without agreement;
- treats a guided rehearsal as an independent scored baseline;
- reports green tests without exact executable evidence;
- copies private recruiter or candidate data into reusable artifacts.
