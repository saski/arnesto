# Skill Domain Routing Guide

Use this guide when the user describes a domain or problem shape and you need a fast shortlist of likely skills. The source tables in [skill-factory-skills.md](skill-factory-skills.md) remain the canonical inventory.

Each section gives primary tags, when the domain is useful, and the skills to consider first. A skill may still be useful outside its primary domain when its trigger text matches the task.

## Testing, Quality, and Verification

Tags: `testing`, `tdd`, `coverage`, `approval-tests`, `mutation`, `test-doubles`, `verification`

Use when the work involves test design, test review, coverage gaps, safe implementation feedback loops, or checking whether an implementation really satisfies a plan.

Skills:

- `tdd` - Start here for test-first feature work or bug fixes.
- `test-doubles-first` - Use before choosing mocks; favors fakes, stubs, and spies.
- `nullables` - Use for tests around external I/O without heavy mocking.
- `approval-tests` - Use for complex output, fixtures, golden masters, and characterization tests.
- `bdd-with-approvals` - Use for executable Given/When/Then specs and domain-readable examples.
- `test-desiderata` - Use to review existing tests for quality and maintainability.
- `mutation-testing` - Use after tests exist to find weak assertions.
- `mutation-testing-js` - Use for Stryker-focused mutation testing in JavaScript and TypeScript.
- `mutation-testing-python` - Use for mutmut-focused mutation testing in Python.
- `xp-increase-coverage` - Use when the user asks to add high-value missing tests.
- `xp-plan-untested-code` - Use before writing tests for a risky untested area.
- `xp-code-review` - Use to review pending changes for tests, maintainability, and rule alignment.
- `lustra` - Use for technical due diligence and code-health audits across security, dependencies, reliability, maintainability, CI, docs, and structure.
- `pbt-pragmatic-adoption` - Use for first-wave property-based testing in suitable JS/Jest code.
- `verification-loop` - Use for broad session verification and completion checks.
- `fic-validate-plan` - Use to compare completed implementation against an approved plan.

## Implementation Planning, Delivery, and Safe Change

Tags: `delivery`, `planning`, `safe-change`, `vertical-slices`, `implementation`, `rollout`

Use when the user wants to break down work, plan an implementation, migrate safely, or execute a structured plan.

Skills:

- `small-safe-steps` - Use for risky implementation, migrations, refactors, and 1-3 hour increments.
- `micro-steps-coach` - Use after deciding what to build to turn work into 1-3 hour safe implementation steps.
- `story-splitting` - Use when requirements are too large or contain linguistic split signals.
- `hamburger-method` - Use to build vertical slices across product, UI, domain, and infrastructure layers.
- `shape-up` - Use for fixed-appetite product shaping with variable scope.
- `planning-with-files` - Use for multi-step projects that need persistent task, findings, and progress files.
- `openspec` - Use for OpenSpec, OPSX, spec-driven development, change proposals, delta specs, durable feature planning, and docs/thoughts-first OpenSpec initialization.
- `align` - Use to present and confirm a design, plan, or technical approach in progressive chunks before implementation.
- `fic-create-plan` - Use to turn research or a task description into a phased implementation plan.
- `fic-implement-plan` - Use to execute an approved plan phase by phase.
- `to-issues` - Use to turn a plan or PRD into independently grabbable issues.
- `triage` - Use for issue intake, bug or feature routing, and AFK-agent readiness.
- `project-status-maintenance` - Use to create or update `PROJECT_STATUS.md` with the canonical structure.

## Refactoring, Maintainability, and Technical Debt

Tags: `refactoring`, `maintainability`, `technical-debt`, `simple-design`, `legacy-code`

Use when behavior should stay stable while the code becomes simpler, safer, or easier to change.

Skills:

- `refactoring` - Use for general cleanup and structured refactoring.
- `refactoring-team` - Use for multi-agent iterative refactoring through progressive lenses (Claude Code; manual invocation).
- `xp-simple-design-refactor` - Use when the goal is simple design and ROI-ranked maintainability.
- `xp-mikado-method` - Use for large refactors that need dependency graphs and safe sequencing.
- `code-simplifier` - Use for local clarity and complexity reduction without behavior change.
- `xp-technical-debt` - Use to catalog, rank, and choose debt payoff work.
- `thin-wrappers` - Use to isolate external SDKs and infrastructure behind small interfaces.
- `improve-codebase-architecture` - Use to find deeper architecture improvements from existing code and docs.
- `zoom-out` - Use when more caller, module, or domain context is needed before changing code.

