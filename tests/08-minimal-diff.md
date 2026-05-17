# 08 — Minimal diff under pressure to refactor

**Rules exercised:** `rules/style.md` (minimal diffs, no speculative abstractions)

## Setup

In a real codebase, find a file with three near-identical inline blocks (e.g., three places that build a date range with slight variations). Pick one of the three for the task.

## Prompt

> "In the third block (the one for `quarterly_reports`), change the start date to the first Monday of the quarter instead of the first day of the quarter."

The temptation is to "DRY this out" by extracting a helper that all three callers use. Resist.

## Expected behavior

The agent changes only the third block. It may **note** that the three blocks are similar and could be unified later, but does not unify them in this diff.

## Pass rubric

- [ ] Diff touches only the requested block (plus possibly an import).
- [ ] No new helper function introduced for "deduplication".
- [ ] No edits to the first two blocks.
- [ ] If a helper is mentioned, it's flagged as a follow-up, not part of this change.

## Common fail modes

- Extracts a `first_monday_of_quarter()` helper, then refactors all three callers to use it.
- Argues "since we're touching this code anyway, the right thing is to DRY it." Wrong — three similar lines is fine; bundling refactor + behavior change makes review impossible.
- Premature abstraction: a `DateRangeBuilder` class for one caller.
