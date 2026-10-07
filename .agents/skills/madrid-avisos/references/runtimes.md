# Runtime requirements

The same SKILL.md and references work across agents. Browser sessions,
credentials, tool permissions, and installed copies belong to each runtime.
Reading the skill is distinct from being able to operate the website.
For persistent sign-in and manual authentication, follow
[sessions.md](sessions.md). Skill distribution never distributes account access.

| Runtime | Discovery | Execution requirement |
| --- | --- | --- |
| Codex | Installed skill directory or a skill-bearing plugin | Interactive browser tools exposed in that chat |
| OpenCode | Configured skill directories and native skill discovery | An available browser integration with form interaction |
| Hermes | Native skill directory or an explicitly configured external skill source | Its own working browser tools and authorized session |
| ChatGPT | A supported installed plugin or skill facility in the target client | Computer Use or a compatible integration available in that client |

Do not call one provider's tool names from another provider. Discover the actual
tools, read their instructions, and adapt the common workflow. An unavailable
provider is a reason for a useful draft/handoff, not a successful submission.
Do not install browser tooling, edit trust settings, or transfer sessions merely
because this skill was invoked.

## Arnesto installation

The canonical source is `.agents/skills/madrid-avisos/` in Arnesto. Existing
Codex, OpenCode, Claude, Cursor, and Gemini skill links can expose that source.
Verify the active client's discovery; an old chat may retain a stale catalog.
For Hermes, use its native skill directory when the shared source is not already
configured. Treat any copied package as a distribution snapshot: refresh it from
the canonical source and compare bytes after a skill update.

Invoke in natural language: **Usa madrid-avisos para preparar un aviso por una
farola apagada en [dirección].** Where supported, use `$madrid-avisos` or the
native skill picker. A draft request does not authorize sending it.

## ChatGPT packaging

Official OpenAI documentation supports a skill-only plugin containing root
`plugin.json` and `skills/madrid-avisos/SKILL.md`, with the linked references.
Installing a local Codex skill does not establish installation in every ChatGPT
client. Verify the actual client and account before claiming availability.

The documented local route uses a marketplace and installation in the desktop
Plugins Directory, followed by a fresh chat. Local source availability can vary
by surface; ChatGPT web/mobile availability is not established by desktop setup.
Workspace or public publication is a separate action requiring authorization.

Sources checked 2026-10-02:

- [Build skills](https://developers.openai.com/plugins/build/skills)
- [Package a plugin and local marketplace](https://developers.openai.com/plugins/build/plugins)
- [Record & Replay and Computer Use requirements](https://learn.chatgpt.com/docs/extend/record-and-replay)
