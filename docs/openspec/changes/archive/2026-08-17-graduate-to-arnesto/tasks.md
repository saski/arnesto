## 1. Establish a Clean Migration Gate

- [x] 1.1 Validate the pending Hermes safe-update and universal-rule changes without modifying their scope.
- [x] 1.2 Commit and publish the pending work in reviewable commits separate from the Arnesto transition.
- [x] 1.3 Record the accepted source revision, current GitHub settings, active external references, and rollback remotes.

## 2. Make Repository Setup Portable

- [x] 2.1 Add a failing behavior-level contract proving setup does not require the legacy checkout name.
- [x] 2.2 Derive the default `REPO_DIR` from `setup-symlinks.sh` while preserving the explicit override.
- [x] 2.3 Validate `~/.agents` against the active `$REPO_DIR/.agents` target instead of a legacy-name substring.
- [x] 2.4 Run the focused setup and symlink contract tests from an arbitrary checkout name.

## 3. Publish Local Preparation

- [x] 3.1 Validate the `graduate-to-arnesto` OpenSpec artifacts.
- [x] 3.2 Run `make check` with the migration preparation included.
- [x] 3.3 Commit and push the OpenSpec contract and path-independent setup to the legacy remote.

## 4. Graduate to a Standalone Remote

- [x] 4.1 Create the empty public `saski/arnesto` repository without using GitHub's fork action.
- [x] 4.2 Mirror the accepted legacy revision and all source refs into Arnesto.
- [x] 4.3 Verify `fork: false`, matching `main` revisions, clone access through `github.com-saski`, and passing CI.
- [x] 4.4 Recreate only the required GitHub description, topics, Actions permissions, and branch rules.
- [x] 4.5 Change local `origin` to Arnesto and retain the current fork as a temporary `legacy` remote.

## 5. Apply the Arnesto Identity

- [x] 5.1 Rebrand the README as Arnesto with the public tagline, standalone clone URL, and Eduardo Ferro provenance.
- [x] 5.2 Update active repository, setup, routing, status, inventory, and skill references without rewriting historical `thoughts/` artifacts.
- [x] 5.3 Add or update deterministic contracts that reject operational dependence on the legacy repository name.
- [x] 5.4 Run OpenSpec validation and `make check`, then publish the rebranding to Arnesto.

## 6. Retire the Legacy Fork Safely

- [x] 6.1 Add a concise Arnesto migration pointer to `saski/augmentedcode-configuration` without merging it into Arnesto.
- [x] 6.2 Verify Arnesto clone, CI, remote, documentation, and harness setup before archival.
- [x] 6.3 Archive the legacy fork while retaining its stars, child fork, and public provenance.

## 7. Decide the Optional Physical Rename

- [x] 7.1 Re-inventory absolute local links and active external path consumers after the remote transition.
- [x] 7.2 Record whether the physical checkout rename provides enough benefit to proceed.
- [x] 7.3 If approved, move the checkout behind a temporary legacy-path compatibility link and regenerate all managed links from the Arnesto path. Not applicable because the rename was deferred.
- [x] 7.4 Update active external consumers, run client smoke checks, and remove the compatibility link only after no dependency remains. Not applicable because no physical move occurred.

## 8. Verify and Close the Transition

- [x] 8.1 Verify every requirement and scenario against repository, GitHub, and local wiring evidence.
- [x] 8.2 Run `openspec validate --all`, `setup-symlinks.sh validate`, and `make check` from the canonical checkout.
- [x] 8.3 Sync and archive the OpenSpec change after the remote transition and physical-path decision are complete.