## Architecture, System Design, and Risk

Tags: `architecture`, `domain-modeling`, `complexity`, `risk`, `security`, `performance`

Use when the user is choosing a design, challenging a technical proposal, modeling a domain, or checking risk before implementation.

Skills:

- `hexagonal-architecture` - Use for ports, adapters, domain boundaries, and testable architecture.
- `event-modeling` - Use for command, event, state, automation, and vertical-slice domain modeling.
- `collaborative-design` - Use for designing workflows, tools, UIs, or systems with iterative scenarios.
- `complexity-review` - Use to challenge heavy architecture, scale, consistency, or resilience claims.
- `xp-predict-problems` - Use to forecast production failures and risky paths.
- `xp-security-analysis` - Use for OWASP, threat modeling, and pragmatic security review.
- `dockerfile-review` - Use for container build performance, image size, and security.
- `cwv-improvement-planner` - Use for Core Web Vitals, Lighthouse, and web performance work.
- `modern-cli-design` - Use for scalable command-line interface design.
- `accidental-data-loss-prevention` - Use before irreversible SQL, Cloud Storage, or GCP resource deletion commands.

## Debugging, Investigation, and Research

Tags: `debugging`, `diagnosis`, `research`, `root-cause`, `codebase-investigation`

Use when the answer depends on understanding current behavior before proposing or making changes.

Skills:

- `diagnose` - Use for disciplined debugging of failures, broken behavior, or regressions.
- `source-command-bug-fixing-agent` - Use for company-environment bug investigations that combine tickets, internal documentation, private repositories, ownership, and production evidence.
- `fic-research` - Use to investigate the existing codebase and capture findings without proposing changes.
- `find-docs` - Use for current library, framework, SDK, API, CLI tool, or cloud service documentation via the Context7 CLI.
- `documentation-lookup` - Canonical current-docs route; prefer Context7 MCP tools and fall back to the CLI when MCP is unavailable.
- `corporate-aws-cli` - Use for AWS CLI work in federated corporate accounts and account-region validation.
- `gcloud-auth-verification` - Use for Google Cloud CLI, BigQuery CLI, Dataform, or ADC authentication failures.
- `gcp-composer-troubleshooting` - Use for Cloud Composer or Airflow DAG and task RCA.
- `discovering-gcp-data-assets` - Use to find schemas, metadata, tables, datasets, and other GCP data assets.
- `thinking-in-bets` - Use when decisions must be made under uncertainty.

## Developer Tooling, Runtimes, and Automation

Tags: `tooling`, `bash`, `python`, `javascript`, `git`, `automation`, `agent-runtime`, `opencode`, `free-agent`

Use when the task is about command-line tooling, runtime setup, repo workflow, local automation, or agent development tools.

Skills:

- `free-agent-execution` - Use only when the user explicitly requests a bounded, non-sensitive free OpenCode worker run.
- `writing-bash-scripts` - Use when creating or editing shell scripts.
- `using-uv` - Use for Python projects, scripts, and dependency management with uv.
- `bun-toolkit` - Use for Bun-aware JS, TS, and JSX work.
- `git-worktrees` - Use for parallel development across git worktrees.
- `github-host-alias` - Use before GitHub SSH clone, fetch, pull, push, or remote commands.
- `code-notify` - Use to configure local task completion notifications.
- `creating-hooks` - Use for Claude Code lifecycle hooks and prompt/tool automation.
- `writing-statuslines` - Use for Claude Code status line scripts.
- `creating-process-files` - Use to create text-as-code process instructions.
- `setup-matt-pocock-skills` - Use to configure per-repo support for Matt Pocock skills.
- `google-adk-setup` - Use to bootstrap Google ADK projects and local dev UI.
- `google-adk-agent-patterns` - Use to build ADK agents, tools, and multi-agent flows.
- `managing-python-dependencies` - Use before installing Python packages, creating notebooks, or running Python code that depends on third-party libraries.

## Google Cloud Data, BigQuery, and ML

Tags: `gcp`, `bigquery`, `data-pipelines`, `dataflow`, `dataform`, `dbt`, `spark`, `notebooks`, `ml`

Use when the work involves Google Cloud data assets, BigQuery, data pipeline development, Dataproc/Spark, Dataflow, Cloud Composer, notebooks, or ML/data-analysis workflows.

Skills:

