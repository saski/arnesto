# Hermes, OmniRoute, and Telegram Operations

**Routing inventory verified locally:** 2026-08-21

This runbook records the intended secret-free routing policy. The reusable
overlay is versioned at
[`templates/hermes/dynamic-routing.overlay.yaml`](../templates/hermes/dynamic-routing.overlay.yaml).
Credentials, OAuth state, Telegram identifiers, sessions, and paired-channel
state remain local machine data and are never committed.

For the broader current and target tool topology, including the optional Orca
level-1 workspace, see
[Local Agentic Development Architecture](local-agentic-development-architecture.md).

## Operating model

```mermaid
flowchart LR
    user["User"] --> telegram["Telegram"]
    telegram --> gateway["Hermes gateway"]
    gateway --> profile["Default profile"]
    profile --> input{"Image attached?"}

    input -->|No| free["Main agent\noc/deepseek-v4-flash-free"]
    input -->|Yes| vision["Auxiliary vision\ngpt-5.6-sol, low effort"]
    vision --> summary["Text image analysis"]
    summary --> free

    free --> omniroute["OmniRoute\nlocalhost:20128/v1"]
    vision --> codex["Codex app-server\nChatGPT OAuth"]
```

The normal Telegram path is free. An image triggers exactly one frontier
preprocessing call; Hermes converts its visual analysis to text and sends that
text to the free main model. The Telegram toolset intentionally omits the
explicit `vision` tool because automatic image preprocessing already handles
the attachment and a second tool call would duplicate frontier consumption.

## Model lanes

| Lane | Use for | Provider and model | Selection |
|---|---|---|---|
| Default text | Ordinary chat and bounded, non-sensitive work | `omniroute` / `oc/deepseek-v4-flash-free` | Automatic after `/new` |
| Managed free coding | Non-sensitive coding with free-only fallback | `omniroute` / `combo/free-coding` | Explicit session override |
| Automatic image analysis | Inspecting an attached image before free reasoning | `openai-codex` / `gpt-5.6-sol`, low effort | Automatic only when an image is present |
| Full frontier | Planning, SDD, orchestration, sensitive or ambiguous work | `openai-codex` / `gpt-5.6-sol` | Explicit model switch or dedicated profile |

`/new` clears session overrides and starts the default free model. `/status`
continues to report the free main model after an image turn; auxiliary vision
is a preprocessing call, not the session model.

The obsolete `free-stack` and `free-deterministic` combos were inactive and
deleted from the local OmniRoute store on 2026-08-21. Do not recreate them.
`free-coding` is the only tracked ordered combo: Laguna, MiMo, HY3, then Big
Pickle. It was installed and passed direct text, tool-call, Codex, and Hermes
entry probes on 2026-08-21. Hermes exposes it as an explicit session override;
the direct DeepSeek pin remains the default. A catalog entry or HTTP 200
response is insufficient; the route must return usable content, a terminal
finish reason, and non-zero usage.

## Managed routing overlay

The repository overlay captures only portable policy. It is deliberately not
a complete Hermes configuration and MUST be merged into `~/.hermes/config.yaml`
rather than copied over it.

Before using it on another machine:

1. Replace `REPLACE_WITH_TELEGRAM_CHAT_ID` locally with the allowed Telegram
   chat identifier.
2. Keep `OMNIROUTE_API_KEY`, the Telegram bot token, and Codex OAuth state in
   the local profile environment or authentication stores.
3. Preserve unrelated local platform, memory, terminal, and sandbox settings.
4. Restart the launchd-supervised gateway and run the text and image smokes
   below.

The relevant machine-state boundary is:

| Purpose | Local path |
|---|---|
| Default ingress profile | `~/.hermes/config.yaml` and `~/.hermes/.env` |
| Optional named profiles | `~/.hermes/profiles/<profile>/config.yaml` and `.env` |
| Codex OAuth state | Hermes/Codex authentication stores |
| Mutable Hermes implementation | `~/.hermes/hermes-agent/` |

Never commit phone numbers, chat identifiers, bot tokens, provider keys,
session databases, paired-channel files, or OAuth credentials.

## Telegram procedure

Send every command as a separate Telegram message and wait for its reply. Do
not paste `/new` and `/model` into one message: Hermes treats text following
`/new` as a session title.

### Default free session

```text
/new
```

Expected result: `oc/deepseek-v4-flash-free` through the OmniRoute provider.
A minimal smoke prompt is:

```text
Reply with exactly: RUTA_FREE_OK
```

### Explicit full-frontier session

```text
/model gpt-5.6-sol --provider openai-codex
```

Use this for work that requires frontier planning or orchestration. The model
override is session-only unless `--global` is supplied; avoid `--global` when
the desired default remains free.

Return to the free main model with:

```text
/model oc/deepseek-v4-flash-free --provider custom
```

For the managed free-only coding route, use:

```text
/model combo/free-coding --provider custom
```

The equivalent one-shot CLI form is `hermes -m combo/free-coding --provider
omniroute -z '...'`. Model selection remains session-local unless `--global` is
explicitly requested.

## Multiplex secret scope

