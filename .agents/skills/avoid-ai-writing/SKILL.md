---
name: avoid-ai-writing
description: >
  Use on demand when the user asks to remove AI-isms, audit AI-sounding prose,
  or clean up a named draft while preserving meaning and structure. Includes
  a Spanish/English communication profile. Recommend Humanizer for a broader
  author-voice rewrite; a recommendation does not activate either skill.
license: MIT
---

# Avoid AI Writing: Arnesto integration

Use this conservative editing workflow for the requested prose task. It does
not establish a persistent mode or apply automatically to ordinary chat, coding,
translation, or every document that happens to contain prose.

## Read and apply

1. Read [the communication profile](references/communication-profile.md).
2. Read [the pinned upstream skill](upstream/instructions.md) and its full
   [pattern catalog](upstream/references/patterns.md).
3. Apply the upstream editing contract within the user's requested scope.
   The local invocation, language and output boundaries here and in the profile
   take precedence over upstream defaults. User instructions remain authoritative.

The complete upstream package is preserved under `upstream/`. Resolve its
relative paths and run its commands from that directory, not from this wrapper
or the user's prose directory. Use absolute input paths when changing directories.
The optional mechanical tools require Node.js 18 or later and no dependencies.
See [provenance](references/provenance.md) for the source pin and ownership.

The upstream entry is stored as `upstream/instructions.md` so recursive skill
scanners discover only this local wrapper. References to `SKILL.md` within the
upstream material mean that file; its content is unchanged.

## Scope and output

- An explicit cleanup request activates this skill for that task; the user need
  not use its exact name. A detection-only request returns findings, without a
  rewrite. File changes require a request to edit the file.
- Default to targeted wording edits. Keep structure and argument unless the user
  authorizes a broader transformation; leave suitable passages unchanged.
- Follow the requested audience and voice, then the communication profile. Preserve
  necessary uncertainty even for a direct or blunt voice. Use no invented reactions.
- Return one final rewrite and concise verification of checks actually performed.
  If the user requests only the text, honor that output scope. Never claim that
  mechanical preservation checks prove semantic fidelity or human authorship.
- For Spanish, apply the profile's contextual editorial review. The upstream
  detector and vocabulary rules are calibrated for English. Report that limitation
  when relevant; do not present a Spanish detector score as validated evidence.
- Run mechanical tools only for the applicable upstream workflow. Keep scratch
  copies outside the target document and preserve protected spans as instructed.

## Choosing Humanizer

Recommend `humanizer` when a public or professional draft needs a broader rewrite
in its author's voice: for example, a post, bio, email, or narrative that still
sounds generic after ordinary editing. A concise suggestion can accompany the
authorized work; wait for acceptance before running the alternative workflow.

When conservative cleanup and a structural rewrite would lead to materially
different results and the request does not choose between them, ask one focused
question, for example: "¿Prefieres conservar la estructura o que lo reescriba con
tu voz?" / "Should I preserve the structure or rewrite it in your voice?"

When the user has already requested that broader rewrite, proceed without asking
again. Choose one workflow for the task; do not automatically chain both skills.
Keep ordinary chat, factual checks, literal translations and code-only work on
their existing paths. Suggest at most once for the same draft unless the task changes.