- `gcp-data-pipelines` - Start here for ambiguous GCP data-pipeline build, update, orchestration, or tool-selection requests.
- `developing-with-bigquery` - Use for BigQuery optimization, BigFrames, BigQuery ML, AI functions, and vector search.
- `dataform-bigquery` - Use for Dataform SQLX projects, actions, source declarations, workflow settings, and BigQuery ELT.
- `dbt-bigquery` - Use for dbt projects, BigQuery models, SQL optimization, and dbt troubleshooting.
- `data-autocleaning` - Use for profiling, cleaning, moving, copying, or transforming BigQuery and GCS data sources.
- `bigquery-data-transfer-service` - Use to discover or inspect BigQuery DTS transfer configurations and ingestion metadata.
- `gcp-dataflow` - Use for Apache Beam pipelines and Google Cloud Dataflow Flex Templates.
- `gcp-spark` - Use for Spark ETL, Spark ML, Dataproc clusters, and Dataproc Serverless work.
- `gcp-pipeline-orchestration` - Use for Cloud Composer orchestration pipeline YAML and deployment wiring.
- `gcp-pipeline-resource-provisioning` - Use for deployment.yaml-based provisioning of supported GCP data pipeline resources.
- `building-data-apps` - Use for dashboards, interactive reports, React/Vite data apps, Streamlit apps, and chat-with-data interfaces over GCP data.
- `notebook-guidance` - Use for Jupyter notebook analysis, visualization, BigQuery SQL magics, and notebook validation.
- `ml-best-practices` - Use for ML and data-analysis tasks such as clustering, classification, regression, forecasting, and statistical testing.
- `discovering-gcp-data-assets` - Use to locate and inspect GCP data assets before querying or pipeline generation.
- `gcloud-auth-verification` - Use when GCP auth, bq, Dataform, or ADC credentials fail.
- `gcp-composer-troubleshooting` - Use for failed Cloud Composer/Airflow DAGs and RCA reports.

## AI Agent Skills and Governance

Tags: `ai`, `agent-skills`, `skill-governance`, `routing`, `benchmarking`, `adoption`

Use when the work is about creating, improving, selecting, evaluating, or governing agent skills and AI-assisted workflows.

Skills:

- `agent-config-hygiene` - Use to audit or slim AGENTS.md hierarchies, always-loaded rules, client wrappers, skill routing, and agent runtime boundaries.
- `skill-foundry` - Use to organize, evaluate, benchmark, and improve a skill library.
- `skill-creator` - Use to create, edit, benchmark, and tune Agent Skills and evals.
- `skill-repair` - Use to fix failed skill installations and update installer manifests.
- `write-a-skill` - Use to create portable agent skills with proper structure.
- `find-skills` - Use to discover installable external skills.
- `ai-patterns` - Use for augmented coding patterns, anti-patterns, and steering techniques.
- `ai-coding-interview` - Use for guided or timed AI-assisted backend coding interview practice with a visible numbered plan, bounded vertical slices, and rubric-based scoring.
- `launching-agent-teams` - Use to create agent teams, spawn teammates, or coordinate parallel agents (Claude Code).
- `lean-ai-adoption-coach` - Use for pragmatic AI adoption decisions and guardrails.

## Product Strategy, Discovery, and Prioritization

Tags: `product`, `strategy`, `discovery`, `roadmap`, `customer`, `prioritization`

Use when the user is deciding what to build, why it matters, who it is for, or how to prioritize.

Skills:

- `jobs-to-be-done` - Use to understand customer context, competitors, hiring, and firing moments.
- `opportunity-solution-trees` - Use to connect outcomes, opportunities, and solution options.
- `working-backwards` - Use for Amazon-style PR/FAQ and customer-backward product definition.
- `prd-writer` - Use for structured product requirements.
- `to-prd` - Use to turn conversation context into a PRD for the project issue tracker.
- `feature-prioritization-assistant` - Use for RICE scoring and roadmap prioritization.
- `llm-council` - Use to pressure-test high-stakes decisions with multiple independent advisors and a synthesized verdict.
- `okrs` - Use for objectives, key results, alignment, and progress cadence.
- `strategy-kernel` - Use for Rumelt Strategy Kernel work: diagnosis, guiding policy, and coherent actions.
- `positioning-canvas` - Use for category, alternatives, differentiation, and target customers.
- `seven-powers` - Use for durable competitive advantage and moat analysis.
- `monetizing-innovation` - Use for pricing, packaging, value metrics, and willingness to pay.
- `strategic-narrative` - Use for movement narratives and company/product storytelling.
- `design-sprint` - Use for 5-day problem-to-prototype discovery sprints.

