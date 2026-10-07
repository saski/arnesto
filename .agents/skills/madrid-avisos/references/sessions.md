# Reusing a signed-in browser

Use the browser's supported persistent profile. The user signs in directly;
the host retains the session when its documented persistence feature supports
it, and the agent operates the normal portal UI.
The skill contains instructions, not a credential vault or an authentication
service. Session cookies also confer account access: keeping the password out
of chat does not make a session harmless or guarantee indefinite access.

## Session workflow

1. Preserve any report draft before navigating. Use an already authorized browser
   surface for `https://avisos.madrid.es/`; do not import a personal profile to
   obtain access. Follow the live portal's sign-in link when needed instead of
   inventing an identity-provider URL.
2. Check rendered portal state without inspecting browser storage, HTTP headers,
   network traces, or authentication internals. Explicit signed-in account UI or
   authenticated **Mis reportes** content establishes access. A login form or
   **ENTRAR** establishes a need for authentication. A loading screen, failed
   request, or blank map leaves access unknown; do not treat it as proof that the
   session is valid or expired.
3. If sign-in is required, hand the browser to the user. Ask them to enter their
   credentials and any second factor directly into the website or the host's
   secure sign-in interface, never into chat. During this handoff, do not take
   screenshots, read the DOM or accessibility tree, inspect form values, or
   record the interaction. Wait for the user to confirm completion; elapsed time
   is not confirmation. Pause only the dependent portal work.
4. After confirmation, use non-secret tab metadata first to check that the user
   has left the identity-provider page. If it remains open, return control to
   the user without reading form values. Inspect the returned portal UI and
   resume the saved draft only after authenticated state is evident.
5. Retain the host-managed browser session using the host's documented handoff
   or persistence feature. Reuse it on the next requested task and check access
   again. Do not add refresh loops, scheduled visits, hidden login attempts, or
   token-renewal scripts. Respect expiry, logout, revocation, and rate limits.
6. Valid access does not authorize a report submission. Keep the report-specific
   authorization and receipt verification in the main skill.

Never read, print, export, or copy cookie databases, session tokens, password
manager contents, or browser storage. Do not put them into the skill, source
control, logs, screenshots, report drafts, plugin archives, or another agent's
configuration. Do not ask for a pasted cookie or `storageState` export as a
login shortcut. A browser connection itself grants account capabilities; limit
it to the intended task and keep existing host permission checks.

## Runtime boundaries

| Surface | Supported approach | Limit |
| --- | --- | --- |
| ChatGPT/Codex desktop browser | Sign in manually in the app's browser and reuse its managed profile | It is separate from regular Chrome and from the cloud browser; availability depends on the host tools |
| ChatGPT cloud browser | Use the secure sign-in form or user takeover; supported accounts can retain sessions for future tasks | Plan, rollout, and workspace support vary; secure-form credentials are not visible to the model |
| Hermes | Use an explicitly configured browser that supports persistent sessions | A skill installation and a selected cloud provider do not prove persistence or authenticated access |
| OpenCode | Use a configured browser integration with documented persistence | Skill discovery and `webfetch` alone cannot provide authenticated form interaction |

For ChatGPT cloud, the documented secure sign-in form sends credentials directly
to the browser, without exposing them to the model. Do not extend that guarantee
to ordinary desktop form fields or unrelated browser tools. On desktop, rely on
manual handoff and refrain from observing credential entry.

Hermes also documents a `browser.use_real_profile` option that copies cookies,
saved logins, and preferences from the user's active Chromium profile. It is not
required by this skill and must not be enabled as an incidental setup step.
It can expose unrelated accounts and duplicates authentication data on disk.
An integration with a dedicated profile containing only the intended municipal
session is a narrower future setup; verify support before configuring it.

Do not share a browser profile between simultaneous browser processes or assume
that one agent's session is available to another. Each configured browser may
require its own manual login. If no suitable persistent browser exists, keep the
draft and explain the missing integration; do not claim the skill supplied it.

## Verification and revocation

After the user signs in, verify normal authenticated portal UI. If a new task or
tab in the same managed profile remains authenticated, record that exact result.
Do not claim survival across browser restarts or portal expiry unless tested.
No live report is needed to test access. If access cannot be established, keep
the status **Pendiente de acceso** and preserve the draft.

To end access, the user can sign out of the municipal portal or clear the relevant
browser's site data. These actions affect that session; they do not establish
revocation of other devices or previously copied profiles. Follow the host's
documented controls and obtain authorization before deleting browser data.

Sources checked 2026-10-02:

- [OpenAI browser documentation](https://learn.chatgpt.com/docs/browser)
- [OpenAI local browser and existing sign-ins](https://learn.chatgpt.com/docs/enterprise/chatgpt-work-local-security#browser-sessions-and-existing-sign-ins)
- [OWASP session management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- Hermes installed browser guide: `website/docs/user-guide/features/browser.md`,
  section **Real profile browsing (use your own logins)**. Verify the installed
  version before using any configuration from that guide.
