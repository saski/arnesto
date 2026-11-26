---
name: strategic-compact
description: Suggests manual context compaction at logical intervals to preserve context through task phases rather than arbitrary auto-compaction.
origin: ECC
license: MIT
---

# Strategic Compact Skill

Choose a useful phase boundary for manual compaction. Use `/compact` in clients that support it.

## When to Activate

- Running long sessions that approach the active model’s context limit
- Working on multi-phase tasks (research → plan → implement → test)
- Switching between unrelated tasks within the same session
- After completing a major milestone and starting new work
- When responses slow down or become less coherent (context pressure)

## Why Strategic Compaction?

Auto-compaction triggers at arbitrary points:
- Often mid-task, losing important context
- No awareness of logical task boundaries
- Can interrupt complex multi-step operations

Strategic compaction at logical boundaries:
- **After exploration, before execution** — Compact research context, keep implementation plan
- **After completing a milestone** — Fresh start for next phase
- **Before major context shifts** — Clear exploration context before different task

## How It Works

When the client reports context usage, judge pressure relative to the active model’s context window. A tool-call count can prompt a review, but it does not measure remaining context.

The optional [local helper](suggest-compact.js) counts calls when configured as a Claude Code PreToolUse hook for Edit and Write. It:

1. **Tracks tool calls** — Counts tool invocations in session
2. **Threshold detection** — Suggests at configurable threshold (default: 50 calls)
3. **Periodic reminders** — Reminds every 25 calls after threshold

## Optional Claude Code Hook

Manual use requires no hook. Configure the helper through the user’s existing agent configuration workflow if they request an automatic reminder.

## Configuration

Environment variables:
- `COMPACT_THRESHOLD` — Tool calls before first suggestion (default: 50)

## Compaction Decision Guide

Use this table to decide when to compact:

| Phase Transition | Compact? | Why |
|-----------------|----------|-----|
| Research → Planning | Yes | Research context is bulky; plan is the distilled output |
| Planning → Implementation | Yes | The implementation plan is saved in a task file |
| Implementation → Testing | Maybe | Keep if tests reference recent code; compact if switching focus |
| Debugging → Next feature | Yes | Debug traces pollute context for unrelated work |
| Mid-implementation | No | Losing variable names, file paths, and partial state is costly |
| After a failed approach | Yes | Clear the dead-end reasoning before trying a new approach |

## What Survives Compaction

Persistence varies by client and session. Save a checkpoint to an authorized task file before compaction, with the goal, decisions, pending work, and verification evidence.

| Persists | Lost |
|----------|------|
| Project instructions loaded from disk | Intermediate reasoning and analysis |
| Task list, when the client exposes and preserves one | File contents you previously read |
| Authorized notes written to disk | Multi-step conversation context |
| Git state (commits, branches) | Tool call history and counts |
| Files on disk | Nuanced user preferences stated verbally |

## Best Practices

1. **Compact after planning** — Save the agreed plan before compacting
2. **Compact after debugging** — Clear error-resolution context before continuing
3. **Don't compact mid-implementation** — Preserve context for related changes
4. **Read the suggestion** — Use reminders as input to a phase-boundary decision
5. **Write before compacting** — Save important context to files or memory before compacting
6. **Use `/compact` with a summary** — Add a custom message: `/compact Focus on implementing auth middleware next`

## Related

- [The Longform Guide](https://x.com/affaanmustafa/status/2014040193557471352) — Token optimization section
