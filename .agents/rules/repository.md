---
trigger: always_on
---

<!-- last_updated: 2026-08-17 -->
<!-- version: 1.2 -->
# Arnesto

A portable, multi-tool agent harness for AI-assisted work.

Read and follow `.agents/rules/base.md`; this repository rulebook extends it with narrower instructions.

## Canonical Validation

- Use `make check` for the complete local validation suite.
- Use `make ci-check` for the CI-portable subset.

## Skill Library Changes

- Adding, removing, renaming, or moving any skill must update `.agents/docs/skill-factory-skills.md` and the relevant governance catalog: `.agents/skills/skill-foundry/agents/catalog-engineering.yaml`, `.agents/skills/skill-foundry/agents/catalog-product-management.yaml`, or `.agents/skills/skill-foundry/agents/catalog.yaml`.
- Update `.agents/docs/skill-domain-routing.md`, `README.md`, `PROJECT_STATUS.md`, and provenance locks when routing, user-facing inventory, status, or ownership changes.
- Run `./validate-skill-library.sh` for shared skill inventory changes and `./validate-cursor-skills.sh` for Cursor-only skill changes.
