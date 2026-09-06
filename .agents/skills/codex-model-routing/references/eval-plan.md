# Evaluation and benchmark plan

Status: initial authored cases; no empirical model benchmark has been run.

Run each prompt with and without the skill in fresh contexts on the same model.
Record activation, recommendation, guardrail compliance, and the measurement
fields in SKILL.md. Test paraphrases in English and Spanish. Do not score
authored expected answers as observed model behavior.

| Prompt | Expected behavior |
|---|---|
| Choose a Codex model and effort to normalize 100 CSV rows with a fixed mapping and exact expected output. | Activate; Luna Low, Fast off; verify output against mapping. |
| Which Codex model and effort should implement one endpoint with a clear contract and acceptance test? | Activate; Terra Medium, Fast off; define acceptance check. |
| Choose Sol or Astra for a risky cross-repo incident with unclear root cause. | Activate; Sol High; reserve Astra for evidence of exceptional end-to-end difficulty. |
| Choose a Codex route for an exceptionally hard workflow spanning research, code, browser validation, and sustained judgment; explain why Sol is insufficient. | Activate; Astra Low/Medium only with the stated complexity justification and acceptance check. |
| Implement an endpoint with this contract and add an acceptance test. | Do not activate; ordinary coding without a routing request. |
| Select a Claude model for this task. | Do not activate; preserve non-OpenAI routing. |
| Terra interrupted once. Should I raise effort? | Activate; no increase; handoff and fresh bounded unit first. |
| Terra failed again in a clean bounded unit with a handoff; access and tools work. Which route now? | Activate; Sol High for that unit with a concrete acceptance check. |
| Use Max or Ultra to make this vague task better. | Activate; require reason and acceptance criterion; Max only if indivisible, Ultra only if independent subproblems are identified. |
| Should I use Extra High for this expensive investigation? | Activate; require a specific question, reason, acceptance criterion, and checkpoint. |
| Is Fast equivalent to High, and what does Fast cost today? | Activate; separate speed from effort; consult official OpenAI docs before quoting current costs. |
| Analyze Codex spend with unknown Fast and no accepted-outcome data. | Activate; report missing data, keep estimates separate from billing, make no quality ranking. |

Pass criteria: all negative cases remain inactive; all continuity and premium
effort guardrails hold; every recommendation states model, effort, Fast, reason,
acceptance, and escalation/stop condition. Prose should be concise and neutral.
Unsupported current-price claims or changes to runtime configuration fail.

Benchmark usefulness with at least three comparable real tasks per route,
including retries and human review. Compare accepted results per credit and
human minute. Classify keep/improve/monitor/retire; monitor until outcome data
exists, and retire if baseline consistently matches or beats the skill.
Review after model updates and at the next scheduled benchmark (2026-11-05).
