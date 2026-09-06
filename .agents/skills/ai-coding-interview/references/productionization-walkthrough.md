# Productionization walkthrough

Use this reference after the minimal solution is working and validated. The
candidate should explain likely production changes without implementing them
unless the interviewer explicitly requests code.

For each area, connect four elements:

1. the risk in the current solution;
2. the production change that could address it;
3. the behavioral invariant that must survive;
4. the trade-off or requirement that must be clarified.

## Persistence

- Move process-local state to a durable event ledger and durable aggregates.
- Make recording an accepted event and updating its aggregate atomic.
- Preserve accepted, duplicate, and conflict semantics across restarts.
- Select storage only after clarifying scale, consistency, latency, and
  operational constraints.

## Concurrency

- Replace process-local assumptions with durable uniqueness and atomic updates.
- Ensure concurrent retries produce one accepted event and deterministic
  duplicate or conflict outcomes for the others.
- Prefer storage transactions or compare-and-set semantics over a lock that
  protects only one application process.
- Discuss partitioning or serialization only when expected contention and
  ordering requirements justify them.

## Event-ID retention

- Identify that retaining every accepted ID forever creates unbounded state.
- Clarify the promised idempotency or retry window before proposing expiration.
- A TTL or time-partitioned deletion bounds storage but allows a retry after
  expiration to be counted again.
- Permanent idempotency requires durable retention or archival and its
  associated storage cost.

## Batch and memory limits

- Bound event count and payload bytes per request using agreed limits.
- Consider chunking, backpressure, and per-customer quotas when load requires
  them.
- Monitor event-ledger growth and customer-metric cardinality, not only Python
  object memory.
- Avoid inventing a numeric batch limit during the interview.

## Service limits and overload card

Use this short explanation only when the exercise includes ingestion, queues,
or downstream capacity. It is a production discussion, not implementation
scope for the timed solution.

- **Rate limiting** is admission control: permanently cap work per client or
  period to protect fairness, cost, or capacity.
- A **bounded queue** absorbs a temporary burst but has an explicit capacity;
  an unbounded queue merely turns excess load into growing latency and memory
  use.
- **Backpressure** is the downstream saturation signal propagated upstream so
  producers slow down. Throttling, delayed acceptance, and reduced queue
  consumption can be responses to that signal.
- **Load shedding** deliberately rejects or drops selected work when accepting
  it would endanger the system. Clarify which work is safe to reject and the
  response contract for callers.
- For retryable transient failures, use bounded exponential backoff with
  **jitter** so clients do not synchronize into a new overload spike. Do not
  retry permanently invalid input.

For a concise walkthrough, say:

> "I would bound the queue and expose downstream saturation as backpressure.
> The API could rate-limit clients or shed non-critical load when that queue is
> full; callers would retry transient failures with exponential backoff and
> jitter. The idempotency contract must still ensure that retries do not count
> the event twice."

Then name the unconfirmed decisions rather than inventing them: queue capacity,
fairness policy, work that may be shed, retry budget, and the client-visible
error or retry contract.

## Metrics, logs, and traces

- Count accepted, duplicate, conflict, and invalid outcomes, with safe
  low-cardinality error dimensions.
- Measure batch size, processing latency, storage latency, retries, and
  infrastructure failures.
- Use structured logs with correlation identifiers while avoiding sensitive
  event payloads.
- Trace API, queue, worker, and storage boundaries only when those components
  exist in the proposed deployment.

## Failure and recovery

- Preserve idempotency under retries and at-least-once delivery.
- Use bounded retries with backoff for transient failures; do not retry
  permanently invalid events indefinitely.
- Keep event recording and aggregate mutation atomic, or provide a replayable
  ledger that can rebuild aggregates.
- Discuss dead-letter handling, backups, and tested restoration only in terms
  of the selected processing and storage model.

## Close the explanation

State which production decisions remain unconfirmed and why they were not
implemented in the timed exercise. A strong answer demonstrates awareness of
scale and failure modes while protecting the minimal working solution from
speculative architecture.
