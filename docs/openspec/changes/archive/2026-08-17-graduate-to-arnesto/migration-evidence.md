## Migration Baseline

- Recorded: 2026-08-17
- Accepted source revision:
  `e21a933cb2cd87298939b5a4c475edf48d7b0c78`
- Arnesto cutover revision:
  `5bc1c9c6839c9eb042e31b4a1277b530f41e43eb`
- Local `main` and `origin/main` match at the accepted revision.
- Legacy remote:
  `git@github.com-saski:saski/augmentedcode-configuration.git`
- Planned canonical remote: `git@github.com-saski:saski/arnesto.git`
- Rollback before legacy archival: restore the legacy URL as `origin` and
  verify `main` against the accepted revision.
- Rollback after legacy archival: unarchive the legacy repository, restore its
  URL as `origin`, and verify the accepted revision.

## Observable GitHub State

- Repository is public and GitHub reports `fork: true`.
- Parent and source are `eferro/augmentedcode-configuration`.
- Default branch is `main`.
- Repository size reported by the public API is approximately 1.9 MB.
- Public API reported fourteen stars, zero open issues, issues disabled, wiki
  enabled, and one child fork: `joseandrestrujillo/augmentedcode-configuration`.
- No public repository rulesets were returned on 2026-08-17.
- The public branch-details request returned HTTP 504, so branch protection
  remains unverified until authenticated GitHub access or the Settings UI is
  available.
- The repository contains one GitHub Actions workflow,
  `.github/workflows/check.yml`, which runs `make ci-check`.
- GitHub-hosted secrets, variables, environments, webhooks, Actions
  permissions, and other private settings are not observable through the
  current unauthenticated API session and must be checked before cutover.

## Active Local Consumers

- Twenty-six live home-directory symlinks resolve through the legacy checkout
  path when root instruction links are included.
- `~/.agents` is the stable shared entry point and currently resolves to the
  repository's `.agents` directory.
- Active external path or identity consumers exist in:
  - Codex trusted-project configuration;
  - MyBroworld agent guidance and chat-memory protocol;
  - net-art-studies agent guidance;
  - personal-knowledge-vault guidance and adapter documentation;
  - Hermes routing documentation and skills;
  - the shell-level Hermes skill-router comment.
- Eight tracked files outside historical `thoughts/` records contain the
  legacy repository identity. Historical research is excluded from mechanical
  replacement.

## Gate Evidence

- `49a2128 Prefer bounded lower-cost delegation` was committed separately.
- `e21a933 Add guarded Hermes source updates` was committed separately.
- The Hermes focused tests and the repository's canonical `make check` passed
  before both commits were pushed to the legacy `origin/main`.
- A behavior-level contract failed while setup still assumed the legacy checkout
  path and passed after `REPO_DIR` defaulted to the script directory.
- The focused portability contract, `openspec validate graduate-to-arnesto`,
  and the complete `make check` suite passed with the portable setup included.

## Standalone Remote Evidence

- Created `https://github.com/saski/arnesto` as a public repository without a
  fork action; GitHub reports `fork: false` and no parent.
- Mirrored the only source branch, `main`, at the cutover revision. The source
  contained no tags.
- GitHub Actions run `32039934964` completed successfully at the cutover
  revision.
- Arnesto uses the description `Arnesto — the agent harness that got out of
  hand` and the minimal topics `ai-agents`, `agent-harness`, and
  `coding-agents`.
- Actions are enabled with `allowed_actions: all` and no SHA-pinning
  requirement, matching the legacy repository.
- Both repositories report `main` as unprotected. The legacy repository has no
  rulesets, Actions secrets, Actions variables, environments, or webhooks to
  migrate.
- Local `origin` is `git@github.com-saski:saski/arnesto.git`; the former
  `origin` is retained as `legacy` at
  `git@github.com-saski:saski/augmentedcode-configuration.git`.
- Local `HEAD`, `origin/main`, and `legacy/main` matched at the cutover
  revision before rebranding began.

## Rebranding and Legacy Retirement Evidence

- Arnesto rebranding was published at
  `2751cb383a80ab416b46a6257a5b67c63caf718e`.
- GitHub Actions run `32040211365` passed for that revision.
- A fresh SSH clone through `github.com-saski` matched the rebranding revision
  and passed `make ci-check`.
- The legacy-only commit
  `d57067bf1e396647d09d4c2da3f348096ef38102` added the Arnesto migration
  pointer without merging legacy-only content into Arnesto.
- GitHub reports the legacy fork archived and still public, with fourteen
  stars and one child fork.

## Physical Path Decision

- The checkout remains at
  `/Users/saski/Code/augmentedcode-configuration`; this is now only a local
  physical path, not the repository identity or remote destination.
- The live managed symlinks and active external consumers still resolve that
  path, while `~/.agents` remains the stable shared entry point.
- A physical rename is deferred because it provides no current operational
  benefit and would create avoidable churn in symlinks, trust state, and
  external repository guidance.
- If that trade-off changes, the compatibility-link procedure in `design.md`
  remains the required migration path.
