# On-demand writing skills

Arnesto provides two writing workflows with a shared Spanish/English
communication profile. They are available for requested prose work and do not
establish a persistent writing mode.

| Need | Choose | Editing scope |
|---|---|---|
| Identify AI-isms without changing the text | [avoid-ai-writing](../.agents/skills/avoid-ai-writing/SKILL.md), detect mode | Findings with specific wording and contextual judgment |
| Clean up a draft while keeping its structure | [avoid-ai-writing](../.agents/skills/avoid-ai-writing/SKILL.md) | Targeted wording changes; preserve argument and evidence |
| Rewrite a public or professional draft in its author's voice | [humanizer](../.agents/skills/humanizer/SKILL.md) | A broader rewrite within the requested scope, using supplied voice samples |

The [communication profile](../.agents/skills/avoid-ai-writing/references/communication-profile.md)
keeps prose direct, natural and warm, with connected sentences and useful
explanations. It preserves facts, commitments and uncertainty, and excludes
invented personal reactions, enthusiasm and experience. The same profile is
bundled in Humanizer so either skill can be copied independently.

## Request a workflow

Use the skill's name or a clear request for that kind of editing. Examples for
clients that support `$skill-name`:

- `Use $avoid-ai-writing to clean up this English draft, preserving its structure and uncertainty.`
- `Usa $avoid-ai-writing para señalar AI-isms en este correo. No lo reescribas todavía.`
- `Use $humanizer to rewrite this post in my voice. Use these two paragraphs as voice samples.`
- `Usa $humanizer para reescribir este texto en español natural. Conserva los hechos y mis matices.`

A request to rewrite pasted text does not authorize changing a file or sending
the result. A request to edit a named file applies only to the authorized prose.
Ordinary conversation, code review, factual corrections and literal translation
continue through their existing workflows.

## Recommendations and questions

During work on a public or professional draft, an agent may recommend Humanizer
when a broader author-voice rewrite would serve the task. A suggestion does not
activate the skill. The agent continues already-authorized work and waits for
acceptance before applying the suggested rewrite; it suggests at most once for
the same draft unless the task changes.

Ask one focused question when the answer would materially change the editing
scope, for example: "¿Prefieres conservar la estructura o que lo reescriba con tu
voz?" / "Should I preserve the structure or rewrite it in your voice?"
Use available context for routine audience and tone choices. An explicit request
or acceptance already authorizes the workflow; asking again is unnecessary.
Choose one workflow instead of automatically running both in sequence.

Both skills set `allow_implicit_invocation: false` in their Codex metadata and
carry the same boundary in their portable instructions. A compact suggestion rule
in the [baseline routing](../.agents/rules/base.md#4-skills-and-explicit-routing)
points to Humanizer for concrete voice problems. Detailed selection guidance lives
in the [communication routing catalog](../.agents/docs/skill-domain-routing.md#communication-facilitation-and-collaboration).
The profile and full workflows load only for an activated task. These are agent
instructions, not a background hook. Discovery and reload behavior depend on the client; a
client that has already cached its skill catalog may need a new session or reload.

## Language and verification limits

Avoid AI Writing's detector and vocabulary rules are calibrated for English.
The Spanish profile supplies contextual editorial guidance; English scores and
thresholds do not establish Spanish writing quality or human authorship.
Neither skill promises to pass an AI detector.

Avoid AI Writing includes its upstream Node.js tools under `upstream/`:
quote normalization, house-style checking, pattern analysis and mechanical
preservation checking. Run commands from that directory with absolute input
paths. They require Node.js 18 or later and no package installation. They are
checks for an activated editing workflow, not automatic hooks. A mechanical
preservation pass does not prove that the meaning is unchanged.

## Maintenance and evaluation

Each skill keeps unchanged upstream instructions as `upstream/instructions.md`,
an MIT notice, a local entry point and a provenance reference. The upstream entry
is renamed to keep recursive skill discovery on the local wrapper. References to
`SKILL.md` inside the upstream material refer to `upstream/instructions.md`.
Source commits, upstream versions and per-file hashes are
recorded in [skills-lock.json](../skills-lock.json). Review upstream updates
manually and preserve the local wrappers. Update both communication-profile
copies together and verify they remain identical.

Before promoting a revised profile, compare these synthetic cases with the
unmodified upstream behavior:

| Case | Observable acceptance criterion |
|---|---|
| Spanish cleanup with "podría", a subset and missing production evidence | Preserve possibility, the subset and the evidence gap; use editorial judgment without claiming Spanish detector validation |
| English rewrite with commitments and conditions | Retain every commitment and condition at the same strength; add no reaction or experience |
| "Flag only; do not rewrite" | Return findings and no replacement text or file edits |
| Already suitable author prose | Leave it unchanged when no justified edit is required |
| Public draft with a concrete voice problem and no requested rewrite | Recommend once when useful; do not activate the skill without acceptance |
| Explicitly accepted Humanizer rewrite | Proceed within scope without asking for the same permission again |
| Ordinary chat, code-only task or literal translation | Continue the original task without offering a writing workflow |

These cases check scope and fidelity. They do not establish comparative quality
or a benefit on real personal writing. Broader claims require representative
Spanish/English samples and review by their author.
