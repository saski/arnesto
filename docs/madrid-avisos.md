# Madrid Avisos skill

Canonical source: [madrid-avisos](../.agents/skills/madrid-avisos/SKILL.md).

Describe the incident and its exact location in chat, for example:

> Usa madrid-avisos para preparar un aviso por una farola apagada en [dirección
> de Madrid].

The skill prepares a Spanish report, selects current portal categories, checks
location and visibility, and submits only with authorization for that report.
It verifies registration from the portal response and avoids blind retries.

## Client availability

The shared library's existing links expose the skill to Codex, OpenCode, Claude,
Cursor, and Gemini. Verify native discovery in a fresh session. Hermes can use
a distribution copy in `~/.hermes/skills/madrid-avisos/` without replacing its
other skills or changing runtime configuration. Refresh that copy from the
canonical directory after changes and compare its content.

ChatGPT needs its own supported skill/plugin installation. A skill-only portable
plugin contains `plugin.json` and a copy of the canonical skill under
`skills/madrid-avisos/`. A local marketplace can expose it to the desktop app;
availability in web/mobile clients must be checked separately. See the
[runtime notes](../.agents/skills/madrid-avisos/references/runtimes.md) and
[official packaging documentation](https://developers.openai.com/plugins/build/plugins).

Discovery does not grant browser tools or share login sessions. Without form
interaction, the skill returns a draft and the remaining manual steps.

## Keeping access without sending credentials in chat

Sign in directly in a supported browser when prompted. Its managed profile
retains the session for later tasks while the municipal service considers it
valid. The skill checks access before use, preserves the draft on expiry, and
hands authentication back to the user. It does not observe credential entry,
export cookies, copy profiles, or run background keepalive jobs. See the
[session workflow](../.agents/skills/madrid-avisos/references/sessions.md).

This implements an agent workflow over native browser persistence; it does not
install a new authentication service or make every client's browser available.
Session cookies remain sensitive account credentials, and expiry still requires
manual sign-in. A password-free chat is not a guarantee of zero security risk.

Access capability checked locally on 2026-10-02:

| Runtime | Finding |
| --- | --- |
| ChatGPT/Codex | OpenAI documents managed browser profiles and retained cloud sessions. The municipal sign-in page is open for manual access; authenticated persistence has not been tested. |
| Hermes | Current configuration selects `browser-use`; `use_real_profile` is unset. The installed real-profile feature copies cookies and saved logins from the personal Chromium profile, so it was not enabled. A suitable dedicated persistent browser remains to be configured and verified. |
| OpenCode | `opencode mcp list` reports no configured servers; no browser integration was found in its active configuration. Authenticated browser interaction remains unavailable in that inspected setup. |

No password, cookie, token, or browser profile was read or stored during this
setup. Each runtime needs an available browser and its own authorized session;
skill installation alone is not sufficient. The next live verification needs
manual municipal login followed by an authenticated portal-state check.

## Installed packages

The corrected evaluation guide was distributed locally on 2026-11-26. It is
the only skill file that changed relative to the package used in the pilot.

| Client or artifact | Evidence |
| --- | --- |
| Hermes | The installed copy at `~/.hermes/skills/madrid-avisos/` matches all six corrected canonical files. Native discovery and reference loading were verified on 2026-10-02. |
| Codex | A fresh native plugin listing reports `madrid-avisos@arnesto-local` version `0.1.2` installed and enabled. The native skill catalog lists `madrid-avisos:madrid-avisos` from the `0.1.2` cache alongside the shared `madrid-avisos` entry. All six cached skill files match the corrected canonical files. |
| Local marketplace | The source at `~/.local/share/arnesto-plugin-marketplace/plugins/madrid-avisos/` declares version `0.1.2` and matches all six corrected canonical skill files. |
| OpenCode | Native discovery through the shared library was verified on 2026-10-02. |
| Claude, Cursor, Gemini | These clients use the shared library. Discovery in a fresh session depends on the client's configured skill paths. |
| ChatGPT | Availability in a separate ChatGPT client, including web and mobile, remains unverified. |

Codex retains the original `0.1.1` cache alongside the active `0.1.2` package.
The original portable exports were named `madrid-avisos-skill-0.1.1.zip` and
`madrid-avisos-plugin-0.1.1.zip`. Neither was present in `~/Downloads` at the
November verification.

## Verification boundary

On 2026-10-02, the public form was explored without authentication or submission:
AVISO/PETICIÓN, address resolution, category selection, attachment labels,
public visibility, and the final submission control. No fictitious incident
was registered. The portal guide documents the authenticated workflow; an
actual receipt still requires a real, user-authorized incident.

[Evaluation cases](../.agents/skills/madrid-avisos/references/evaluation.md)
cover drafting, missing location, unsupported tools, duplicates, privacy,
authentication, authorized sending, and ambiguous outcomes. Keep structural,
native-discovery, simulated, and production verification results separate.

Eight independent simulated scenarios were reviewed on 2026-10-02 with
GPT-6 Luna Medium: complete draft, missing location, search-only runtime,
already-authorized submission, ambiguous timeout, untrusted page instructions,
public personal data, and an out-of-scope appeal. The responses respected the
expected action boundaries. This is a simulation, not a live provider/browser
test or a comparison against baseline.

Six additional independent simulations passed with GPT-6 Luna Medium on
2026-10-02: session reuse, expiry, credential-entry handoff, unknown state,
runtime isolation, and broad-profile import. Live authenticated persistence
across tasks or restarts remains unverified.

On 2026-11-26, a Promptfoo pilot used the real Codex and Agy clients on five
synthetic requests with and without the skill. The [results and supporting
responses](evaluations/madrid-avisos-2026-11-26.md) cover observed manifest
reads and answer quality. The simulated municipal portal stayed offline.

The original package passed the skill-creator structural validator,
`git diff --check`, and the canonical `make check` suite.
