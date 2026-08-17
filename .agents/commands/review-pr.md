<!--
installed-from: review-pr
command-name: review-pr
repo: arnesto
-->

# Review PR

**Command**: `/review-pr`

Provides an interactive, AI-assisted code review experience that helps reviewers understand changes, ask questions, provide feedback, and optionally implement fixes directly in the IDE.

## What This Command Does

This command orchestrates a comprehensive PR review workflow:
1. **Checks out the PR branch** locally
2. **Analyzes all changes** in the PR
3. **Reads the PR review document** (if available)
4. **Summarizes changes** at a high level
5. **Offers post-summary options** including file-by-file walkthrough
6. **Allows questions and comments** as you go
7. **Posts line-specific comments** via GitHub API
8. **Enables direct fixes** with optional sub-PRs
9. **Tracks review time** for metrics

## Workflow Steps

### Phase 0: Initialize Review
```
- Ask for PR number or URL
- Record review start timestamp
- Create review tracking: `.pr-review-metrics.json`
- Fetch PR details using gh CLI
- Checkout PR branch
- Pull latest changes
```

### Phase 1: Analysis & Summary
```
- Identify all changed files using git diff
- Read PR_REVIEW_DOC.md if it exists (or similar PR description document)
- Analyze complexity of changes
- Generate high-level summary:
  - What changed and why
  - Key files modified
  - Complexity concerns
  - Test coverage status
  - Blocking issues flagged by submitter
- Present summary to reviewer
```

### Phase 2: Post-Summary Options

After presenting the summary, offer these options:

```
=== Review Options ===

How would you like to proceed?

1. **File-by-file walkthrough** - See each file's diff one at a time with "next" navigation
2. **Show all diffs at once** - Display all changes in one view
3. **Jump to specific file** - Go directly to a file of interest
4. **Ask questions first** - Discuss the changes before diving in
5. **Post a general comment** - Add a PR-level comment

Choose option (1/2/3/4/5):
```

### Phase 3: File-by-File Walkthrough

When the user chooses the file-by-file walkthrough:

```
For each changed file (1 of N):
  - Show file path, lines added/removed
  - Display summary of changes in that file
  - Show the diff with syntax highlighting
  - Wait for user input before proceeding

User can respond with:
  - "next" - Move to next file
  - "skip" - Skip to next file without commenting
  - "comment [line#] <message>" - Add line-specific comment
  - "question" - Ask about this file
  - "fix this" - Propose or implement a fix
  - "show full" - Show full diff without truncation
  - "done" - Exit walkthrough and go to completion
```

Example walkthrough:

```
=== File 1 of 16: src/services/auth_service.py ===

Summary: Added OAuth2 authentication with token refresh logic.

Key changes:
- New authenticate() method with retry logic
- Token caching with configurable TTL
- Error handling for network failures

Lines: +145 / -23

[Diff displayed here...]

---
Options: next | skip | comment [line#] <message> | question | fix this | done
```

### Phase 4: Line-Specific Comments

When posting line-specific comments, use the GitHub API with this format:

```bash
# Get the latest commit SHA
SHA=$(gh pr view <PR#> --json headRefOid --template '{{.headRefOid}}')

# Create a JSON file with the review
cat << EOF > /tmp/review.json
{
  "commit_id": "$SHA",
  "body": "Review comment",
  "event": "COMMENT",
  "comments": [
    {
      "path": "path/to/file.py",
      "line": 42,
      "side": "RIGHT",
      "body": "Your comment here"
    }
  ]
}
EOF

# Post the review with inline comments
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo}/pulls/{pr_number}/reviews \
  --input /tmp/review.json
```

**Key parameters:**
- `path`: Relative file path from repo root
- `line`: Line number in the file (as shown in the diff)
- `side`: Use `RIGHT` for the PR branch (new code), `LEFT` for base branch
- `body`: The comment text (supports markdown)

**Multi-line comments:** Add `start_line` and `start_side` for ranges:
```json
{
  "path": "file.py",
  "start_line": 10,
  "start_side": "RIGHT",
  "line": 15,
  "side": "RIGHT",
  "body": "This entire block needs refactoring"
}
```

