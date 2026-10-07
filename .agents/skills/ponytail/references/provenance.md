# Ponytail provenance

- Upstream: https://github.com/DietrichGebert/ponytail
- Reviewed: 2026-09-27
- Commit: `e3ba2aa6f1e6f0bc4d69eb09c9f0d0a93af56156`
- Source: `skills/ponytail/SKILL.md`
- Source SHA-256: `1316a2f3f95741d2300b116fe0c2d81ce4a9568656ed0a62643f54aaf09957f2`
- License: MIT; upstream notice is retained in `../LICENSE`.
- Ownership: Arnesto-maintained adaptation, not an intact upstream import.

The upstream reuse ladder is useful before implementation and dependency
selection. Arnesto already has general simplicity rules and refactoring skills,
so this skill is scoped to explicit Ponytail or minimal-implementation requests.

Local changes remove automatic activation on every coding task, unconditional
persistence, intensity modes, mandatory one-liners, branded comments, and
instructions that could underdeliver a complex request. Repository test
conventions and requested explanations remain authoritative. No upstream plugin,
lifecycle hook, install script, or MCP server is installed with this skill.

Upstream benchmark percentages describe its own tasks and models. The README
also reports that a reasoning model can spend more tokens with the ladder.
Neither upstream results nor the local adaptation establish savings in Arnesto.

When updating, review the pinned source against the proposed upstream revision,
preserve these scope decisions, update `skills-lock.json`, and run the library
and canonical checks. Do not overwrite this directory with an upstream sync.
