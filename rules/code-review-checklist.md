# Rule: Self Code Review Checklist

**Tier:** [DEFAULT] — run through this before claiming any non-trivial change is "done."

You are your own first reviewer. Spending 3 minutes on this checklist saves 30 minutes of back-and-forth.

## Pre-flight (run before opening for review)

- [ ] **Tests run green** — actually run them in this session (see `verification.md`).
- [ ] **Lint + typecheck pass** — clean output.
- [ ] **The diff is minimal** — no unrelated drive-by changes.
- [ ] **No debug leftovers** — no `console.log`, `print`, `pp`, `debugger`, commented-out code.

## Correctness

- [ ] Does the code do what the task asked, no more and no less?
- [ ] Are the edge cases handled — empty input, null/undefined, single item, max size, unicode, leading/trailing whitespace, negative numbers, zero, very large?
- [ ] Are the error paths handled at the layer that can act on them?
- [ ] Does it preserve invariants the rest of the system relies on?

## Tests

- [ ] Is there a test for the new behavior? (For new behavior, this should be "yes, and I watched it fail first.")
- [ ] Are the tests testing observable behavior, not implementation details?
- [ ] If this is a bug fix, is there a test that fails without the fix?
- [ ] Are tests deterministic — no `sleep`, no real network, no shared mutable state, no clock dependence without injection?

## Security

- [ ] Are inputs from outside (HTTP, file, env, queue) validated at the boundary?
- [ ] Are queries parameterized? Outputs escaped? Shell args quoted or arg-array'd?
- [ ] Are authentication and authorization both checked at every protected endpoint?
- [ ] No secrets in the diff?
- [ ] No PII/PHI in logs or fixtures?

## Performance (when it matters)

- [ ] No N+1 in the request path?
- [ ] Hot loops don't allocate unnecessarily?
- [ ] Any IO call has a timeout?
- [ ] Pagination on anything that could return >100 rows?

## Readability

- [ ] Names make the code read like English at this layer.
- [ ] Comments only where WHY is non-obvious.
- [ ] No dead code.
- [ ] Functions short enough to fit in your head.

## Dependency impact

- [ ] No new dep added without a real reason (see `dependency-management.md`)?
- [ ] If a dep was added: license OK, maintained, low transitive cost?

## Migration safety (for DB / API / config changes)

- [ ] Backwards-compatible with the currently-deployed version?
- [ ] Reversible — is there a documented rollback path?
- [ ] Tested on real-size data, not just a fixture of 3?

## Observability (for production-bound code)

- [ ] Are the right things logged at the right levels?
- [ ] Are trace IDs / request IDs propagated?
- [ ] Are sensitive fields redacted at the logging boundary?
- [ ] Is there a metric or alert for the new failure mode?

## Documentation (only if needed)

- [ ] If a public API/contract changed, are the consumers told?
- [ ] If a deploy step changed, is the runbook updated?
- [ ] (Default: no new docs — only update what exists, and only if behavior visibly changed.)

## After the checklist

Write a one-paragraph PR description that answers: **what changed, why, how to verify, what risks remain.** That's enough for a reviewer to do their job.

## When this checklist is overkill

For a one-line typo fix or a trivial doc change, this is too much. Use judgment — but err toward running it when the change touches behavior, security, or data.

## Why this rule exists

**Violation**

> "Done, PR open." Reviewer opens it: `console.log("here")` on line 3, no test for the new branch, the diff also reformats an unrelated file, one of the new endpoints has no auth check.

Every one of these would have been caught by 3 minutes of the checklist. Instead, 20 minutes of reviewer time and a back-and-forth.

**Compliance**

> "Done, PR open. Ran the checklist: tests green (`pytest -q` → 142 passed), lint clean, no debug leftovers (grep'd), auth confirmed at `routes/orders.py:34`, no PII in new logs, no new deps. One risk to flag: the migration is forward-only — rollback would require a manual restore."

The reviewer's job is now confirmation, not discovery. The risk is surfaced rather than buried.

**What ships without this rule**

A team where review is the QA step instead of a second opinion, where every PR has at least one "you forgot to remove the debug log" comment, and where reviewers' attention budget gets spent on mechanical issues instead of design feedback.

## Sources

- Synthesized from Google's "What to look for in a code review" + Anthropic's `simplify` skill + dwarvesf/claude-guardrails checklist patterns.
