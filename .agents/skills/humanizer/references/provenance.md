# Humanizer provenance

- Upstream: https://github.com/blader/humanizer
- Reviewed: 2026-10-20
- Commit: `8c307f367c91bd974002f10f2be2965d642c13df`
- Upstream version: `3.1.0`
- Source entry: `SKILL.md`
- Source entry SHA-256: `0612f1dfb1672b0ea9b97e139bf1f06cabe98d8b27424fe8ff01e1fb4cc99cad`
- License: MIT; the upstream notice is retained in `../LICENSE`.
- Ownership: Arnesto-maintained wrapper and communication profile; upstream
  instructions and bundled resources under `../upstream/` retain their original bytes.

Local instructions scope invocation to a requested task, add the ES/EN profile,
preserve facts and uncertainty, prohibit fabricated author reactions, and separate
recommendations from permission to rewrite. Humanizer returns one final version;
Avoid AI Writing keeps conservative cleanup as the default. No global mode, hook,
MCP service, external detector or client configuration is installed.

The communication profile is identical in both writing skill directories so each
skill remains self-contained when copied on its own. Update both copies together.
Spanish guidance is editorial; English detectors are not validated for Spanish.

For updates, compare the pinned source with the proposed revision, replace only
reviewed upstream resources and the license, preserve the local wrapper/profile,
then refresh source pins and file hashes in `skills-lock.json`. Run the library
and canonical repository checks. Upstream tests, mechanical checks and a few
synthetic cases do not establish comparative quality on the user's real writing.

The upstream entry is relocated from `SKILL.md` to `upstream/instructions.md`
so recursive skill discovery cannot select it instead of the local wrapper.
`upstreamPathMap` in the lock records that relocation. References to `SKILL.md`
inside the upstream material resolve to the relocated instructions. The pinned
Avoid AI Writing detector contains trailing spaces; a file-scoped Git whitespace
attribute preserves those source bytes without disabling checks on local prose.
