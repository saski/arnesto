## Why

The repository has evolved from a forked rules collection into a personal,
multi-tool agent harness spanning rules, skills, durable context, OpenSpec,
Codex, Hermes, OmniRoute, and local tool wiring. Its current name and GitHub
fork relationship no longer describe that role, while path-specific setup and
absolute symlinks make an unplanned rename unnecessarily risky.

## What Changes

- Establish **Arnesto** as the public identity of the multi-tool agent harness.
- Create `saski/arnesto` as a standalone repository with the complete Git
  history, rather than destructively detaching the current fork.
- Keep `saski/augmentedcode-configuration` as an archived provenance and
  migration pointer so stars, its child fork, and historical context remain
  intact.
- Make setup and validation independent of the checkout directory name.
- Keep `~/.agents` as the stable tool-facing interface and provide a reversible
  compatibility bridge for any later local directory rename.
- Update active identity and path references without rewriting historical
  research artifacts.

## Capabilities

### New Capabilities

- `harness-repository-portability`: Defines standalone repository identity,
  path-independent setup, provenance preservation, migration sequencing,
  compatibility, and rollback requirements for the agent harness.

### Modified Capabilities

None.

## Impact

- Repository identity, README, maintainer documentation, and active routing
  references will change from `augmentedcode-configuration` to `Arnesto`.
- `setup-symlinks.sh` and its contract tests will stop depending on the current
  checkout name.
- The local Git `origin` will eventually point to
  `git@github.com-saski:saski/arnesto.git`; the physical checkout path may
  remain unchanged until a separately verified local migration.
- Home-directory symlinks, Codex trusted-project state, Hermes guidance,
  consuming-repository pointers, and vault references are migration consumers.
- Existing credentials, sessions, runtime databases, historical `thoughts/`
  artifacts, and the current fork's metadata remain outside destructive
  migration steps.