### Phase 5: General Feedback Management
```
When reviewer has a general comment:
  - Capture the comment text
  - Offer to rephrase for clarity/succinctness
  - Preview the comment
  - Post using GitHub CLI:
    gh pr comment <PR#> --body "..."
  - Track comment in review metrics
```

### Phase 6: Fix Implementation (Optional)
```
When reviewer requests a fix:
  - Discuss implementation approach
  - Offer options:
    a) Suggest changes for submitter
    b) Implement fix directly
    c) Create sub-PR to the branch
  
If implementing directly:
  - Make the changes
  - Run tests (if applicable)
  - Commit changes
  - Push to branch OR create sub-PR
  - Document fix in review metrics
```

### Phase 7: Manual Testing (Optional)
```
When reviewer wants to test:
  - Identify the feature/change to test
  - Provide step-by-step testing instructions
  - Offer to set up test environment
  - Run any necessary build/test commands
  - Document test results
  - Add testing notes to review
```

### Phase 8: Review Completion
```
- Summarize review findings
- Show all comments made (with file and line numbers)
- Show all fixes implemented
- Calculate review duration
- Offer to:
  a) Approve PR (gh pr review --approve)
  b) Request changes (gh pr review --request-changes)
  c) Comment only (gh pr review --comment)
- Save metrics to .pr-review-metrics.json
```

## Interactive Commands During Review

While walking through changes, reviewer can use these commands:

- **"next"** - Move to next file
- **"skip"** - Skip current file
- **"comment [line#] <message>"** - Add a line-specific comment
- **"comment <message>"** - Add a general comment on current file
- **"question"** - Ask a question about current code
- **"fix this"** - Request or implement a fix
- **"test this"** - Get manual testing instructions
- **"show tests"** - View related test changes
- **"show context"** - See more surrounding code
- **"show full"** - Show complete file diff without truncation
- **"complexity"** - See complexity metrics for current file
- **"summary"** - Re-show the high-level summary
- **"done"** - Complete the review

## Comment Rephrasing

When posting comments, the AI can help improve communication:

```
Original comment:
"This function is too long and does too many things"

Rephrased options:
1. Concise: "Consider breaking this function into smaller, focused functions"
2. Constructive: "This function handles multiple responsibilities. Could we extract the validation logic and data transformation into separate functions?"
3. Question-based: "Would it make sense to split this into smaller functions for better testability?"

Choose option or use original: [1/2/3/original]
```

## Line-Specific Comment Examples

### Example 1: Single line comment
```
User: comment 306 Please document when this fallback occurs and why it's acceptable

AI: Posting comment on line 306...

Posted to src/services/auth_service.py:306:
"Please document when this fallback occurs and why it's acceptable"
```

### Example 2: Comment with suggestions
```
User: comment 121 Consider extracting this into a separate calculator class

AI: Would you like me to rephrase this comment?

1. As-is: "Consider extracting this into a separate calculator class"
2. Constructive: "**Testability Suggestion:** Consider extracting this logic into a separate `LagBasedCalculator` class. This would make it easier to unit test the fallback behavior independently."
3. Question: "Would it make sense to extract this into a separate calculator class for better testability?"

Choose (1/2/3): 2

Posted to src/services/relevance_calculator.py:121
```

### Example 3: Multiple comments at once
```
User: I have feedback for lines 45, 78, and 120

AI: I'll help you add comments to each. Let's go one at a time:

Line 45 - What's your comment?
User: Add error handling for null response

AI: Posted to line 45. 

Line 78 - What's your comment?
User: This should be configurable via environment variable

AI: Posted to line 78.

Line 120 - What's your comment?
User: Consider adding a CloudWatch metric here

AI: Posted to line 120.

All 3 comments posted successfully!
```

## Sub-PR Workflow

When creating a sub-PR to fix issues:

```
1. Create new branch from PR branch:
   git checkout -b fix/[description]-[PR#]
   
2. Implement the fix
   
3. Run tests (if applicable)
   
4. Commit with descriptive message
   
5. Push and create PR:
   gh pr create --base [original-PR-branch] --title "Fix: [description]"
   
6. Link to original PR in description
   
7. Notify submitter
```

## Review Metrics Tracked

The `.pr-review-metrics.json` file tracks:

