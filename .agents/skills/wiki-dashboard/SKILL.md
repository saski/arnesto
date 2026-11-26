---
name: wiki-dashboard
description: >
  Create dynamic, queryable dashboard views of the Obsidian vault using Obsidian Bases — a native
  Obsidian feature that turns vault frontmatter into interactive tables, card galleries, and lists.
  Use this skill when the user says "create a dashboard", "vault dashboard", "show all X as a table",
  "dynamic view", "create a vault table", "build a content index", "show me all concepts/entities/projects",
  or wants a structured, auto-updating view of their wiki content.
  Requires an Obsidian release with the Bases core plugin enabled.
---

# Wiki Dashboard — Dynamic Vault Views

You are creating a `.base` file — an Obsidian Bases definition that turns vault frontmatter into a live, queryable view. Enable the Bases core plugin in Obsidian. [The first public desktop release with Bases was 1.9.10](https://obsidian.md/changelog/2025-08-18-desktop-v1.9.10/). Individual views can require a newer release.

## Before You Start

1. Read `~/.obsidian-wiki/config` (preferred) or `.env` (fallback) to get `OBSIDIAN_VAULT_PATH`
2. Read `$OBSIDIAN_VAULT_PATH/index.md` to understand what categories and pages exist
3. Ask the user what they want to view if not specified — what folder, tag, category, or date range?

## What Obsidian Bases Can Do

`.base` files define database-style views over vault notes. Each file declares:
- **Which notes to include** — filtered by folder, tag, frontmatter property, or combination
- **Which properties to show** — any frontmatter field becomes a column
- **What view type** — `table`, `cards`, or `list`
- **Sort and group** — by any property
- **Computed columns** — formulas using `file.*` helpers and arithmetic

Embed a `.base` into any note with `![[MyBase.base]]`.

## Step 1: Understand the Request

Determine:
- **What to show** — all pages in a category? Pages with a specific tag? A project's pages?
- **What columns matter** — title, tags, created, updated, summary, category, project?
- **View type** — table (default), cards (visual), or list (minimal)
- **Sort order** — by updated (default), created, title, or a custom property
- **Any filters** — date range, specific tags, folder scope

## Step 2: Generate the `.base` File

The `.base` format is YAML. Here are the patterns you'll use:

### Basic table

```yaml
filters:
  and:
    - file.inFolder("concepts")
views:
  - type: table
    name: Concepts
    order:
      - file.name
      - note.tags
      - note.summary
      - note.updated
```

### Cards filtered by folder and tag

```yaml
filters:
  and:
    - file.inFolder("projects")
    - file.hasTag("active")
views:
  - type: cards
    name: Active projects
    order:
      - file.name
      - note.summary
      - note.updated
```

### Computed column

```yaml
formulas:
  updated_relative: 'date(note.updated).relative()'
views:
  - type: table
    name: Concepts
    filters:
      and:
        - file.inFolder("concepts")
        - '!note.updated.isEmpty()'
    order:
      - file.name
      - note.updated
      - formula.updated_relative
```

Bases filters use expression strings inside an `and`, `or`, or `not` group. Configure each view under `views` and put displayed property identifiers in its `order`. Check [Obsidian Bases syntax](https://obsidian.md/help/bases/syntax) for the view options supported by the installed Obsidian version.

## Step 3: Write the File

Target path: `$OBSIDIAN_VAULT_PATH/_meta/<dashboard-name>.base`

Use a slug derived from the dashboard's purpose:
- "All concepts" → `_meta/concepts-index.base`
- "Recent ingests" → `_meta/recent-ingests.base`
- "Project overview" → `_meta/projects-overview.base`
- "Stale pages" → `_meta/stale-pages.base`

Create `_meta/` if it doesn't exist yet.

## Step 4: Embed (optional)

If the user wants the dashboard embedded in an existing note (e.g., `index.md` or a project overview), add:

```markdown
## <Dashboard Title>

![[_meta/<dashboard-name>.base]]
```

Ask the user before modifying an existing note.

## Step 5: Update Tracking

**`log.md`** — Append:
```
- [TIMESTAMP] WIKI_DASHBOARD name="<slug>" view=<type> filter="<description>"
```

No manifest or index update needed — `.base` files are live queries, not static content pages.

## Common Dashboard Recipes

Tell the user about these if they're not sure what to ask for:

| Dashboard | What it shows |
|---|---|
| **Content index** | All wiki pages grouped by category, sortable by updated date |
| **Entity tracker** | All entity pages (people, tools, orgs) with tags and sources |
| **Ingestion log** | Pages sorted by `created` date — see what was added recently |
| **Stale content** | Pages not updated in 30+ days — maintenance view |
| **Project overview** | All project pages with last-sync date |
| **Tag cloud** | Pages grouped by tag — see coverage across topics |
| **Research tracker** | All synthesis pages tagged `research` — shows research history |

## Quality Checklist

- [ ] `.base` YAML is valid and uses correct field names
- [ ] Filter matches the user's intent
- [ ] File written to `_meta/` with a descriptive slug
- [ ] `log.md` updated
- [ ] User told how to embed it (`![[_meta/<name>.base]]`) and the Bases requirements for the chosen view
