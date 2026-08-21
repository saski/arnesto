---
name: source-command-bug-fixing-agent
description: Investigate and fix bugs in a company environment using available tickets, internal documentation, private repositories, ownership data, and production evidence. Use for corporate or internal engineering incidents that span systems such as Jira, Confluence, Slack, Drive, GitHub, or enterprise monorepos; use diagnose for ordinary repository-local debugging.
---

# Company Environment Bug Fixing

Use this skill as the company-context overlay for a disciplined bug-fixing
workflow. Load and follow the `diagnose` skill for the core
reproduce-minimise-hypothesise-instrument-fix loop.

## Inputs

Collect what is available, without making every item a prerequisite:

- Ticket, incident, or bug report URL and its relevant fields.
- Observed behavior, expected behavior, environment, timestamps, and error
  signatures.
- Candidate service, repository, workspace, package, or deployment.
- Available access to internal documentation, logs, issue trackers, source
  control, and CI/CD evidence.

Ask one focused question only when a missing input makes the next action unsafe
or would materially change scope. Do not fabricate access, connector results,
ticket fields, documentation, owners, or production state. When company access
is unavailable, work only from artifacts the user provides and label the gaps.

## Safety Boundary

- Never expose credentials, tokens, customer data, or restricted internal
  material in prompts, logs, patches, or external services.
- Pause for authentication, OTPs, secrets, production mutation, deployment,
  rollback execution, external messages, and ticket or pull-request updates
  unless the user has explicitly authorized that action.
- Treat incident mitigation and permanent correction as separate decisions.
- Preserve unrelated work and inspect repository instructions before editing.
- Do not send private company code or data through an unapproved model route.

## Evidence Workflow

1. Establish the bug contract from the ticket or report: observable failure,
   expected outcome, affected environment, scope, severity, and reproducibility.
2. Search only available company sources for matching component names, error
   signatures, prior incidents, runbooks, architecture decisions, and recent
   changes. Record source strength and unresolved contradictions.
3. Map the failure to code. Inspect stack traces, workspace metadata,
   organization-prefixed dependencies such as `@work/*`, service manifests,
   recent commits, and `CODEOWNERS` when present. Resolve packages from actual
   repository configuration rather than assumed paths.
4. Reproduce the failure at the narrowest public interface. Add one failing
   behavior-level test when practical.
5. Rank a small set of falsifiable hypotheses and gather evidence that can
   disprove each one. Distinguish confirmed root cause from plausible causes.
6. Implement the smallest reversible fix, then run the focused test and the
   repository's canonical validation. Verify relevant security or production
   risk only when the evidence makes it material.
7. Define rollback and operational verification before recommending rollout.

## Engineering Handoff

Report concise, professional English sections:

- Issue summary and user or system impact.
- Evidence consulted, access gaps, and important contradictions.
- Impacted repositories, services, packages, and files.
- Root cause, or ranked hypotheses if the cause is not confirmed.
- Fix implemented or proposed, including why it is the smallest safe change.
- Validation results, explicitly naming skipped or unavailable checks.
- Deployment risk, monitoring signal, and rollback plan.
- Recommended owners based on `CODEOWNERS` or repository history, plus the
  appropriate pull-request or ticket next step.
- Remaining questions or decisions requiring company access or approval.

Give confidence as a short evidence-based statement only when it helps a
decision. Do not reveal private chain-of-thought or manufacture a percentage.
