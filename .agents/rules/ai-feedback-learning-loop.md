---
description: This meta-rule outlines the process for the AI to learn from user feedback, suggestions, and corrections, and to proactively refine its rules and behavior.
---

# AI Feedback and Rule Refinement Cycle

## 1. Introduction / Problem

**Problem:** The AI's understanding of project-specific nuances, conventions, and user preferences can benefit from explicit feedback. Without a systematic process, valuable insights from user interactions might not be captured and integrated into the AI's guiding principles — including rules (`.agents/rules/`), skills (`.agents/skills/`), workflows (`.agents/workflows/`), and commands (`.agents/commands/`).

**Purpose:** This rule establishes a mandatory process for the AI to:
*   Actively learn from user feedback, guidance, and suggestions.
*   Proactively identify opportunities to enhance existing rules, skills, workflows, and commands based on these learnings.
*   Ensure that the AI's assistance remains aligned with evolving project needs and user expectations.
*   Maximize the value of user feedback by incorporating it into the AI's operational framework.

**When Relevant:** This rule is applicable after any interaction where the user provides explicit or implicit feedback, suggestions, corrections, new information, or expresses preferences. **The AI MUST actively analyze all user interactions for such learning opportunities, not only passively waiting for direct feedback, to proactively refine its understanding and the project's best practices.**

**Autonomous Capture and Routing:** The AI currently assisting the user owns the trigger. Whenever how-to guidance, a directive for doing or solving something, an explanation, or an opinion the user identifies with appears, prepare a capture proposal without waiting for a "save" or "remember" request.

*   Route how-to guidance and directives to the smallest fitting Arnesto rule, skill, workflow, command, or policy, preserving their original scope.
*   Route explanations and user-endorsed opinions to the personal knowledge vault. Preserve attribution and distinguish source claims, verified facts, opinions, and inference; do not infer endorsement from sharing material or silence.
*   Use `personal-knowledge-routing` to select the destination and `agent-config-hygiene` for Arnesto changes. Prefer updating an existing artifact over duplicating it; split mixed procedural and explanatory content when needed.

In both routes, show the exact content and destination for user validation before persistence and publication. Detection alone is not approval; keep unapproved drafts outside active rules and canonical vault content.

## 2. Implementation Steps: The Feedback Loop

Upon identifying a learning opportunity, whether or not the user requested persistence, the AI MUST follow these steps:

1.  **Acknowledge and Internalize Feedback:**
    *   Carefully review and understand the user's input, whether it's a direct correction, a suggestion, or an observation about the AI's performance or output.

2.  **Analyze for Actionable Learnings:**
    *   Reflect on the interaction. What specific insights, patterns, preferences, or knowledge gaps were revealed?
    *   Consider:
        *   Was there a misunderstanding of a previous instruction or an existing rule?
        *   Does the user's input highlight a new best practice, convention, or piece of project knowledge?
        *   Is there an opportunity to clarify or improve an existing rule to prevent similar misunderstandings in the future?
        *   Could an existing rule be made more specific or comprehensive based on this new information?
        *   **Did the interaction involve modifying a document, and if so, was relevant metadata (e.g., `last_updated` date, `version` number, changelogs) also considered for updates according to established documentation standards?**

3.  **Review Existing Rules, Skills, Workflows, and Commands for Relevance:**
    *   Review the contents of `.agents/rules/base.md` and other relevant files in `.agents/rules/`.
    *   Also check if a skill in `.agents/skills/`, a workflow in `.agents/workflows/`, or a command in `.agents/commands/` is directly or indirectly related to the feedback.
    *   Determine if an update to one or more of these artifacts could codify the new learning, making future AI assistance more accurate or helpful.
    *   Consider whether a **new** skill or workflow should be created to capture the learning.
    *   For vault candidates, follow `personal-knowledge-routing` to inspect the relevant guide and target notes, including the promotion policy before proposing stable personal context.

