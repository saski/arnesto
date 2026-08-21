# Skills index (`.agents/skills/`)

Use this file to match user requests to a skill **before** opening `SKILL.md`. Purposes mirror each skill’s `description` in frontmatter.

For domain-first routing, tags, and short usage notes, use [skill-domain-routing.md](skill-domain-routing.md).

Cursor-only skills (Canvas, SDK, `/loop`, meta-skills) live in `.cursor/skills-cursor/` and are listed in [cursor-skills.md](cursor-skills.md), not here.

Imported and local sources land in the same tree:

- **[skill-factory](https://github.com/saski/skill-factory)** — imported into this repo via `./pull-and-sync-skills.sh` / `./sync-skill-factory.sh`
- **Local sibling skill repos** — referenced by symlink from `.agents/skills/` to `~/Code/augmented-lean-delivery` and `~/Code/augmentedcode-skills`
- **Product management pack** — `pmprompt/claude-plugin-product-management` (integrity: repo-root `skills-lock.json`; taxonomy and overlaps: [.agents/skills/skill-foundry/agents/catalog-product-management.yaml](../skills/skill-foundry/agents/catalog-product-management.yaml))
- **Matt Pocock skills** — `mattpocock/skills` (integrity: repo-root `skills-lock.json`; governance: [.agents/skills/skill-foundry/agents/catalog-engineering.yaml](../skills/skill-foundry/agents/catalog-engineering.yaml))
- **Google Data Cloud skills** — installed with `.agents/skills/.datacloud_skills_manifest`; governance: [.agents/skills/skill-foundry/agents/catalog-engineering.yaml](../skills/skill-foundry/agents/catalog-engineering.yaml)
- **Native and local skills** — authored, maintained, or locally installed into this repository

## Local sibling skill references

| Skill | Source | Purpose |
|-------|--------|---------|
| complexity-review | augmented-lean-delivery | Reviews technical proposals and architectural decisions against 30 complexity dimensions. Use to challenge complexity drivers and push for the simplest viable approach. |
| hamburger-method | augmented-lean-delivery | Applies the Hamburger Method to slice features into vertical deliverable pieces. Use when work needs incremental delivery across layers. |
| micro-steps-coach | augmented-lean-delivery | Breaks decided work into 1-3 hour micro-steps with zero downtime and reversible change sequencing. |
| story-splitting | augmented-lean-delivery | Detects oversized stories and applies splitting heuristics based on linguistic red flags and bundled requirements. |
| mutation-testing-js | augmentedcode-skills | Mutation testing patterns for JavaScript and TypeScript using Stryker. Use to find weak or missing JS/TS tests. |
| mutation-testing-python | augmentedcode-skills | Mutation testing patterns for Python using mutmut. Use to find weak or missing pytest coverage. |
| test-desiderata | augmentedcode-skills | Analyze and improve test code quality using Kent Beck's Test Desiderata framework. |

## Skill-Factory (synced)

| Skill | Category | Purpose |
|-------|----------|---------|
| traductor-bilingue | tools | Translates technical text between English and Spanish preserving tone and format. Keeps technical terms in English when common in Spanish dev teams (deploy, pull request, pipeline, staging). Use when translating technical documentation, code comments, or team communication. |
| nullables | testing | Writes tests without mocks using Nullables. Use when writing tests, especially testing code with external I/O (HTTP, files, databases, clocks, random numbers), designing infrastructure wrappers or replacing mocking libraries. |
| mutation-testing | testing | Finds weak or missing tests by analyzing if code changes would be caught. Use when verifying test effectiveness, strengthening test suites, or validating TDD workflows. |
| bdd-with-approvals | testing | Write executable BDD specifications as approval-test fixtures in domain language. Use when doing BDD, writing Given/When/Then specs, creating human-scannable test fixtures, or turning event model slices into executable tests. Pairs with event-modeling and approval-tests skills. Not for unit test mechanics or mock setup. |
| approval-tests | testing | Writes approval tests (snapshot/golden master testing) for Python, JavaScript/TypeScript, or Java. Use when verifying complex output, characterization testing legacy code, testing combinations, or working with .approved/.received files. |
| thinkies | practices | Applies Kent Beck's Thinkies—pattern-based thinking habits that generate ideas. Use when stuck, exploring alternatives, or reframing decisions. |
| thin-wrappers | practices | Encapsulates infrastructure SDKs behind minimal domain-aligned interfaces. Use when accessing any external infrastructure to keep SDK usage contained, testing simple, and changes easy. |
| small-safe-steps | practices | Small Safe Steps (S3): breaks work into 1-3h increments with zero downtime. Use when asking "how do I implement/migrate/refactor", "what steps to do X", "plan safe migration", or handling risky DB/API changes. Applies expand-contract pattern for migrations, refactorings, schema changes. |
| refinement-loop | practices | Iterative refinement through multiple passes. Use when the user asks to 'meditate on', 'distill', 'refine', or 'iterate on' something, or proactively when a problem benefits from multiple passes rather than a single attempt. |
| refactoring | practices | Structured refactoring process with prep, main refactoring, final evaluation, and summary phases. Use when asked to "refactor", "clean up code", "improve readability", or proactively when code gets too complex or messy. For XP simple-design refactoring with ROI prioritization use xp-simple-design-refactor; for safe large-scale refactoring use xp-mikado-method. |
| code-simplifier | practices | Simplifies and refines code for clarity, readability, and maintainability. Reduces complexity without changing behavior. Use when simplifying, cleaning up, or reducing complexity in code. |
| writing-bash-scripts | developer-tools | Bash script style guide. Always use when writing bash scripts, shell scripts, or CLI bash tools. |
| using-uv | developer-tools | Python package and project management with UV. Use when creating Python scripts, initializing projects, or managing dependencies. |
| bun-toolkit | developer-tools | JS/TS/JSX toolkit with Bun awareness. Use when using Bun as a runtime, test runner, or package manager in JavaScript and TypeScript projects. |
| git-worktrees | developer-tools | Creates git worktrees for parallel development. Use when creating a git worktree, setting up multiple working directories, or working on features in parallel. |
| dockerfile-review | developer-tools | Reviews Dockerfiles for build performance, image size, and security issues. Use when optimizing, validating, or improving Dockerfiles. |
| modern-cli-design | design | Principles for scalable, modern command-line tools - object-command architecture (noun-verb), LLM-optimized help, JSON output, concurrency patterns, credential management. Use when building CLIs, designing command structures, or implementing terminal applications. |
| hexagonal-architecture | design | Applies hexagonal (ports & adapters) architecture. Use when designing application structure, separating domain from infrastructure, creating testable boundaries, or when user mentions ports, adapters, hexagonal, or clean architecture. |
| event-modeling | design | Design systems using Event Modeling with vertical slices (STATE_CHANGE, STATE_VIEW, AUTOMATION). Use when asked to "model a domain", "design event-driven system", "map commands and events", "create system slices", or doing domain-driven design from scratch or over existing code. Not for infrastructure event buses or message broker configuration. |
| collaborative-design | design | Designs software features collaboratively through visual scenarios and iterative refinement. Use when designing features, tools, UIs, workflows, or any system before implementation. |
| creating-process-files | ai | Creates process files - text as code instructions for reliable AI workflows. Use when creating new process files. |
| writing-statuslines | ai | Writes Claude Code status line scripts. Use when creating, customizing, or debugging statusline configurations. |
| creating-hooks | ai | Create and configure Claude Code hooks for lifecycle automation (pre/post tool use, session start, prompt submit, notifications). Use when asked to "add a hook", "auto-format on save", "block dangerous commands", "inject context on prompt", or "notify when done". Not for general shell scripting or CI/CD pipelines. |
| ai-patterns | ai | Reference patterns for augmented coding with AI. Use when discussing AI coding patterns, anti-patterns, obstacles, context management, steering AI, or looking up Lexler's patterns collection. |
| align | design | Presents a proposed approach in progressive confirmable chunks with recommended decisions and alternatives. Use when aligning on a design, plan, or technical approach before implementation. |
| launching-agent-teams | ai | Launches agent teams with structured roles and task decomposition. Use when asked to create a team, spawn teammates, or coordinate multiple agents in parallel. |
| refactoring-team | ai | Iterative code refactoring through progressive lenses via a worker-reviewer agent team. |
| llm-council | strategy | Run a question or decision through multiple independent AI advisors with peer review and a synthesized verdict (Karpathy LLM Council style). Use for high-stakes tradeoffs and pressure-testing options. |
| strategy-kernel | strategy | Coaches through Rumelt's Strategy Kernel to build sound strategy. Use when defining strategy, diagnosing strategic challenges, or creating strategic plans. |

## Product management (external sync)

| Skill | Category | Purpose |
|-------|----------|---------|
| ab-test-designer | product-management | Design robust A/B test experiments. Use when testing a new feature, validating a hypothesis, or optimizing conversion rates. |
| design-sprint | product-management | Use when asked to "run a design sprint", "5-day sprint", "prototype in a week", "test ideas before building", or "Jake Knapp sprint". Helps teams go from problem to tested prototype in five days. The Design Sprint framework (created by Jake Knapp at Google Ventures) compresses months of work into one focused week. |
| feature-prioritization-assistant | product-management | Calculate RICE scores and prioritize features systematically. Use when building your product roadmap and need to make data-driven prioritization decisions. |
| growth-loops | product-management | Use when asked to "growth loops", "build a growth engine", "design a viral loop", "create a content loop", "move beyond paid acquisition", or "why isn't growth compounding". Helps design self-reinforcing growth systems where output becomes input. The Growth Loops framework (from Brian Balfour / Reforge and Elena Verna) shifts thinking from linear funnels to compounding loops. |
| hierarchy-of-engagement | product-management | Use when asked to "define our core action", "North Star metric", "accruing benefits", "improve retention mechanics", "hierarchy of engagement", or "Sarah Tavel framework". Helps consumer products identify the actions and benefits that drive long-term retention. The Hierarchy of Engagement framework (created by Sarah Tavel at Benchmark) maps progression from core action to mounting loss. |
| hierarchy-of-marketplaces | product-management | Use when asked about "marketplace strategy", "chicken and egg problem", "liquidity", "two-sided market", "tipping a marketplace", "GMV growth", or "Sarah Tavel marketplaces". Helps founders and product leaders build defensible marketplace businesses by sequencing supply and demand. The Hierarchy of Marketplaces framework (created by Sarah Tavel / Benchmark) provides a progression from focused launch to market dominance. |
| hooked-model | product-management | Use when asked to "build habit-forming products", "Hooked model", "trigger action reward investment", "create sticky behavior loops", or "design habit loops". Helps design products that form unprompted user habits. The Hooked Model (created by Nir Eyal) explains how products create habits through Trigger, Action, Variable Reward, and Investment. |
| jobs-to-be-done | product-management | Use when asked to "jobs to be done", "JTBD", "why customers churn", "prep for customer interviews", "hire and fire products", or "find real competitors". Helps discover unmet needs and the context behind purchasing decisions. The Jobs to be Done framework (created by Clayton Christensen and Bob Moesta) explains why customers hire and fire products. |
| monetizing-innovation | product-management | Use when asked about "pricing strategy", "willingness to pay", "value metric", "packaging tiers", "good better best pricing", "subscription vs usage pricing", or "price before product". Helps design products customers will pay for and choose pricing models that capture value. Based on Madhavan Ramanujam's Monetizing Innovation framework from Simon-Kucher. |
| okrs | product-management | Use when asked to "set OKRs", "objectives and key results", "quarterly OKR planning", "align objectives", "measure OKR progress", or "focus priorities with OKRs". Helps teams focus on what matters most and create a cadence of progress. The OKR framework (originated by Andy Grove at Intel, popularized by John Doerr at Google) creates alignment, focus, and learning cycles. Christina Wodtke's Radical Focus approach emphasizes simplicity and avoiding common pitfalls. |
| opportunity-solution-trees | product-management | Use when asked to "opportunity solution tree", "OST", "Teresa Torres", "map customer opportunities to outcomes", "structure discovery around opportunities", or "compare solutions for a customer need". Helps product teams connect outcomes to customer opportunities and test solutions with Opportunity Solution Trees (created by Teresa Torres). |
| pmf-survey | product-management | Use when asked to "PMF survey", "measure product-market fit", "40% rule", "Sean Ellis test", "Rahul Vohra method", or "how disappointed would you be". Helps quantify product-market fit and systematically improve it. The PMF Survey framework (created by Sean Ellis, popularized by Rahul Vohra at Superhuman) measures how disappointed users would be without your product and turns that data into a roadmap. |
| positioning-canvas | product-management | Use when asked to "position my product", "positioning canvas", "differentiate from competitors", "figure out our category", "repositioning", or "why customers should pick us". Helps define competitive alternatives, differentiated value, target customers, and market category. April Dunford's positioning framework from "Obviously Awesome" makes your product's value obvious to the right customers. |
| prd-writer | product-management | Generate comprehensive product requirements documents. Use when starting a new feature or product initiative and need structured documentation. |
| product-led-growth | product-management | Use when asked about "product-led growth", "PLG strategy", "self-serve growth", "freemium model", "free trial design", "product-led sales", "PQL", or "bottoms-up growth". Helps design and optimize product-led growth motions where the product drives acquisition, activation, and monetization. Based on frameworks from Elena Verna and Hila Qu. |
| product-led-seo | product-management | Use when asked to "product-led SEO", "programmatic SEO", "build programmatic pages", "organic acquisition for product", "decide if SEO is worth it", or "optimize for AI search". Helps evaluate whether SEO fits your business model and how to approach it as a product, not just marketing. The Product-Led SEO framework (created by Eli Schwartz) treats SEO as building products for search users. |
| radical-candor | product-management | Use when asked to "radical candor", "give feedback that cares", "have a difficult conversation", "challenge directly", "manage performance issues", or "give praise that lands". Helps deliver direct feedback while showing you care. The Radical Candor framework (created by Kim Scott) teaches how to challenge directly while caring personally. |
| seven-powers | product-management | Use when asked to "7 Powers", "build a competitive moat", "analyze defensibility", "find sustainable advantage", "economic moats", or "Hamilton Helmer framework". Helps identify durable competitive advantages. The 7 Powers framework (created by Hamilton Helmer) reveals the economic structures that protect business value from competition. |
| shape-up | product-management | Use when asked to "shape up", "run a shaping session", "set an appetite", "scope a project without estimates", "betting table", or "ship in fixed cycles". Helps teams escape estimate-driven development and Scrum fatigue. The Shape Up method (created by Ryan Singer at Basecamp/37signals) uses fixed time boxes, variable scope, and collaborative shaping to ship meaningful work predictably. |
| stakeholder-update-generator | product-management | Create compelling progress updates and release notes. Use when shipping a new feature or need to communicate progress to stakeholders. |
| strategic-narrative | product-management | Use when asked to "strategic narrative", "Andy Raskin", "tell our company story", "write a pitch deck", "explain why customers should care", or "movement narrative". Helps craft compelling narratives that define movements rather than just selling products. The Strategic Narrative framework (created by Andy Raskin) transforms pitches from feature lists into stories about change. |
| thinking-in-bets | product-management | Use when asked to "thinking in bets", "make decisions under uncertainty", "think probabilistically", "avoid resulting", "separate decision quality from outcomes", or "reduce bias in decisions". Helps make explicit bets and evaluate decisions on process, not results. The Thinking in Bets framework (from Annie Duke) applies poker strategy to business and life decisions. |
| trustworthy-experiments | product-management | Use when asked to "run an A/B test", "design an experiment", "check statistical significance", "trust our results", "avoid false positives", or "experiment guardrails". Helps design, run, and interpret controlled experiments correctly. Based on Ronny Kohavi's framework from "Trustworthy Online Controlled Experiments". |
| user-feedback-synthesizer | product-management | Analyze collections of user feedback to identify patterns and themes. Use when you have user feedback from multiple sources that needs synthesis. |
| working-backwards | product-management | Use when asked to "working backwards", "PR/FAQ", "Amazon PR/FAQ", "write a press release", "define a new product", or "write a customer-focused PRD". Helps define products by starting with the customer problem and desired outcome before building. The Working Backwards process (developed at Amazon) forces clarity on customer value before committing engineering resources. |

## Google Data Cloud skills (external sync)

| Skill | Category | Purpose |
|-------|----------|---------|
| accidental-data-loss-prevention | safety | Require explicit user consent before irreversible SQL, Cloud Storage, or GCP resource deletion commands. |
| bigquery-data-transfer-service | developer-tools | Discover and inspect BigQuery Data Transfer Service configurations and ingestion metadata. |
| building-data-apps | developer-tools | Build data apps, dashboards, and interactive reports with React/Vite or Streamlit over GCP data sources. |
| data-autocleaning | data-analysis | Profile, clean, and transform data sourced from BigQuery or Cloud Storage in Dataform, dbt, or BigQuery pipelines. |
| dataform-bigquery | developer-tools | Create, modify, and optimize Dataform SQLX projects and BigQuery ELT pipelines. |
| dbt-bigquery | developer-tools | Create, modify, troubleshoot, and optimize dbt projects and BigQuery models. |
| developing-with-bigquery | developer-tools | Route BigQuery query optimization, BigFrames, BigQuery ML, AI functions, and vector search work. |
| discovering-gcp-data-assets | data-analysis | Find and inspect Google Cloud data assets, schemas, metadata, and governance policies. |
| gcloud-auth-verification | developer-tools | Diagnose missing Google Cloud authentication and Application Default Credentials issues. |
| gcp-composer-troubleshooting | developer-tools | Produce evidence-based RCA for Cloud Composer and Airflow DAG or task failures. |
| gcp-data-pipelines | developer-tools | Primary router for building, managing, and orchestrating data pipelines on Google Cloud. |
| gcp-dataflow | developer-tools | Write, package, and execute Apache Beam pipelines on Google Cloud Dataflow. |
| gcp-pipeline-orchestration | developer-tools | Generate, update, deploy, and trigger Cloud Composer orchestration pipeline definitions. |
| gcp-pipeline-resource-provisioning | developer-tools | Provision supported GCP data-pipeline resources declaratively through deployment.yaml. |
| gcp-spark | data-analysis | Develop and troubleshoot Spark ETL and ML work on Dataproc clusters or serverless Spark. |
| managing-python-dependencies | developer-tools | Detect and use the project dependency manager before installing packages or running Python code. |
| ml-best-practices | data-analysis | Guide machine learning and data analysis workflows, including clustering, classification, regression, forecasting, and statistical testing. |
| notebook-guidance | data-analysis | Structure, execute, and validate Jupyter notebooks for data analysis, visualization, and BigQuery SQL. |
| skill-repair | skill-governance | Repair failed skill installations and update installer manifests after fixes. |

## Matt Pocock skills (external sync)

| Skill | Category | Purpose |
|-------|----------|---------|
| caveman | productivity | Ultra-compressed communication mode. Use when the user asks for caveman mode, shorter replies, fewer tokens, or invokes `/caveman`. |
| diagnose | engineering | Disciplined diagnosis loop for hard bugs and performance regressions. Use when debugging failures, broken behavior, or performance regressions. |
| grill-me | productivity | Interview the user relentlessly about a plan or design until reaching shared understanding. Use when stress-testing a plan or design. |
| grill-with-docs | engineering | Challenge a plan against the existing domain model and update CONTEXT/ADR docs as decisions crystallise. Use when stress-testing a plan against project language and documented decisions. |
| improve-codebase-architecture | engineering | Find architecture deepening opportunities using CONTEXT.md and docs/adr/. Use when improving architecture, testability, coupling, or AI navigability. |
| setup-matt-pocock-skills | engineering | Set up per-repo issue tracker, triage label, and domain-doc configuration for Matt Pocock engineering skills. |
| tdd | engineering | Test-driven development with a red-green-refactor loop. Use when building features or fixing bugs test-first. |
| to-issues | engineering | Break a plan, spec, or PRD into independently grabbable issue-tracker tickets using tracer-bullet vertical slices. |
| to-prd | engineering | Turn the current conversation context into a PRD and publish it to the project issue tracker. |
| triage | engineering | Triage issues through a role-driven state machine. Use for incoming bugs, feature requests, issue workflow, and AFK-agent readiness. |
| write-a-skill | productivity | Create new agent skills with proper structure, progressive disclosure, and bundled resources. |
| zoom-out | engineering | Ask the agent to zoom out and provide broader module/caller context using project domain language. |

## Native skills (local to this repo)

| Skill | Category | Purpose |
|-------|----------|---------|
| agent-config-hygiene | practices | Audit and simplify AGENTS.md hierarchies, always-loaded rules, client wrappers, skill routing, and runtime boundaries without adding more permanent context. |
| free-agent-execution | developer-tools | Run an explicitly requested, bounded, non-sensitive coding task through the local free-worker adapter using a verified free OpenCode model. Use only when the user asks to execute a free worker or free agent and accepts the external-model safety boundary. |
| fic-create-plan | workflow | Build a detailed, phase-based implementation plan from research or a task description. Use when the user asks for implementation planning, phased rollout, or a concrete execution plan. |
| fic-implement-plan | workflow | Execute an approved implementation plan phase by phase with verification. Use when the user asks to implement a plan file from thoughts/shared/plans. |
| fic-research | workflow | Research and document the current codebase state without proposing changes. Use when the user asks to investigate existing behavior, architecture, or implementation details and capture findings. |
| fic-validate-plan | workflow | Validate that an implementation plan was executed correctly. Use when the user asks to verify completion, compare code changes to a plan, or produce a validation report. |
| project-status-maintenance | documentation | Create or update PROJECT_STATUS.md at the repo root using the canonical structure (Executive Summary, Completed Components, In Progress, Next Steps, Known Issues, Notes). |
| source-command-bug-fixing-agent | engineering | Investigate and fix company-environment bugs using available tickets, internal documentation, private repositories, ownership data, and production evidence while preserving corporate access and mutation boundaries. |
| find-docs | developer-tools | Retrieves up-to-date documentation, API references, and code examples for developer technologies using the Context7 CLI. Use for library, framework, SDK, API, CLI tool, or cloud service questions. |
| documentation-lookup | developer-tools | Use current library and framework docs through Context7, preferring MCP tools with the CLI as a fallback. Activates for setup questions, API references, code examples, or named frameworks such as React, Next.js, or Prisma. |
| verification-loop | workflow | A comprehensive verification system for Claude Code sessions. |
| strategic-compact | workflow | Suggests manual context compaction at logical intervals to preserve context through task phases rather than arbitrary auto-compaction. |
| xp-code-review | practices | Review pending changes for tests, maintainability, and project rules. Use when the user asks for code review, review pending changes, or alignment with maintainability and project rules. |
| xp-increase-coverage | testing | Increase test coverage with high-value, behavior-focused tests. Use when the user asks to increase coverage, write tests for untested code, or add high-value tests. |
| xp-mikado-method | practices | Apply the Mikado Method for safe refactoring via a dependency graph of small steps. Use when the user asks for Mikado Method, safe refactoring, or dependency graph for a large change. |
| xp-plan-untested-code | testing | Plan tests for untested code with coverage gaps and risk-based prioritization. Use when the user asks for a test plan for untested code or coverage gaps. |
| xp-predict-problems | practices | Predict production failures and high-risk paths with a Lean/XP lens. Use when the user asks to predict failures, production risk, or edge cases. |
| xp-security-analysis | practices | Deep, pragmatic security review with OWASP and threat-modeling lens. Use when the user asks for security review, risk assessment, OWASP, or threat modeling. |
| xp-simple-design-refactor | practices | Refactor toward simple design and maintainability with ROI-driven prioritization. Use when the user asks to refactor, improve simple design, maintainability, or reduce accidental complexity. |
| xp-technical-debt | practices | Catalog and prioritize technical debt with a Lean/XP lens; top 5, quick wins, strategic debt. Use when the user asks for technical debt analysis, prioritization, quick wins, or tech debt payoff order. |
| cwv-improvement-planner | developer-tools | Build and prioritize Core Web Vitals improvement plans for web apps with a focus on LCP, INP, and TTFB. Use when users mention CWV, Lighthouse, PageSpeed, performance budgets, render blocking, hydration, image prioritization, CDN caching/compression, CloudFront, or Next.js web performance tuning. |
| test-doubles-first | testing | Select and implement the right test double with a default preference for fakes, stubs, and spies over mocks. Use when writing or refactoring tests, especially when users mention test doubles, mocking strategy, interaction assertions, or flaky tests caused by over-mocking. |
| planning-with-files | workflow | Implements Manus-style file-based planning to organize and track progress on complex tasks. Creates task_plan.md, findings.md, and progress.md. Use when asked to plan out, break down, or organize a multi-step project, research task, or any work requiring >5 tool calls. |
| openspec | workflow | Spec-driven development with OpenSpec. Use when the user mentions OpenSpec, OPSX, spec-driven development, SDD, change proposals, delta specs, /opsx commands, docs/thoughts-first OpenSpec initialization, or wants structured planning for features, migrations, refactors, or bug fixes. |
| find-skills | ai | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. |
| code-notify | developer-tools | Use when a task should trigger a local completion notification through code-notify, or when configuring cross-tool notification behavior for Codex, Cursor, Claude, Gemini, or similar agent workflows. |
| github-host-alias | developer-tools | Use when running git clone, git remote add, git remote set-url, or suggesting GitHub SSH commands to ensure all GitHub access uses the saski SSH host alias. |
| corporate-aws-cli | developer-tools | Use when using the AWS CLI against a corporate AWS account after SAML/OIDC federation (e.g. saml2aws, aws sso login), when STS fails with invalid XML or empty responses, when selecting profiles or regions for Terraform or CI/CD stacks, or when validating RDS engine versions with describe-orderable-db-instance-options in the target account and region. |
| lean-ai-adoption-coach | ai | Guide AI adoption decisions in software development using Lean, Extreme Programming, and pragmatic simplicity. Use when evaluating AI tools, agents, workflows, prompts, automations, or rollout guardrails. |
| personal-knowledge-routing | workflow | Route durable personal context and reusable knowledge between agent configuration and the personal knowledge vault without bloating always-loaded rules. |
| vault-artifact-toolchain | workflow | Use text-first tooling for vault artifacts and source ingest: Mermaid .mmd to PNG via mmdc, Marp decks to PDF/PPTX, Excalidraw Markdown JSON sketches, notebooklm-py summaries, yt-dlp talk metadata/captions, markitdown document conversion, and Makefile-wrapped workflows. |
| obsidian-cli | developer-tools | Interact with Obsidian vaults using the Obsidian CLI to read, create, search, and manage notes, tasks, properties, and more. Also supports plugin and theme development with commands to reload plugins, run JavaScript, capture errors, take screenshots, and inspect the DOM. Use when the user asks to interact with their Obsidian vault, manage notes, search vault content, perform vault operations from the command line, or develop and debug Obsidian plugins and themes. |
| pbt-pragmatic-adoption | testing | Pragmatic property-based testing review and first-wave adoption for this listings-webapp monorepo (Jest + fast-check, unit tests only). |
| skill-foundry | skill-governance | Design, organize, evaluate, benchmark, and improve portable Agent Skills. Use when creating a new skill, auditing a skill library, comparing a skill against baseline, optimizing descriptions, or retiring outdated skills. |
| lustra | developer-tools | Run a structured code-health and due-diligence workflow across security, license, dependencies, types, tests, dead code, design, observability, performance, docs, CI, and project structure. |
| google-adk-setup | developer-tools | Bootstrap a Google ADK project from zero to a running local dev UI. Use when setting up a new ADK agent project, configuring Vertex AI credentials, scaffolding the agent folder with `uv run adk create agent`, or launching the ADK dev UI. |
| google-adk-agent-patterns | ai | Define ADK agents with function tools and compose multi-agent systems (SequentialAgent, LoopAgent, ParallelAgent, AgentTool). Use when writing agent definitions, adding Python tools, building pipelines, or designing router/delegation patterns. |
| llm-wiki | workflow | Foundational LLM Wiki (Karpathy-style) pattern for Obsidian: raw → wiki → schema; use for wiki architecture and knowledge strategy. |
| wiki-setup | workflow | Initialize or repair an Obsidian wiki vault structure, `.env`, and special files; use on "set up my wiki" or vault init. |
| wiki-ingest | workflow | Ingest documents into the Obsidian wiki from files, folders, or `_raw/` staging; use for "add this to the wiki" and bulk imports. |
| wiki-update | workflow | Distill the current project into the wiki from any repo; use for "update wiki", "sync to wiki", cross-project capture. |
| wiki-query | workflow | Search and answer from the compiled wiki with citations; includes fast index-only mode for quick lookups. |
| wiki-lint | workflow | Audit wiki health: orphans, broken links, staleness, contradictions; use for "clean up the wiki" and maintenance passes. |
| wiki-status | workflow | Dashboard of ingest progress, deltas, and optional graph insights ("hubs", structure) before append vs rebuild decisions. |
| wiki-capture | workflow | Save the current conversation or discussion as a structured Obsidian wiki note; use for conversation capture, not generic source ingest. |
| wiki-dashboard | workflow | Create Obsidian Bases dashboard views from vault frontmatter; use for dynamic tables, card views, and content indexes. |
| wiki-research | workflow | Research a topic with web sources and file the synthesized result into the Obsidian wiki; use when the requested output belongs in the wiki. |
| wiki-synthesize | workflow | Discover recurring concept co-occurrences and create first-class synthesis pages that connect them. |
| wiki-rebuild | workflow | Archive current wiki and rebuild from sources or restore from archive; use for "rebuild the wiki" / controlled resets. |
| wiki-export | workflow | Export the wiki graph to JSON, GraphML, Neo4j Cypher, or HTML for external tools and visualization. |
| graph-colorize | workflow | Color-code the Obsidian graph view by updating `.obsidian/graph.json` color groups while preserving other graph settings. |
| ingest-url | workflow | Fetch a URL and distill the page into the Obsidian wiki; use for pasted links or explicit URL ingest requests. |
| cross-linker | workflow | Discover and add missing wikilinks across pages; write-heavy linking pass after large ingests. |
| tag-taxonomy | workflow | Controlled vocabulary for wiki tags; use before assigning tags or when normalizing messy tag usage. |
| claude-history-ingest | workflow | Mine Claude Code history (`~/.claude`) into the wiki; use for "process my Claude history". |
| codex-history-ingest | workflow | Mine Codex CLI history (`~/.codex`) into the wiki; use for Codex sessions and transcript logs. |
| wiki-history-ingest | workflow | Router for `/wiki-history-ingest claude|codex`; dispatches to the matching history ingest skill. |
| data-ingest | workflow | Catch-all ingest for chat exports, Slack/Discord logs, transcripts, CSV, and other unstructured text sources. |
| skill-creator | skill-governance | Create, edit, benchmark, and tune Agent Skills and evals; use for new skills and performance tuning. |
