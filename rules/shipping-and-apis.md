# Rule: Shipping & API Design

**Tier:** [REFERENCE] — pull this in when shipping user-visible changes or designing/changing an API.

Once a change is in users' hands, you don't get to take it back without cost. Plan for that before, not after.

## Shipping discipline

### Before merge

- **Rollback plan exists** for any user-visible change. "If this breaks, here's the one command / one toggle / one revert that undoes it."
- **Feature flag for risky changes.** Off by default, enabled for internal users first, then a small %, then 100%.
- **Migration plan for stateful changes.** Schema changes are forward-compatible (old code can read new data) AND backward-compatible (new code can read old data) for at least one release cycle.

### At deploy

- **Canary or staged rollout** when the blast radius is large.
- **Smoke test post-deploy.** Hit the actual deployed URL. A green CI doesn't mean the deploy succeeded.
- **Watch the dashboards** for the first ~15 min after a meaningful deploy. Error rate, latency, saturation.

### After deploy

- **On-call awareness.** If you ship something risky, tell the on-call. They'll appreciate not being surprised at 3am.
- **Runbook link** on any new alert/metric so the next person paged knows what to do.

### When something breaks

1. **Restore service first** (revert, flag-off, traffic shift). Diagnose later.
2. Communicate: status page, internal channel, customer-facing if needed.
3. Don't deploy a fix-forward unless you're sure it doesn't make things worse. A revert is almost always safer.
4. Write the post-mortem. Blameless, focused on systemic causes, with action items that are actually assigned and tracked.

## API design

### Versioning

- Pick one strategy (URL `v1/`, header `Accept: application/vnd.app.v1+json`, query `?version=1`) and stick to it.
- **Additive-only changes to live APIs.** New fields, new endpoints, new query params — fine. Removing or renaming — breaking, needs a new version.
- Deprecation: announce → dual-run → remove. Minimum window depends on your audience (internal: weeks; partners: months; public: years).
- Send `Deprecation:` and `Sunset:` headers on deprecated endpoints.

### Request / response shape

- **Idempotency keys** on any mutation that can be retried (payments, sends). Same key + same body = same outcome.
- **Pagination** on every list endpoint. Cursor > offset for large or live datasets. Always include a default and max limit.
- **Error envelope is consistent.** `{ "error": { "code": "...", "message": "...", "details": {...} } }` or whatever your house style is — same shape everywhere.
- **Status codes mean what they mean.** 200/201/204 for success classes, 400 for client error, 401 not authenticated, 403 authenticated but not allowed, 404 not found, 409 conflict, 422 unprocessable, 429 rate-limited, 5xx server. Don't return 200 with `{"error": ...}` body.

### Contract testing

- Consumer-driven contract tests (Pact, etc.) between services.
- For public APIs, an OpenAPI / GraphQL schema is the contract; treat schema diffs as breaking-change reviews.

### Don't

- Don't expose internal IDs in URLs if they leak business info (sequential IDs leak count, etc.). Use opaque IDs.
- Don't return different shapes for the same endpoint based on the caller.
- Don't put auth tokens in URL paths or query strings (they end up in logs).
- Don't make breaking changes "because it's only used internally." That's how you learn what depends on it.

## Sources

- Google API Design Guide
- Heroku HTTP API Design Guide
- *Site Reliability Engineering* (Google) — release engineering, post-mortem culture
