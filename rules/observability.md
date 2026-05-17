# Rule: Observability

**Tier:** [WHEN USEFUL] — for production-bound code, anything operating under SLOs, or anything that can fail silently.

You can't fix what you can't see. But you also can't be drowned in noise.

## Three pillars

- **Logs** — discrete events, free-text + structured fields. Use for "what happened to this one request."
- **Metrics** — aggregates over time. Use for "is the system healthy in general."
- **Traces** — request-scoped graphs across services. Use for "where did the time go on this request."

Different questions, different tools. Don't use logs for what metrics should answer (counting), don't use metrics for what logs should answer (one user's specific failure).

## Logging

- **Structured only.** JSON or key=value. Never `console.log("user " + id + " did " + action)`.
- **Required fields on every log line:** timestamp, level, service, request_id (or trace_id), env. Add user_id / tenant_id when applicable.
- **Levels:**
  - `ERROR` — broken; someone needs to look.
  - `WARN` — surprising but recoverable; might need to look.
  - `INFO` — normal lifecycle events worth keeping (started, finished, decision branches).
  - `DEBUG` — detail for diagnosing; off in prod by default.
  - `TRACE` — firehose; on only when targeted.
- **Don't log every line of business logic.** Log decision points and boundaries.
- **Don't log secrets, tokens, full session IDs, PII, PHI, payment data.** Redact at the logging boundary, not at each call site. See `data-and-pii.md`.
- **Don't `log.error("error")`.** Include the actual error, the operation, and the relevant inputs (redacted as needed).

## Trace propagation

- Propagate `trace_id` / `span_id` across every async boundary, queue handoff, and outbound request (W3C `traceparent` header for HTTP, equivalent for your stack).
- A request that "disappears" mid-trace is harder to debug than one that fails loudly.
- Use the framework's context propagation primitives (Node `AsyncLocalStorage`, Go `context.Context`, Python `contextvars`). Don't pass `trace_id` as an explicit arg through 14 layers.

## Metrics

- **Latency** — track p50/p95/p99, not just average. Averages hide tail pain.
- **Error rate** — by endpoint, by error class.
- **Saturation** — queue depth, connection pool usage, CPU/mem of the actually-busy components.
- **Business metrics** — successful operations, not just system health.
- **RED method** for services: Rate, Errors, Duration. **USE method** for resources: Utilization, Saturation, Errors.

## Alerts

- Every alert needs a runbook link in its definition. An alert with no runbook is an alert that pages someone who doesn't know what to do.
- Alert on symptoms users notice, not internal causes. `error_rate > 1%` alerts; `cpu > 80%` is noise.
- Avoid alert fatigue. If an alert has fired 50 times this month and nothing was done, delete it or fix the underlying issue.

## When adding a feature

- Add at least one metric for the new behavior (count, latency, error rate).
- Add log entries at start, end, and decision points — not in inner loops.
- If the feature is on the request path, make sure the request_id flows through it.
- If it can fail silently, add a metric for the silent-failure case.

## Don't

- Don't log full payloads "just in case" — storage cost + privacy risk.
- Don't put `try { ... } catch (e) { log(e); }` everywhere. Catch at the boundary that can act; let errors propagate.
- Don't `log.info` from a hot loop. Sample or aggregate.
- Don't ship a feature with no observability and add it later. Later doesn't come.

## Sources

- Distributed Systems Observability (Cindy Sridharan)
- OpenTelemetry conventions
- Google SRE book — RED / USE / SLO chapters
