---
name: codex-model-routing
description: Choose cost-efficient Codex/OpenAI models (Astra, Sol, Terra, Luna), reasoning effort (Light/Low, Medium, High, Extra High/xhigh, Max, Ultra), and Fast mode. Use when the user asks for model routing, effort selection, consumption optimization, spending analysis, or whether Fast is worthwhile in Codex. Do not activate for ordinary programming without a routing, cost, model, or effort request, or for routing other providers.
metadata:
  category: tool-reference
  pattern: tool-wrapper
  owner: engineering
  status: active
  review_cycle_days: 60
  benchmark_after_model_update: true
---

# Codex Model Routing

Recommend the least expensive route likely to produce an accepted result.
This is an on-demand advisory policy for Codex/OpenAI only. Preserve existing
model-routing criteria for Claude, Gemini, Hermes, OmniRoute, OpenCode, and
other providers. Do not change global configuration, model defaults, symlinks,
hooks, or MCPs as part of a recommendation. A recommendation is not evidence
that the active model, effort, or Fast setting changed.

## Choose a route

1. Identify the deliverable, acceptance check, ambiguity, risk, dependencies,
   and value of reduced latency. Use supplied context; ask only when a missing
   constraint materially changes the choice.
2. Select a model from the policy below. Terra Medium is the default
   recommendation, not a configuration change or an obligation to use Terra
   for a clearly harder task.
3. Select effort separately from Fast. Explain the cheapest plausible route
   and the evidence that would justify escalation.
4. Return the model, effort, Fast on/off, brief reason, acceptance check, and
   stop/escalation condition. For a spending review, also report measurement
   gaps and a small comparison plan.

| Work | Starting model and effort |
|---|---|
| Clear, repeatable extraction, classification, transformation, or mechanical checks with defined input/output | Luna Light/Low; Medium if it needs several bounded steps |
| Everyday bounded implementation, documents, reporting, or analysis with tools | Terra Medium |
| Several sources, dependent steps, edge cases, or explicit trade-offs within a clear specification | Terra High |
| Open-ended diagnosis, architecture, cross-repository complexity, consequential delivery, or deep risk review | Sol Medium or High; High for difficult diagnosis or risk |
| Exceptionally difficult end-to-end workflows combining code, research, computer use, and sustained judgment | Astra Light/Low or Medium; justify why Sol is insufficient |

Do not infer that a more expensive model is better from spend per turn alone.
For the source rationale and measurement limits, read
[policy evidence](references/policy-evidence.md).

## Effort and continuity guardrails

Use Light/Low (`low`) for a clear transformation, Medium (`medium`) for a
normal verifiable unit, and High (`high`) for deeper dependent reasoning.
Extra High maps to `xhigh`; Max to `max`; Ultra to `ultra`. These are policy
labels, not a guarantee every model/client supports every combination.

- Never raise effort to repair a session that interrupts or loses continuity.
  Prepare a concise handoff with the goal, relevant files, verified facts,
  attempted fixes, remaining failure, and next acceptance check. Start a fresh,
  bounded unit with that handoff; use `AGENT_HANDOFF.md` when a file is useful.
- In the Terra recovery path, escalate that unit to Sol High only after the
  failure repeats in the fresh, clean unit. An initial interruption alone is
  insufficient. Distinguish model failure from missing access or broken tools;
  higher reasoning cannot repair those prerequisites. This recovery gate does
  not prevent selecting Sol initially for clearly complex or risky work.
- Extra High, Max, and Ultra each require an explicit reason, verifiable
  acceptance criterion, and checkpoint or stop condition. State why a cheaper
  route is insufficient; do not recommend them for vague exploration.
- Extra High is for a difficult, high-value, well-scoped question. Max is for
  one genuinely indivisible problem where depth outweighs cost and delay.
- Ultra is only for genuinely independent subproblems with separate verifiable
  deliverables. Identify the independent boundaries and integration check.
  Do not use Ultra for one deep problem or tightly dependent steps, and do not
  launch subagents merely because the user asked for a routing recommendation.

## Fast is a separate spending decision

Default to Fast off (Standard). Fast reduces latency and increases spending;
it is not greater reasoning effort and cannot substitute for it. Recommend
Fast only when the value of faster interactive iteration justifies its cost.
Record Fast separately from model and effort. Verify the current surcharge
before quoting a number; do not reuse a historical multiplier as a live price.

## Current prices and availability

For current prices, credit rates, Fast surcharges, model IDs, availability, or
supported effort combinations, consult official OpenAI documentation at answer
time. Start with the official links in [policy evidence](references/policy-evidence.md),
follow official replacements if needed, and state the date and relevant
plan/client limits. Use the active documentation-lookup workflow when available.
If verification is unavailable, say so and omit a definitive current quote.
Never treat the September 2026 documents as a permanent price list.

## Measure accepted outcomes

Compare at least three equivalent tasks per candidate route where practical.
Keep task scope and acceptance criteria comparable. Record:

| Task/unit | Accepted result | Retries | Human minutes | Credits | Model | Effort | Fast |
|---|---|---|---|---|---|---|---|
| Identifier and acceptance check | Yes/no, with evidence | Count | Review and correction time | Measured or estimated, with rate date | Actual model | Actual effort | On/off/unknown |

Count failed attempts in total cost. Prefer accepted results per credit and
per human minute over raw token or message counts. Keep historical consumption,
product limits, estimated equivalent credits, and reconciled billing separate.
Do not infer Fast from token counts or invent missing acceptance/time data.
Read [evaluation plan](references/eval-plan.md) when testing or revising this skill.
