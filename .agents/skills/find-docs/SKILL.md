---
name: find-docs
description: >-
  Retrieves up-to-date documentation, API references, and code examples for any
  developer technology. Use this skill whenever the user asks about a specific
  library, framework, SDK, CLI tool, or cloud service -- even for well-known ones
  like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. Your
  training data may not reflect recent API changes or version updates.

  Always use for: API syntax questions, configuration options, version migration
  issues, "how do I" questions mentioning a library name, debugging that involves
  library-specific behavior, setup instructions, and CLI tool usage.

  Use even when you think you know the answer -- do not rely on training data
  for API details, signatures, or configuration options as they are frequently
  outdated. Always verify against current docs. Prefer this over web search for
  library documentation and API details.
license: MIT
---

# Documentation Lookup

Use this entry point for explicit Context7 CLI use or as the CLI fallback defined in [documentation-lookup](../documentation-lookup/SKILL.md). Shared documentation routing prefers Context7 MCP when the current harness exposes it.

## Workflow

Use an available Context7 CLI. If no suitable installation is available, use the repository’s software-installation guidance before running package tooling. A global installation is unnecessary.

1. Resolve the official library name unless the user already supplied a Context7 library ID.

   ```bash
   npx ctx7@latest library "Next.js" "App Router authentication proxy configuration"
   ```

   Select the result that best matches the package and question. Use the official spelling first. Consider the description, source reputation, and documentation coverage when multiple IDs match.

2. Query the returned library ID. Pass a known project or requested version with `--tag` and use `--language` to rank examples for the relevant programming language.

   ```bash
   npx ctx7@latest docs /vercel/next.js "Configure the authentication proxy in the App Router" --tag 16.2.9
   npx ctx7@latest docs /websites/twilio "Send an SMS message" --language Ruby
   ```

   Use the requested version even when the library result omits a version list. Confirm the answer is supported by the returned documentation and disclose if the exact version could not be verified.

Use up to three Context7 resolution or documentation calls per question across transports. Keep each lookup focused on a distinct topic, combining concepts only when their interaction is the question. Use public documentation terms and omit credentials, personal data, and proprietary code from queries.

## Authentication and failures

The CLI supports unauthenticated use. Use an existing authorized credential when available. If Context7 returns a quota or authentication error, report the limitation and use authoritative public documentation where permitted. Follow the user’s login flow if they choose to authenticate. Cite the documentation used and distinguish any unverified detail.
