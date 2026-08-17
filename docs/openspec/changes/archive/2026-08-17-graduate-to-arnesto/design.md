## Context

The repository began as a fork of Eduardo Ferro's twelve-commit
`augmentedcode-configuration` project and now contains 151 commits, 139 of them
authored under the user's identities. It is the canonical source for a personal
agent harness spanning rules, skills, durable planning, OpenSpec, tool adapters,
Codex, Hermes, and OmniRoute.

GitHub still records the repository as a public fork. The current fork is about
1.9 MB, has fourteen stars, and has one child fork. GitHub's self-service
leave-network path is therefore unavailable, and documented detach paths lose
repository metadata. Locally, twenty-six managed symlinks target the absolute
checkout path, but most consumers enter through the stable `~/.agents` link.
Only eight tracked files outside historical `thoughts/` records refer to the
current repository name.

The worktree also contains a separate Hermes safe-update change. That work must
be validated and consolidated independently before migration changes are
published or remote state changes.

## Goals / Non-Goals

**Goals:**

- Give the harness the durable public identity **Arnesto**.
- Establish a standalone GitHub repository without deleting the current fork.
- Preserve complete Git provenance and explicitly acknowledge the origin.
- Make setup insensitive to the checkout directory name.
- Keep all configured clients working throughout the transition.
- Separate remote identity, repository branding, and physical path changes so
  each can be verified and rolled back independently.

**Non-Goals:**

- Rewriting Git history or removing Eduardo Ferro's commits.
- Rewriting historical research solely to replace the old name.
- Combining Codex, Orca, Hermes, or OmniRoute runtime directories.
- Moving credentials, sessions, databases, local trust state, or mutable client
  configuration into the repository.
- Deleting the current fork or its child fork.
- Requiring the physical checkout directory to be renamed in the first rollout.

## Decisions

### 1. Graduate to a new standalone repository

Create an empty `saski/arnesto` repository and mirror the accepted source
history into it. Verify that GitHub reports `fork: false` and that `main` matches
the source revision before switching the local `origin`.

This is preferred over detaching or deleting the fork because it is reversible
and preserves the current repository's stars, child fork, and public history.
Renaming the existing fork alone was rejected because it would remain in the
upstream network.

### 2. Preserve the current fork as a legacy pointer

After Arnesto is independently usable, add a concise migration pointer to the
current fork and archive it. Keep the archive rather than reusing or deleting
the old repository name. Record the original project and author in Arnesto's
README or a small provenance section.

GitHub-hosted settings are not Git objects. Before archival, inventory branch
rules, Actions permissions, variables, secrets, environments, webhooks, topics,
and repository description. Recreate only settings that the new repository
actually needs.

### 3. Make the script location the default root

`setup-symlinks.sh` will derive its directory from `BASH_SOURCE[0]` and use that
as `REPO_DIR` unless the caller provides an override. Validation of `~/.agents`
will compare the link target with `$REPO_DIR/.agents`, not with a substring
containing the legacy name.

A behavior-level test will copy or invoke the setup contract from an arbitrary
checkout name and prove that the legacy name is not required.

### 4. Keep remote and physical migrations separate

The first rollout changes the canonical remote and public branding while the
checkout remains at `/Users/saski/Code/augmentedcode-configuration`. This keeps
all current absolute links valid and requires no client restart solely for the
remote change.

The physical move to `/Users/saski/Code/arnesto` is a later, optional gate. If
performed, create a temporary legacy-path symlink immediately after the move,
rerun setup from the new checkout, update active external references, validate
all clients, and then remove the compatibility link.

### 5. Update active references, not historical records

Rebrand README, repository rules/status, active skills, setup defaults, Cursor
management guidance, and the repository inventory. Update operational external
consumers in Codex trust state, Hermes guidance, MyBroworld, net-art-studies,
and the personal knowledge vault when the physical path changes.

Historical plans and research keep the name under which they were written.

### 6. Use small publication gates

The transition uses independent commits and verification points:

1. Consolidate the current unrelated Hermes and rule changes.
2. Commit the OpenSpec contract and path-independent setup.
3. Run `make check` and publish that preparation to the current remote.
4. Mirror the accepted revision to Arnesto and verify repository identity.
5. Switch local `origin`, rebrand active artifacts, run checks, and publish.
6. Add the legacy pointer and archive the old fork.
7. Decide separately whether to rename the physical checkout.

## Risks / Trade-offs

- **New repository starts without stars and child forks** → preserve and link
  the archived fork rather than deleting it.
- **Git mirror does not copy GitHub settings** → inventory and selectively
  reproduce required settings before switching the canonical remote.
- **Absolute symlinks break during a physical move** → defer the move and use a
  temporary compatibility path when it happens.
- **Two repository identities can confuse contributors** → use one explicit
  canonical marker in Arnesto and one migration pointer in the legacy fork.
- **Historical references inflate rename scope** → exclude non-operational
  `thoughts/` records from mechanical replacement.
- **Dirty work can be accidentally mixed into migration commits** → require a
  clean synchronized gate and stage explicit paths only.
- **Archival prevents normal writes to the old fork** → archive only after the
  new remote, CI, clone, and harness validation pass; unarchive is the rollback.

## Migration Plan

1. Validate and separately commit the current pending work.
2. Implement and test checkout-name-independent setup.
3. Validate and publish the OpenSpec contract and local preparation.
4. Create `saski/arnesto` as an empty standalone public repository.
5. Mirror the source, confirm `fork: false`, compare `main` revisions, and
   reproduce required GitHub settings.
6. Change the local `origin` to Arnesto and retain the legacy fork as an
   optional `legacy` remote during the observation period.
7. Apply active rebranding and provenance documentation, run canonical checks,
   and publish Arnesto.
8. Add the migration pointer to the old fork and archive it.
9. Evaluate the optional physical path migration in a fresh task/session.

Rollback before archival is a remote URL reset to the legacy fork. Rollback
after archival additionally unarchives the fork. A physical-path rollback uses
the temporary legacy-path compatibility link until setup is regenerated.

## Open Questions

- Whether the old fork should be archived immediately after Arnesto passes CI
  or after a short observation period.
- Whether GitHub-hosted branch rules or Actions settings exist that cannot be
  inspected without renewed GitHub API authentication.
- Whether the physical checkout should ever be renamed, given that the public
  identity can change without operational benefit from moving it.