```json
{
  "pr_number": 123,
  "pr_title": "Add feature X",
  "reviewer": "reviewer-name",
  "start_time": "2025-10-30T10:00:00Z",
  "end_time": "2025-10-30T10:45:00Z",
  "duration_seconds": 2700,
  "files_reviewed": 8,
  "comments_made": 5,
  "line_comments": [
    {
      "file": "path/to/file.py",
      "line": 42,
      "body": "Comment text"
    }
  ],
  "questions_asked": 3,
  "fixes_implemented": 2,
  "manual_tests_performed": 1,
  "sub_prs_created": 1,
  "review_outcome": "approved|changes_requested|commented"
}
```

## Usage

Start a review by running:

```
/review-pr
```

Then provide the PR number when prompted:

```
Which PR would you like to review? (number or URL): 123
```

Or include it directly:

```
/review-pr 123
```

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Git configured with proper credentials
- Access to the repository
- Development environment set up for running tests/builds (if needed)

## Example Review Session

```
User: /review-pr 123

AI: Fetching PR #123...
    Checking out branch: feature/user-auth
    
=== PR #123: Add user authentication feature ===

Author: developer-name
Files changed: 12
+450 / -120 lines

=== High-Level Summary ===

This PR introduces user authentication with the following changes:
- New authentication module with login/logout functionality
- Session management middleware
- Updated API endpoints to require authentication
- Added unit and integration tests

Key files modified:
- src/auth/authenticator.py (new, 180 lines)
- src/middleware/session.py (new, 90 lines)
- src/api/routes.py (modified, +50/-20)
- tests/auth/test_authenticator.py (new, 120 lines)

Complexity concerns:
- Session middleware has high cyclomatic complexity

=== Review Options ===

How would you like to proceed?
1. File-by-file walkthrough
2. Show all diffs at once
3. Jump to specific file
4. Ask questions first
5. Post a general comment

User: 1

AI: === File 1 of 12: src/auth/authenticator.py ===

Summary: Core authentication logic with token management.
Lines: +180 / -0 (new file)

Key changes:
- User credential validation
- Token generation and verification
- Password hashing utilities

[Diff shown...]

---
Options: next | comment [line#] <message> | question | done

User: comment 45 Consider making the token expiration configurable

AI: Posting line comment to authenticator.py:45...
✓ Comment posted

Options: next | comment [line#] <message> | question | done

User: next

AI: === File 2 of 12: src/middleware/session.py ===
...

[After all files reviewed...]

AI: === Review Complete ===

Summary:
- Files reviewed: 12/12
- Line comments posted: 5
- Duration: 32 minutes

Comments posted:
1. src/auth/authenticator.py:45 - "Consider making the token expiration configurable"
2. src/auth/authenticator.py:89 - "Add error handling for expired tokens"
3. src/middleware/session.py:23 - "Consider refactoring to reduce complexity"
4. src/api/routes.py:78 - "Document the authentication flow"
5. tests/auth/test_authenticator.py:45 - "Add edge case for empty credentials"

How would you like to complete this review?
1. Approve (gh pr review --approve)
2. Request changes (gh pr review --request-changes)
3. Comment only (gh pr review --comment)
4. Continue reviewing

User: 1

AI: Submitting approval...
✓ PR #123 approved

Review metrics saved to .pr-review-metrics.json
```

## Customization for Your Repository

To adapt this command to your specific repository:

1. **Adjust PR document names**: Replace `PR_REVIEW_DOC.md` with your team's standard
2. **Configure test commands**: Update test running commands based on your project's test framework
3. **Set coding standards**: Reference your team's code style guidelines
4. **Define complexity thresholds**: Adjust what counts as "complex" based on your codebase
5. **Customize comment templates**: Add team-specific comment patterns or phrasing
6. **Integration hooks**: Add any CI/CD or tooling integrations your team uses

## Tips for Effective Reviews

1. **Use file-by-file for large PRs** - Easier to digest changes incrementally
2. **Use line-specific comments** - More precise feedback for the author
3. **Start with the summary** - Understand the "why" before diving into the "how"
4. **Review tests first** - Understanding test changes helps contextualize implementation
5. **Ask questions** - Use the interactive questions to clarify intent before suggesting changes
6. **Be constructive** - Use comment rephrasing to ensure feedback is helpful
7. **Test when needed** - Don't hesitate to request manual testing for complex features
8. **Track your time** - Use the metrics to improve review efficiency over time
