---
name: personal-knowledge-routing
description: Route learning between Arnesto and the personal knowledge vault. Trigger proactively when how-to guidance, directives, explanations, or user-endorsed opinions appear, without waiting for a save request; also use for explicit capture, retrieval, or organization of personal knowledge. Obtain user validation before persisting and publishing detected learning.
---

# Personal Knowledge Routing

Use this skill to keep agent instructions small while preserving durable knowledge in the personal knowledge vault.

## Proactive Capture

The active AI detects capture candidates without an explicit user request.
Follow `~/.agents/rules/ai-feedback-learning-loop.md` to prepare exact content
and destination, inform the user, obtain validation, then persist and publish
to the owning repository. Detection alone is not approval. Explicit retrieval
requests do not require capture approval when no content changes.

## Repositories

- Arnesto checkout (current path): `/Users/saski/Code/arnesto`
- Personal vault: `/Users/saski/Code/personal-knowledge-vault`
- Vault content root: `/Users/saski/Code/personal-knowledge-vault/vault`

## First Files To Read

When working with the vault, start with:

1. `vault/AGENT_GUIDE.md`
2. `vault/README.md`
3. `vault/_meta/conventions.md`
4. `vault/_meta/promotion-policy.md` when moving content into more durable areas
5. `vault/_meta/source-manifest.md` when source material creates or changes durable content
6. The smallest relevant `vault/maps/*.md`, `vault/portfolio/*.md`, or `vault/notes/*.md` file

Do not read the whole vault unless the user explicitly asks for a full audit.

## Routing Table

| Information type | Destination |
|---|---|
| How-to guidance and directives for doing or solving something | Arnesto: the best fitting rule, skill, workflow, command, or existing policy; preserve the original scope |
| Agent configuration instructions and behavior, including cross-thread communication style | Arnesto `.agents/rules/`; cross-tool source, not client-specific configuration or memory |
| Repeatable agent workflow or protocol | Arnesto `.agents/skills/` |
| Tool setup, symlink policy, validation scripts | Arnesto |
| Stable personal facts, goals, responsibilities and preferences other than agent behavior | `personal-knowledge-vault/vault/portfolio/` |
| Durable decisions and decision-making patterns | `personal-knowledge-vault/vault/portfolio/decision-log.md` or `vault/notes/` |
| Explanations, concepts, interpretations, and opinions the user identifies with | `personal-knowledge-vault/vault/notes/`, with attribution and evidence; stable personal views may qualify for `portfolio/` promotion |
| Distilled reusable knowledge, source summaries, lessons, patterns | `personal-knowledge-vault/vault/notes/` |
| Navigation and topic indexes | `personal-knowledge-vault/vault/maps/` |
| Raw imports, unprocessed conversations, temporary captures | `personal-knowledge-vault/vault/inbox/` |
| Source provenance and promotion decisions | `personal-knowledge-vault/vault/_meta/source-manifest.md` and `vault/_meta/promotion-policy.md` |
| Vault schema, conventions, and maintenance policy | `personal-knowledge-vault/vault/_meta/` |

## Persistence Rules

- Distinguish procedural learning and agent instructions from explanatory or personal knowledge. Keep the former in shared Arnesto artifacts and the latter in the vault, not client-specific memory/configuration. Client adapters implement shared policy; credentials and mutable runtime state remain local.
- For proactive captures in either repository, present the exact content and destination for user validation before applying it. Once approved, run canonical checks, commit only approved changes, push to that repository's configured remote, and verify the remote commit. Approval includes publication unless the user requests local-only persistence; follow `agent-config-hygiene` for Arnesto. Do not treat standing publication authorization as approval of newly inferred content.
- An explicit request to add a vault entry includes publishing it. Run `make check`, commit the entry with its supporting changes, push to the vault's configured remote, and verify the remote commit. Honor explicit local-only requests.
- Keep source claims, facts, opinions, and inference distinct. Do not infer agreement from sharing material or from silence, and do not turn an AI-generated opinion into the user's belief. Ask about uncertain endorsement in the proposal.
- Prefer references over copying: if the vault already contains the knowledge, link or cite the file path instead of pasting it into rules.
- Update `portfolio/` only when information is stable, reusable, and source-backed.
- Apply the vault promotion policy before moving content from `inbox/` to `notes/` or from `notes/` to `portfolio/`.
- Update the source manifest when a source creates or changes durable notes, portfolio context, maps, or governance files.
- Put uncertain or still-evolving material in `notes/` or `inbox/` first.
- Keep raw conversations out of `portfolio/`.
- Preserve user-authored vault content unless the user explicitly asks for a rewrite.

## Context Discipline

- Use maps and frontmatter as indexes before reading full files.
- Read exact target files; avoid broad recursive reads.
- If a task needs personal context, load the relevant portfolio file rather than embedding that context in `AGENTS.md`.
- If a rule starts accumulating domain knowledge, move the knowledge to the vault and leave a short routing rule here.

## Link Discipline

- Before writing an Obsidian wikilink, verify that the target note exists.
- If the target is uncertain, write plain text or a relative Markdown path instead of creating a broken wikilink.
- After vault edits, run `make check` from `/Users/saski/Code/personal-knowledge-vault`.
- The vault pre-commit hook and scheduled GitHub workflow also run `make check`.

## Good Defaults

- When a how-to or operational directive appears: propose the smallest fitting Arnesto artifact, retaining its scope.
- When an explanation or a user-endorsed opinion appears: propose an attributed `notes/` update without waiting for a save request.
- For "remember this about me": propose a concise `portfolio/` update only if the source is stable.
- For "save this idea": propose a `notes/` page and a link from a relevant `maps/` page.
- For "capture this conversation": propose raw or summary material under `inbox/` or `notes/`, with portfolio promotion reviewed separately.
- For "make agents aware": keep operational instructions in Arnesto and supporting explanatory knowledge in the vault.
