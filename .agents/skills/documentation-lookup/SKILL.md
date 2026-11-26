---
name: documentation-lookup
description: Use current library and framework docs through Context7, preferring MCP tools with the CLI as a fallback. Activates for setup questions, API references, code examples, or named frameworks such as React, Next.js, or Prisma.
origin: ECC
license: MIT
---

# Documentation Lookup (Context7)

When a request depends on current library, framework, SDK, API, CLI, or cloud-service behavior, fetch current documentation through Context7 instead of relying on training data.

## When to Use

Activate when the user:

- Asks setup or configuration questions.
- Requests code that depends on a library.
- Needs API or reference information.
- Names a framework, SDK, CLI, or cloud service whose behavior may have changed.

Do not use Context7 for refactoring, business-logic debugging, code review, scripts written from scratch, or general programming concepts that do not depend on current external documentation.

## Workflow

### Step 1: Choose the Transport

Prefer the Context7 MCP tools when they are available. Use the CLI only when the current harness does not expose the MCP tools.

Use no more than three Context7 resolution or documentation calls per question, regardless of transport.

### Step 2: Resolve the Library ID

If the user did not provide a valid `/org/project` or `/org/project/version` ID:

- **MCP:** Call `resolve-library-id` with the official library name and the user's full question.
- **CLI fallback:** Run `npx ctx7@latest library <name> "<user's question>"`.

Do not send API keys, passwords, credentials, or other secrets in the query.

### Step 3: Select the Best Match

Choose one result using:

- Exact or closest official name match.
- Description relevance to the user's question.
- High or Medium source reputation when available.
- Higher benchmark score and useful snippet coverage.
- A version-specific ID when the user specified a version.

### Step 4: Fetch the Documentation

- **MCP:** Call `query-docs` with the selected library ID and the user's specific question.
- **CLI fallback:** Run `npx ctx7@latest docs <libraryId> "<user's question>"`.

If a CLI request fails with a quota error, tell the user and suggest `npx ctx7@latest login` or `CONTEXT7_API_KEY`. If the answer remains unclear after the call limit, state the uncertainty instead of guessing.

### Step 5: Use the Documentation

- Answer from the fetched documentation.
- Include minimal code examples when useful.
- Cite the library and version when it matters.
- Keep one transport for the question unless it is unavailable or fails.
