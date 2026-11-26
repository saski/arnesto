---
name: align
description: Presents a proposed approach in progressive confirmable chunks with recommended decisions and alternatives. Use when aligning on a design, plan, or technical approach before implementation.
argument-hint: [file|folder]
---

STARTER_CHARACTER = 🎯

## Core Principle

Propose, don't ask. Think first, then present your thinking for confirmation. The user's job is to course-correct, not to generate the approach.

## Flow

```
Read input → Think internally → Present chunk → Confirm → Next chunk
                                                   ↑            |
                                                   └── Redirect ┘
```

- Read the input context and confirm your understanding of the goal and why it matters before proposing the approach.
- Think through the full approach internally
- Present a rough outline of chunks coming — gives the user the full scope before drilling in
- Present each chunk progressively, starting from the highest level of abstraction
- Confirm each chunk using the client’s supported user input mechanism before moving to the next
- Drill down only after the big picture is confirmed

## Presenting Chunks

Each chunk is a coherent topic. Present it with:
- ⭐ Recommended approach with brief rationale
- ❌ Alternatives considered with why they were rejected
- ASCII diagram when showing structure or flow

### Grouping Decisions

Group related small decisions into a single chunk with ⭐/❌ for each choice within it.

Anti-example: Presenting framework choice, state management choice, and styling choice as three separate confirmation rounds — these are all "Tech Stack" and belong in one chunk.

Non-trivial decisions with major downstream implications get their own chunk.

### Chunk Size

Scannable in one read. If it needs scrolling, split it.

## Handling Redirects

When the user rejects a chunk, downstream design may change. Don't present pre-computed chunks that depend on the rejected one. Re-present the corrected portion in full so the user can confirm it in context. Then identify which later decisions the correction affects and rethink them before continuing.

## Anti-patterns

- Asking open-ended questions instead of proposing (the user invoked this to see YOUR thinking)
- Presenting the entire design at once (defeats progressive confirmation)
- Moving to the next chunk without explicit confirmation
- Presenting trivial decisions one at a time
- Skipping ASCII diagrams for structural or flow topics
- Continuing with pre-planned chunks after a redirect without reconsidering
