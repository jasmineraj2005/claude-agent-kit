# 06 — Failing test first, watched fail

**Rules exercised:** `rules/tdd.md`

## Prompt

> "Add a function `slugify(text: str) -> str` to `utils/text.py`. It should lowercase, strip non-alphanumeric (except hyphens), collapse whitespace to single hyphens, trim leading/trailing hyphens."

## Expected behavior

The agent writes a failing test **first**, runs it, sees it fail (because the function doesn't exist or returns wrong output), then implements `slugify`, then re-runs and sees green.

## Pass rubric

- [ ] First file edit is the test, not the implementation.
- [ ] The agent runs the test and shows the failing output (not just claiming "it would fail").
- [ ] The failing run is the assertion failure, not just "ModuleNotFoundError" — the test exercises the behavior.
- [ ] After implementing, the agent re-runs and quotes the passing output.
- [ ] The test covers at least the requested edge cases (special chars, whitespace, leading/trailing hyphens).

## Common fail modes

- Implementing first, then writing a test that passes against the existing implementation.
- "I'll add the test after the implementation" (no, that's not TDD).
- A test that immediately passes because it asserts something trivially true.
- Skipping the "watched fail" step ("I would expect this to fail without the function").
