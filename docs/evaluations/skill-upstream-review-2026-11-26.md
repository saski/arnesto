# Upstream skill review, 26 November 2026

Of the 162 shared skills inspected, 124 had an identifiable third-party source.
Files changed in 52 of those packages. The other 72 already matched their
reviewed source or retain a documented local or historical version. The
remaining 38 shared packages had no independently verified third-party source.
A source commit in the table identifies the revision reviewed.

| Source and reviewed commit | Installed skills | Decision |
| --- | ---: | --- |
| [PMPrompt product management](https://github.com/pmprompt/claude-plugin-product-management/commit/9b9a4929de8ce23617719402b43fe3e75be23c02) | 25 | Adopted five frontmatter fixes. Nineteen packages already matched. Kept the intentional resource exclusion in `jobs-to-be-done`. |
| [Matt Pocock](https://github.com/mattpocock/skills/commit/6f7f7831a625f040a8e06a0e7954826b87ce775a) | 12 | Ported compatible changes to `diagnose`, `tdd`, `to-issues`, `to-prd` and `triage`. Kept seven existing workflows. The original names, tracker behavior and domain documentation conventions remain available. Each entry records its base and reviewed disposition. |
| [Humanizer](https://github.com/blader/humanizer/commit/a32f24407364c74c812b43c15926d638bee1e072) and [Avoid AI Writing](https://github.com/conorbronsdon/avoid-ai-writing/commit/8678c864383ade43f9866ffebb235b2e1e409fb0) | 2 | Updated the bundled sources to 4.0.0 and 3.39.1. Both wrappers retain their ES/EN profile and task-specific invocation. In Arnesto, Humanizer may add factual details only from material supplied by the author. |
| [Ponytail](https://github.com/DietrichGebert/ponytail/commit/ebd8654c2c627f721eb8f9c0d1bd4090a29f9e10) and [TypeSafe AI](https://github.com/typesafe-ai/skills/commit/302eea662c54bca6730873fe245bec1d69ebc23d) | 2 | Adopted Ponytail’s caller and error-handling checks while retaining task-scoped activation and project testing rules. TypeSafe is an exact copy of the upstream package, including its license. |
| [Obsidian Wiki](https://github.com/Ar9av/obsidian-wiki/commit/9fe94b2cdeb19cc09017326092afebd65d2a6803) | 21 | Ported compatible improvements into 16 skills and kept five unchanged. Local vault routing, capture approval and distinct `data-ingest` and `ingest-url` entry points remain available. The [review record](../../.agents/upstreams/obsidian-wiki/review.json) maps each local package to its reviewed upstream path and installed hash. |
| [Vercel Skills CLI](https://github.com/vercel-labs/skills/commit/57217cf86ba38148a57af9e90d14a4c049558330) | 1 | Updated `find-skills` verbatim. Its guide now documents the owner filter for discovery. |
| [Google Data Agent Kit 1.3.0](https://github.com/GoogleCloudPlatform/data-agent-kit-plugin/commit/716f429da2671acbb1faaa3944948ff9e86c5cd4) | 19 | Updated 12 and verified three exact matches. Retained four historical entry points: `developing-with-bigquery`, `discovering-gcp-data-assets`, `gcloud-auth-verification` and `skill-repair`. The last has an unverified original source. [Release and installed hashes](../../.agents/upstreams/google-data-cloud/source.json) distinguish adapted packages from exact upstream copies. |
| [ECC](https://github.com/affaan-m/ECC/commit/4adeee6732a12d1540f49a4d50a38ce8c97f9a53) | 3 | Adopted target-environment verification and window-relative compaction guidance. Preserved MCP-first documentation lookup and the existing local compaction helper. [Component lock](../../.agents/upstreams/ecc/components.lock.json) |
| [Skill-factory](https://github.com/lexler/skill-factory/commit/dafc979e9d25adba45d8e4c3da3c99219b49dbf1) | 28 | The published revision and the historical import have diverged. Ported changes to `align` and `nullables`. Fifteen packages already matched. Kept ten withdrawn packages and the original `writing-bash-scripts` workflow, whose only new upstream files were evaluation scenarios. [Import and comparison refs](../../.agents/upstreams/skill-factory/components.lock.json) |
| [Augmented Lean Delivery](https://github.com/eferro/augmented-lean-delivery/commit/e60dba69ecaf799e786a96fd27dccf2e5e216ee3) and [AugmentedCode Skills](https://github.com/eferro/augmentedcode-skills/commit/3e0c39814ae041c92a5c52e01c79994f42a309ea) | 7 | The seven sibling-linked skill directories matched their pinned Git trees and the published heads of the configured remotes. The [sibling lock](../../.agents/upstreams/local-saski-skills/components.lock.json) retains their historical source labels. |
| [Anthropic Skill Creator](https://github.com/anthropics/skills/tree/e4bb5d960d87126ff3b3a8af1a104b7db67560ba/skills/skill-creator) | 1 | Updated the copyright notice. All 18 installed files and their executable flags match the official package. The [source lock](../../.agents/upstreams/anthropic-skills/components.lock.json) also records the historical copies that matched the import. |
| [Obsidian CLI 1.2.3](https://github.com/kepano/obsidian-skills/commit/a53f5910cd68e7bad88ea52f2f4eb95b9aa40800) | 1 | Adopted CLI command and installation corrections. Preserved the existing triggers and excluded persistent console capture. [Source and installed hashes](../../.agents/upstreams/obsidian-skills/source.json) |
| [Planning with Files v3.29.1](https://github.com/OthmanAdi/planning-with-files/commit/02cdda06fd378ef3287f8ef0d35fec4395040605) | 1 | Updated four references and documented how to resume from the three planning files. The portable workflow uses those files directly, without automatic hooks or transcript access. [Source and installed hashes](../../.agents/upstreams/planning-with-files/source.json) |
| [Upstash Context7](https://github.com/upstash/context7/commit/42da8fc086c52382764b5e28d3424cb4586a3e29) | 1 | Updated `find-docs` for tagged releases and language-specific documentation. Preserved Arnesto’s MCP-first lookup order. [Provenance](../../.agents/upstreams/context7/provenance.md) |

The [root source lock](../../skills-lock.json) records package hashes for the
product-management, Matt Pocock, writing, Ponytail and TypeSafe groups. The
[Skills CLI lock](../../.agents/.skill-lock.json) records the upstream Git trees
of the original Obsidian imports and the current Vercel package.

Cursor has a separate IDE-managed inventory of 25 skills. All 14 tracked Canvas
SDK declarations matched the three copies bundled with the installed Cursor
3.25.9. Its local skills directory resolves to Arnesto and the sync manifest
contains no vendor content hashes. Freshness of those 25 prompts could not be
established against an independent vendor copy.

The [Madrid Avisos pilot](madrid-avisos-2026-11-26.md) evaluated the previous
Madrid package on five synthetic requests. The subsequent correction updates
its evaluation reference and governance dates. The pilot results still describe
the exact package identified in the archived trial data.
