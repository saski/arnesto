# Ponytail provenance

- Upstream: https://github.com/DietrichGebert/ponytail
- Reviewed: 2026-11-26
- Commit: `ebd8654c2c627f721eb8f9c0d1bd4090a29f9e10`
- Source: `skills/ponytail/SKILL.md`
- Source SHA-256: `9badd22a32e19cb884e46dfa8d3aae82bb81dfa5484105b8b4f0262df823a509`
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

The November review adopts the checks for affected callers, exports, configuration
and fixtures and for error handling when moving code. Task-scoped activation and
the repository's test policy still apply.

Upstream benchmark percentages describe its own tasks and models. The README
also reports that a reasoning model can spend more tokens with the ladder.
Neither upstream results nor the local adaptation establish savings in Arnesto.

When updating, review the pinned source against the proposed upstream revision,
preserve these scope decisions, update `skills-lock.json`, and run the library
and canonical checks. Do not overwrite this directory with an upstream sync.
