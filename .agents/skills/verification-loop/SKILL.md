---
name: verification-loop
description: Verify work with repository checks and report local and target-environment results separately.
origin: ECC
license: MIT
---

# Verification Loop Skill

Verify work with the repository’s checks and report the evidence needed for the requested outcome.

## When to Use

Invoke this skill:
- After completing a feature or significant code change
- Before creating a PR
- When you want to ensure quality gates pass
- After refactoring

## Verification Phases

Use the repository's documented validation entry points and installed tools. Capture exit status and relevant output for each executed check. Report unavailable or unexecuted checks as such.

1. Build using the project’s canonical build command when the change affects a build.
2. Run the configured type checker and linter where applicable.
3. Run focused tests first. Run the appropriate broader suite and use the repository’s coverage policy where it has one.
4. Use the project's security checks and inspect the affected changes for accidental secrets. Report the location and type of finding without printing credential values.
5. Review the actual change against its correct base. Look for unintended changes, missing error handling, and uncovered edge cases.

## Target Acceptance

When the requested outcome requires an installed or deployed change, report target-environment verification separately from local checks. Record the environment, the version or commit if known, the executed check, and the observed result. A passing local suite, review, merge, or release does not establish that the change works in the target environment.

Report `VERIFIED` or `FAILED` for a completed check. Use `NOT PERFORMED` with the specific blocker and next permitted check if it could not run. Use `NOT APPLICABLE` for local-only work. Verify or act on external environments within the user’s authorization.

## Output Format

After running all phases, produce a verification report:

```
VERIFICATION REPORT
==================

Build:     [PASS/FAIL/SKIPPED]
Types:     [PASS/FAIL/SKIPPED] (X errors)
Lint:      [PASS/FAIL/SKIPPED] (X warnings)
Tests:     [PASS/FAIL/SKIPPED] (X/Y passed, Z% coverage)
Security:  [PASS/FAIL/SKIPPED] (X issues)
Diff:      [scope reviewed and findings]
Target:    [VERIFIED/FAILED/NOT PERFORMED/NOT APPLICABLE]
Evidence:  [environment, version, result, or blocker]
Next:      [next permitted check, when applicable]

Overall:   [READY/NOT READY] for PR

Issues to Fix:
1. ...
2. ...
```

## Continuous Mode

For long sessions, run verification every 15 minutes or after major changes:

```markdown
Set a mental checkpoint:
- After completing each function
- After finishing a component
- Before moving to next task

Re-run the relevant checks.
```

## Integration with Hooks

This skill complements PostToolUse hooks but provides deeper verification.
Hooks catch issues immediately; this skill provides comprehensive review.
