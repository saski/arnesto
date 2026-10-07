---
name: madrid-avisos
description: Prepare, submit with user authorization, and check municipal reports at avisos.madrid.es. Use for Avisos Madrid, reporting street defects, cleaning, lighting or urban equipment in Madrid city, and requests for new street elements. Not for other municipalities, emergencies, or general administrative appeals.
---

# Madrid Avisos

Turn the user's observations into an accurate municipal report. Speak Spanish
unless the user requests another language. The portal is
[Avisos Madrid](https://avisos.madrid.es/).

## Choose the available mode

- With an interactive browser, inspect the live portal and carry the authorized
  workflow through to its visible result. Use the host's supported browser tools.
- With only search, HTTP extraction, or no browser, prepare a paste-ready draft
  and a precise handoff. These capabilities cannot submit this JavaScript form.
- A verified integration may replace browser steps only if its documented
  capabilities cover the operation. Do not invent an API from frontend URLs.

Read [portal.md](references/portal.md) when interacting with the website. Read
[sessions.md](references/sessions.md) when reusing or establishing access, and
[runtimes.md](references/runtimes.md) only for installation or capability issues.
Loading this skill grants no additional permissions or browser access.

## Gather and draft

1. Extract the problem, exact incident location, and requested action from the
   conversation. Reuse information already given. Ask a focused question only
   for missing details that prevent an accurate report. A street number,
   intersection, or identifiable landmark may resolve a vague location; do not
   infer the incident location from the user's home, IP, or a photo's metadata.
2. Distinguish **AVISO** (a problem with an existing street element) from
   **PETICIÓN** (a requested new element). Check that the issue concerns Madrid
   city. For immediate danger, direct the user to emergency services. For a
   different municipality or a formal appeal, identify the appropriate channel
   instead of treating this portal as a substitute.
3. Write a concise Spanish description: observable problem, precise location,
   reported duration or impact if supplied, and the requested intervention.
   Do not invent dates, dimensions, causes, danger, ownership, or responsibility.
   Preserve uncertainty and distinguish an observation from an allegation.
4. Photos are optional. Use only attachments selected by the user for this report.
   Do not generate evidence or upload unrelated files. Identify unnecessary
   faces, identifying details, or private data before upload; offer omission or
   a redacted copy and preserve originals. Never place contact details,
   credentials, identity numbers, or banking details in the public description.

Draft format, with unresolved fields clearly marked:

```text
Tipo: AVISO / PETICIÓN
Ubicación: [incident location, with any needed landmark]
Categoría: [exact live option, or proposed category not yet verified]
Descripción: [ready-to-paste Spanish text]
Adjuntos: [selected files, or none]
Visibilidad: [actual portal setting, or not yet verified]
Estado: Borrador; no enviado
```

## Prepare the portal

1. Keep the draft in the conversation before authentication or navigation that
   could discard it. Check normal portal UI for a valid session and reuse the
   host-managed browser profile. If authentication is needed, follow
   [the session handoff](references/sessions.md): let the user sign in directly,
   with no agent observation during credential entry. Account creation, OTP,
   CAPTCHA, and legal acceptance also require user action under the host's rules.
   Never request passwords or codes in chat, export cookies, copy credentials
   between agents, create an account, or keep a session alive in the background.
2. Make a focused check for an existing report at the same location and category.
   Check relevant filters and detail before calling it a duplicate; an empty or
   failed map is not proof that none exists. If the same incident is already
   reported, show its reference and ask which action the user wants. Supporting,
   commenting on, or reiterating it requires authorization for that action.
3. Open **Nuevo reporte**, select the type, search the incident address, and
   verify the normalized address and map marker. Do not use device geolocation
   unless the user requests it. Select category labels from the current UI;
   category availability and additional required fields can change.
4. Fill the description and authorized attachments. Check attachment previews,
   actual visibility, and category-specific fields. A visually enabled submit
   button does not prove the form is complete. Read back the filled values.
5. Present the concrete report for review: location, category, text, attachments,
   visibility, and any contact data the selected category actually requires.
   Explain that public report content can be read by other citizens. Do not
   silently change visibility or promise confidentiality for a private report.

## Submit and verify

- Submission requires an explicit user instruction covering this report and
  its destination. Creating a skill, preparing a draft, or opening the portal
  is not permission to submit. Finish preparation before asking for any missing
  approval; do not repeat approval already given unless the content, data,
  destination, or a host-required confirmation changes.
- Click the final submission control once. Wait for the result and inspect it.
  Save the portal-issued ID, actual detail link if provided, current status,
  and timestamp. A click, spinner, HTTP success code, login redirect, or filled
  form is not evidence of registration.
- If the request times out or its result is ambiguous, report **Envío no
  confirmado**. Inspect **Mis reportes** or search the specific incident before
  any retry. Do not submit again while the earlier outcome remains uncertain.
- Respect the portal's daily limit and rate limits; do not work around them
  with alternate accounts or repeated submissions.
- Report **Registrado** only with portal confirmation. Quote the real reference
  or state that the confirmation did not expose one. Otherwise say **Borrador**,
  **Pendiente de acceso/autorización**, or **Envío no confirmado**, and identify
  the next concrete step. Include confirmation evidence when the host supports
  it, excluding account details.

For status requests, use the supplied ID or verified link and return the exact
current status with retrieval time. Do not equate **Fin de trámite** with a
fixed incident without reading the resolution. Monitoring, notifications, and
additional external actions require their own user request.
