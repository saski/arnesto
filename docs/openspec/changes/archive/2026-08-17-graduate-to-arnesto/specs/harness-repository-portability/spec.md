## ADDED Requirements

### Requirement: Standalone harness repository
The project SHALL publish Arnesto as a standalone GitHub repository whose Git
history includes the complete history of the current harness. The local remote
SHALL use the `git@github.com-saski:` SSH alias.

#### Scenario: Publish the independent repository
- **WHEN** the migration switches the canonical remote to `saski/arnesto`
- **THEN** GitHub SHALL report that repository as independent rather than a fork
- **AND** its `main` revision SHALL match the accepted source revision
- **AND** the local `origin` SHALL be `git@github.com-saski:saski/arnesto.git`

### Requirement: Non-destructive provenance
The migration SHALL preserve the original fork as a provenance record and
SHALL NOT delete or detach it as part of the transition.

#### Scenario: Retire the original fork
- **WHEN** Arnesto passes repository and harness validation
- **THEN** `saski/augmentedcode-configuration` SHALL point visitors to Arnesto
- **AND** it SHALL remain available for its existing stars and child fork
- **AND** Eduardo Ferro's originating work SHALL remain acknowledged

### Requirement: Checkout-name-independent setup
Repository setup and validation SHALL derive the default repository root from
the checked-out script location rather than a fixed directory name. An explicit
`REPO_DIR` override SHALL remain supported.

#### Scenario: Set up from an arbitrary checkout name
- **WHEN** the repository is checked out to a directory that is not named
  `augmentedcode-configuration`
- **THEN** setup SHALL create managed links against that checkout
- **AND** validation SHALL compare `~/.agents` with that checkout's `.agents`
- **AND** no contract SHALL require the legacy directory name

### Requirement: Stable tool-facing interface
The migration SHALL keep `~/.agents` as the stable shared interface and SHALL
not merge or relocate mutable runtime state belonging to Codex, Orca, Hermes,
OmniRoute, or other clients.

#### Scenario: Change repository identity without moving runtimes
- **WHEN** the GitHub remote and repository branding change
- **THEN** existing tools SHALL continue resolving shared assets through
  `~/.agents`
- **AND** credentials, sessions, databases, trust data, and mutable client
  configuration SHALL remain in their existing runtime-owned locations

### Requirement: Reversible physical-path migration
Any later local directory rename SHALL use a temporary compatibility path and
SHALL regenerate managed links before removing that compatibility path.

#### Scenario: Rename the local checkout
- **WHEN** the checkout moves from the legacy path to the Arnesto path
- **THEN** the legacy path SHALL continue resolving during migration
- **AND** `setup-symlinks.sh setup` and validation SHALL pass from the new path
- **AND** the compatibility path SHALL NOT be removed until active consumers
  and managed symlinks no longer depend on it

### Requirement: Selective identity migration
The project SHALL update active setup, routing, status, and user-facing identity
references while retaining historical research references that describe the
repository's earlier state.

#### Scenario: Rebrand active artifacts
- **WHEN** the Arnesto identity is applied
- **THEN** current documentation and executable configuration SHALL use Arnesto
- **AND** historical `thoughts/` records SHALL remain unchanged unless a stale
  instruction in them is still operational

### Requirement: Gated and verifiable transition
The transition SHALL begin from a clean, synchronized source revision and SHALL
provide a verified rollback for each external mutation.

#### Scenario: Advance a migration gate
- **WHEN** a local preparation, remote switch, archival action, or physical move
  is attempted
- **THEN** the preceding gate's checks SHALL have passed
- **AND** unrelated worktree changes SHALL have been consolidated separately
- **AND** the rollback target and verification command SHALL be recorded