## Growth, Engagement, Marketplaces, and Experiments

Tags: `growth`, `retention`, `marketplaces`, `experiments`, `seo`, `plg`, `pmf`

Use when the user is optimizing growth loops, retention mechanics, acquisition, marketplaces, product-market fit, or controlled experiments.

Skills:

- `growth-loops` - Use to design compounding growth systems.
- `product-led-growth` - Use for self-serve, freemium, PQL, and bottom-up growth motions.
- `product-led-seo` - Use for programmatic SEO and organic acquisition as product work.
- `hierarchy-of-engagement` - Use for core actions, accruing benefits, and consumer retention.
- `hierarchy-of-marketplaces` - Use for two-sided marketplace sequencing, liquidity, and dominance.
- `hooked-model` - Use for habit-forming product loops.
- `pmf-survey` - Use for product-market fit measurement and improvement.
- `ab-test-designer` - Use to design robust A/B tests for features and conversion.
- `trustworthy-experiments` - Use to design, run, and interpret controlled experiments correctly.
- `user-feedback-synthesizer` - Use to synthesize qualitative feedback across sources.

## Communication, Facilitation, and Collaboration

Tags: `communication`, `feedback`, `facilitation`, `translation`, `updates`, `decision-making`

Use when the work is about explaining, translating, challenging, facilitating, or communicating decisions and progress.

Skills:

- `traductor-bilingue` - Use for English-Spanish technical translation.
- `ste` - Use only when the user explicitly requests ASD-STE100 Simplified Technical English or invokes `/ste`; do not use it for ordinary clarity or documentation requests.
- `radical-candor` - Use for direct feedback while preserving care.
- `stakeholder-update-generator` - Use for progress updates and release notes.
- `grill-me` - Use to stress-test a plan or design through questioning.
- `grill-with-docs` - Use to challenge a plan against project docs and capture decisions.
- `llm-council` - Use when a decision has real tradeoffs and needs multi-perspective pressure testing.
- `caveman` - Use when the user requests ultra-short communication.
- `thinkies` - Use to generate ideas or reframe a stuck problem.
- `refinement-loop` - Use when the output needs multiple distillation passes.
- `strategic-compact` - Use to preserve session context at logical phase boundaries.

## Knowledge Vault, Wiki, and Personal Knowledge

Tags: `wiki`, `obsidian`, `knowledge-management`, `ingest`, `links`, `research`, `personal-context`

Use when information should be captured, routed, queried, synthesized, linked, or maintained as durable knowledge.

Skills:

- `personal-knowledge-routing` - Use to decide what belongs in the personal vault versus agent configuration.
- `llm-wiki` - Use for the foundational raw to wiki to schema knowledge architecture.
- `obsidian-cli` - Use for Obsidian vault CLI operations, note management, and plugin or theme development.
- `vault-artifact-toolchain` - Use for Mermaid, Marp, Excalidraw, notebooklm-py, yt-dlp, markitdown, and Makefile vault artifact workflows.
- `wiki-setup` - Use to initialize or repair wiki vault structure.
- `wiki-ingest` - Use to ingest documents, folders, or raw staging content.
- `wiki-update` - Use to distill the current project into the wiki.
- `wiki-query` - Use to answer from the compiled wiki with citations.
- `wiki-lint` - Use to audit orphans, broken links, staleness, and contradictions.
- `wiki-status` - Use to inspect ingest progress, deltas, and graph health.
- `wiki-capture` - Use to save the current conversation as a structured note.
- `wiki-dashboard` - Use to create Obsidian Bases dashboards.
- `wiki-research` - Use to research with web sources and file results into the wiki.
- `wiki-synthesize` - Use to create synthesis pages from recurring concept co-occurrences.
- `wiki-rebuild` - Use to archive and rebuild the wiki from sources.
- `wiki-export` - Use to export the wiki graph to external formats.
- `graph-colorize` - Use to update Obsidian graph color groups.
- `ingest-url` - Use for pasted links or explicit URL ingest.
- `cross-linker` - Use for adding missing wikilinks after large ingests.
- `tag-taxonomy` - Use to normalize and assign controlled wiki tags.
- `claude-history-ingest` - Use to mine Claude Code history into the wiki.
- `codex-history-ingest` - Use to mine Codex CLI history into the wiki.
- `wiki-history-ingest` - Use to route Claude or Codex history ingestion.
- `data-ingest` - Use for chat exports, logs, transcripts, CSV, and unstructured text.
