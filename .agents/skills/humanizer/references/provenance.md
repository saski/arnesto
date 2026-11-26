# Humanizer provenance

- Upstream: https://github.com/blader/humanizer
- Reviewed: 2026-11-26
- Commit: `a32f24407364c74c812b43c15926d638bee1e072`
- Upstream version: `4.0.0`
- Source entry: `SKILL.md`
- Source entry SHA-256: `3013910ef5433dab12f0d2b86d9cf9e3421a253ef986518a68ef07aa29629bdc`
- License: MIT; the upstream notice is retained in `../LICENSE`.
- Ownership: Arnesto-maintained wrapper and communication profile; upstream
  instructions and bundled resources under `../upstream/` retain their original bytes.

Local instructions scope invocation to a requested task, add the ES/EN profile,
preserve facts and uncertainty, prohibit fabricated author reactions, and separate
recommendations from permission to rewrite. Arnesto limits factual additions to source material supplied by the author, including with upstream 4.0. Humanizer returns one final version;
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