In a multiplexed gateway, `get_secret()` deliberately fails outside a profile
scope. A failure such as:

```text
get_secret('OMNIROUTE_API_KEY') called with no profile secret scope active
```

means provider resolution escaped the routed profile's runtime scope. The
current local Hermes implementation wraps the `/model` handler in the routed
profile scope. Re-check this behavior after any Hermes source upgrade until
the fix is supplied by an upstream release.

## Health and recovery

```mermaid
flowchart TD
    symptom["Observed symptom"] --> kind{"Failure type"}
    kind -->|Telegram disconnected| restart["Restart launchd gateway"]
    kind -->|Dashboard unavailable| dashboard["Start hermes dashboard --no-open"]
    kind -->|OmniRoute credential scope| scope["Verify profile route and scoped /model handler"]
    kind -->|Image analysis fails| oauth["Refresh Codex OAuth in the default profile"]
    kind -->|Empty or paid free route| pin["Return to verified explicit free pin"]

    restart --> launchd["launchctl print gui/UID/ai.hermes.gateway"]
    dashboard --> browser["Open 127.0.0.1:9119"]
    scope --> restart
    oauth --> smoke["Run one-image smoke"]
    pin --> textSmoke["Run RUTA_FREE_OK smoke"]
```

Useful local checks:

```bash
launchctl print "gui/$(id -u)/ai.hermes.gateway"
hermes gateway list
hermes dashboard --status
curl --fail http://127.0.0.1:20128/v1/models
```

`hermes gateway status` may lag behind launchd state; `launchctl print` is the
authoritative local process check. After a configuration change, restart the
supervised process rather than leaving a detached gateway with stale
environment values.

### Automatic reload after Desktop changes

Hermes Desktop and the Telegram gateway share the same `HERMES_HOME`, but they
are different processes. Desktop starts a local `hermes serve` backend; the
launchd job `ai.hermes.gateway` owns Telegram polling. An old interactive
`hermes` CLI session is a third process: it may keep a terminal and the state
database open, but it neither listens for Telegram nor competes with the
gateway. Exit it normally when it is no longer needed; closing it is not a
gateway recovery step.

Install the repository-owned launchd watcher once:

```bash
make install-hermes-gateway-config-watch
```

The watcher observes the global `~/.hermes/config.yaml`, `~/.hermes/.env`, and
`~/.hermes/auth.json`. A meaningful change made from Desktop to the global
model, provider, OAuth identity, or channel configuration automatically runs:

```bash
launchctl kickstart -k "gui/$(id -u)/ai.hermes.gateway"
```

Automatic OAuth token renewal does not restart the gateway. Tokens, expiry
timestamps, provider health, and request counters are deliberately excluded
from the semantic OAuth fingerprint so a background refresh cannot interrupt
an active Telegram task. Provider selection, provider membership, credential
identity, account identity, endpoint, authentication type, or priority changes
do trigger a restart. No credential value is logged or committed.

Check the watcher and its restart log with:

```bash
launchctl print "gui/$(id -u)/ai.hermes.gateway-config-watch"
tail -n 20 ~/.hermes/logs/gateway-config-watch.log
```

The watcher covers the global Desktop environment only. Named profiles under
`~/.hermes/profiles/` remain explicit operational units because observing an
entire mutable profile directory would also react to sessions, logs, and token
traffic and could create restart loops.

If Codex OAuth has expired, authenticate or run one direct Codex-backed Hermes
turn in the default profile before retrying image preprocessing. Keep this
recovery local; no OAuth artifact belongs in Git.

## Safe Hermes source updates

Use the repository-owned wrapper instead of invoking `hermes update` directly:

```bash
make hermes-update-check
make hermes-update-stage
make hermes-update-activate
```

`check` fetches the official remote and confirms that the local checkout is a
clean, linear ancestor of `origin/main`. `stage` creates a local, mode-600
archive of `HERMES_HOME` and records the exact source revision to update.
`activate` refuses if the source changed after staging, runs the native Hermes
updater with its own backup, and restarts the launchd gateway only after a
successful update.

The wrapper intentionally refuses dirty or divergent checkouts. In that case,
preserve the local source patches, build and smoke-test a parallel clean
checkout, and switch the gateway only after the migration is verified. Do not
force an in-place update across unrelated Git histories.

WhatsApp is optional and independent of Telegram. Keep
`WHATSAPP_ENABLED=false` in every active profile when it is unused, restart the
gateway, and confirm that no WhatsApp adapter is listed.

## Verification record

- The Telegram route selects the `default` profile.
- A text-only turn uses `oc/deepseek-v4-flash-free` through OmniRoute.
- A one-image smoke produced one auxiliary `gpt-5.6-sol` analysis followed by
  one free DeepSeek completion; the free main call used 2,477 input and 44
  output tokens.
- The launchd gateway was running and Telegram reconnected in polling mode.
- The committed regression test checks the free default, automatic low-effort
  frontier vision, default profile route, absence of the duplicate `vision`
  tool, and absence of common credential or personal-identifier patterns.
- OpenCode free workers remain a separate, bounded adapter path; this Hermes
  overlay does not make arbitrary OpenCode models trusted workers.