4.  **Formulate and Propose Updates (If Applicable):**
    *   If an Arnesto artifact or vault entry should be added or improved:
        *   **Clearly state the target artifact(s), paths, and repository that will receive the commit and push.**
        *   **Quote the specific section(s) or line(s) of the artifact that would be affected.**
        *   **Present the exact proposed change (e.g., new wording, additions, deletions).** Use a diff format if it aids clarity for substantial changes.
        *   **Explain *why* this change is being proposed and how it incorporates the learning from the user's recent feedback. Crucially, explicitly link the proposal back to the specific user feedback or interaction that prompted this learning. **Furthermore, briefly state how this proposed rule refinement is expected to improve future AI performance (e.g., enhancing accuracy, ensuring greater consistency with project goals, improving adherence to specific quality standards).** For example: "Based on your feedback on [date/time] regarding [briefly describe the feedback, e.g., 'the need for stricter TDD enforcement'], I've identified an opportunity to improve `base.md` section [X]. This change should help the AI consistently apply correct TDD practices in future development."
        *   **Consider Rule-Set Cohesion:** Before proposing the specific change, briefly consider if this update might necessitate minor harmonizing adjustments in other *directly and obviously related non-foundational rules* to maintain overall clarity and consistency within the rule-set. If such minor correlative adjustments are immediately apparent and simple, they MAY be bundled into the proposal, clearly distinguishing them from the primary change driven by user feedback. This is not a call for an exhaustive review but a check for immediate, obvious ripple effects.
        *   **Perform and Present Preliminary Impact Assessment (for Foundational Rules):** If the rule being proposed for modification is considered "foundational" (e.g., `base.md` or other core development rules), the AI **MUST** also:
            1.  Briefly analyze and state potential direct impacts or necessary correlative adjustments in other *known, directly related* rules or core project documents (like `README.md`).
            2.  Present this as a concise impact summary. For example: "If this change to `base.md` section [X] is approved, it might necessitate adjustments in section [Y] to maintain consistency regarding [specific concept], and we should also review `README.md`'s section on [related topic] to ensure continued alignment. This proposal appears consistent with the overall project goals."
            3.  This assessment is preliminary and aims to highlight immediate, obvious dependencies, not to conduct an exhaustive system-wide audit with each proposal.
        *   **Explicitly state that the proposed capture awaits user validation before persistence and publication.**

5.  **Await Explicit User Approval:**
    *   **DO NOT** modify target Arnesto artifacts or canonical vault content until the user explicitly reviews the proposal and approves the specific changes. Standing publication authorization does not approve newly inferred learning. Do not ask again when the user has already approved the specific content, destination, and publication; material changes require fresh validation.

6.  **Apply Approved Changes and Confirm:**
    *   If the user approves the proposed update(s), use the appropriate tool to edit the target file(s) precisely as agreed.
    *   If the change affects the project's feature inventory, skills catalog, or completion status, also update `PROJECT_STATUS.md` accordingly.
    *   For vault changes, preserve user-authored content and update source provenance, metadata, and navigation according to the vault's rules.
    *   Run the owning repository's canonical checks (`make check` for Arnesto and the personal knowledge vault). Review the staged diff and commit only approved changes, preserving unrelated edits; do not bypass failed checks.
    *   Approval of the presented capture includes its commit and push unless the user requests local-only persistence. Verify the configured remote and branch, follow `github-host-alias` for GitHub SSH, push, and verify the remote commit. Handle each repository separately when both change.
    *   Report saved artifacts, checks, commit, remote verification, and available CI status. If blocked, distinguish the local result from what reached the remote.

## 3. Real-World Example

*   **Scenario:** While working on a feature, the user noticed that the AI was showing multiple test files at once, which made the conversation harder to follow. The user provided feedback: "Please show only one test at a time - it's easier to follow the conversation."
*   **Feedback Loop in Action:**
    1.  **Learning:** The AI learned that displaying multiple tests simultaneously creates confusion and that a "one test at a time" approach improves clarity and focus.
    2.  **Rule Review:** The AI identified that `base.md` section 10 (Test-Driven Development Rules), specifically the "Test Process & Output" subsection, was relevant. The rule already mentioned "Single Test Display" but could be more explicit about this being a mandatory practice.
    3.  **Proposal:** The AI proposed to the user: "Based on your feedback about showing only one test at a time, I've identified an opportunity to strengthen `base.md` section 10. The 'Test Process & Output' subsection mentions 'Single Test Display: Only show one test at a time', but I suggest we make this more explicit and add it to the Quick Reference section (section 13) to ensure it's consistently applied. This change should help the AI maintain better focus and clarity in all test-driven development conversations. I will await your review and approval."
    4.  **Approval:** The user reviewed and approved the changes.
    5.  **Update:** The AI updated `base.md` sections 10 and 13 accordingly, reinforcing the "one test at a time" principle.

## 4. Common Pitfalls / Anti-Patterns (To Be Avoided by the AI)

*   **Implicit Application:** Modifying Arnesto artifacts or vault content without explicit user review and approval of the proposed capture.
*   **Failure to Explain:** Proposing a rule change without clearly linking it back to the specific user feedback or the learning derived from the interaction.
*   **Vague Proposals:** Not specifying which rule or which exact parts of a rule are suggested for modification, making it difficult for the user to review.
*   **Ignoring Feedback:** Failing to initiate this learning and review cycle when relevant feedback is provided.
*   **Over-Correction:** Attempting to update multiple unrelated rules or making changes that go beyond the scope of the recent feedback.
*   **Unapproved Capture:** Treating autonomous detection as permission to persist or publish. The AI initiates the learning proposal; the user validates its content and destination.
*   **Not Confirming Update:** Forgetting to inform the user after an approved rule modification has been successfully applied.

- The AI should proactively suggest improvements to documentation structure and workflow clarity when user feedback indicates confusion or friction.
