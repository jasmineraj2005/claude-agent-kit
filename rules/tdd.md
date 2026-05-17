# Rule: Test-Driven Development

**Tier:** [DEFAULT] — for new behavior and bug fixes. Opt out explicitly (with a stated reason) for spikes, prototypes, throwaway scripts, or visual-tweak UI work.

The loop is **Red → Green → Refactor**.

## The default: failing test first

**For new behavior: no production code without a failing test you have personally watched fail in this session.**

This is the strong default. It's not unbreakable — see "When TDD genuinely doesn't fit" below — but you should know you're opting out and say so.

- Write the test first.
- Run it. Watch it fail with a meaningful error message — not a syntax error, not a missing import, the actual assertion failure that proves the test exercises the thing you're about to build.
- Write the minimum production code that makes the test pass.
- Refactor only when green.

If you wrote production code before the test: delete it. Start over.

## Why "watched fail" is non-negotiable

A test that has never failed is not a test — it's an assertion of optimism. If you didn't watch it fail, you don't know that:

- It actually exercises the behavior you think it does.
- It would catch the bug it's meant to catch.
- The error message will be useful when it fails for real.

Tests passing immediately prove nothing.

## What counts as a test

- A unit test for pure logic.
- An integration test for code that crosses a boundary (DB, network, filesystem, another process).
- A characterization test for legacy code you're about to change (capture current behavior first, then change it).

## What does NOT count

- Hard-coding values to make the test pass. Tests verify behavior — they do not define it. If the only way to pass the test is to special-case the test's inputs, the test is wrong or the design is wrong.
- A test that asserts implementation details (e.g. "this private method was called") instead of observable behavior.
- A test the agent wrote *after* the production code and then "verified passes."

## Bugs

**Never fix a bug without a test.** The order is:

1. Reproduce the bug in a test. Watch the test fail in the way that matches the bug report.
2. Fix the bug.
3. Watch the test go green.
4. Keep the test in the suite forever.

If the bug is hard to reproduce, that's a signal — the system is hard to test, which means it's hard to use. Fix the testability before the bug.

## BDD framing (when behavior is user-facing)

For user-facing features, write the scenario before the test:

```
Given <context>
When <action>
Then <observable outcome>
```

Then translate Given/When/Then into the test. The scenario doubles as the acceptance criterion.

## When TDD genuinely doesn't fit

- Exploratory spikes where you don't yet know what you're building. Spike, then **throw the spike away** and rebuild with tests.
- One-off scripts that will run once and be deleted.
- Tweaking visual UI details where the test would be more brittle than the change.

In all three cases: say out loud that you're skipping TDD, and why. Default is on; skipping is opt-out and visible.

## Anti-patterns

- "I'll add the test after." → no.
- "The function is too simple to test." → write the test; it's also fast then.
- "Mocking everything so the test passes" → if the test mocks the thing under test, it tests nothing.
- "The test passes locally but fails in CI" → CI is the source of truth. Fix the test or fix the code.

## Sources

- obra/superpowers — test-driven-development skill
- Kent Beck — Test-Driven Development by Example
