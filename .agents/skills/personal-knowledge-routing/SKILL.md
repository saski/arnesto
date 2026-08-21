---
name: personal-knowledge-routing
description: Route durable personal context and reusable knowledge between Arnesto and the personal knowledge vault. Use when the user asks to remember, persist, capture, retrieve, or organize personal knowledge; when deciding whether information belongs in rules, skills, portfolio, notes, maps, or inbox; or when using personal-knowledge-vault as a low-context reference layer.
---

# Personal Knowledge Routing

Use this skill to keep agent instructions small while preserving durable knowledge in the personal knowledge vault.

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
| Agent behavior that must apply across tools | Arnesto `.agents/rules/` |
| Repeatable agent workflow or protocol | Arnesto `.agents/skills/` |
| Tool setup, symlink policy, validation scripts | Arnesto |
| Stable personal facts, preferences, goals, responsibilities, working agreements | `personal-knowledge-vault/vault/portfolio/` |
| Durable decisions and decision-making patterns | `personal-knowledge-vault/vault/portfolio/decision-log.md` or `vault/notes/` |
| Distilled reusable knowledge, source summaries, lessons, patterns | `personal-knowledge-vault/vault/notes/` |
| Navigation and topic indexes | `personal-knowledge-vault/vault/maps/` |
| Raw imports, unprocessed conversations, temporary captures | `personal-knowledge-vault/vault/inbox/` |
| Source provenance and promotion decisions | `personal-knowledge-vault/vault/_meta/source-manifest.md` and `vault/_meta/promotion-policy.md` |
| Vault schema, conventions, and maintenance policy | `personal-knowledge-vault/vault/_meta/` |

## Persistence Rules

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

- For "remember this about me": propose a concise `portfolio/` update, then apply it only if the source is stable.
- For "save this idea": create or update a `notes/` page and link it from a relevant `maps/` page.
- For "capture this conversation": put raw or summary material under `inbox/` or `notes/`, then propose any portfolio promotion separately.
- For "make agents aware": add the smallest possible rule or skill pointer in Arnesto, with details stored in the vault.
