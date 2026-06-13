# Rule: Verification Before Completion

**Tier:** [ALWAYS] — for any claim that something is "done," "complete," "passing," "works," "fixed," or "ready."

## The rule

**No completion claims without fresh verification evidence in THIS message.**

If you have not run the verification command since your last user-visible message, you cannot claim the work is done. Not "should be done." Not "passing." Not "ready." Done means: you ran the command, you read the output, the output shows success.

## The protocol

For every "this is done" claim:

1. **Run the command.** The actual test suite, the actual lint, the actual build, the actual feature in the actual browser.
2. **Read the output.** Don't skim. The exit code can lie (many tools exit 0 with warnings); the output tells you what happened.
3. **Then claim the result.** Quote the relevant line of output if there's any chance the user will want to verify.

This is non-negotiable.

## What counts as verification

| Claim | Required evidence |
|---|---|
| "The tests pass" | Test runner output from this session showing N passed, 0 failed |
| "The build succeeds" | Build command exit 0 with no errors in output |
| "Types check" | `tsc --noEmit` / equivalent, clean output |
| "Lint passes" | Linter output, no errors |
| "The feature works" | Actually exercised the feature end-to-end (browser, curl, REPL) |
| "The bug is fixed" | The failing repro now passes |
| "It's deployed" | Deploy command succeeded AND a smoke check against the deployed URL |

## What does NOT count

- "It compiled" → compilation is not correctness.
- "The diff looks right" → reading code is not running code.
- "The agent reported success" → another agent's claim is a claim, not evidence.
- "The log says X" → a log line proves what was printed, not what is true. Trace it to the code or data that produced it.
- "I'm confident" → confidence is not evidence.
- A test you wrote in this session that has never been observed failing → see `tdd.md`.
- A passing test on a different branch / commit / environment → run it here.

## Rationalization blocklist

If you find yourself about to claim completion using any of these phrasings, **stop and run the verification first**:

- "Should work now."
- "Probably works."
- "I'm confident it passes."
- "Just this once."
- "The agent said success."
- "I'm tired of iterating."
- "A partial check is enough."
- "It worked last time."
- "The code is straightforward enough."
- "The test name implies the right behavior."

Every one of these is the sound of skipping a step. Don't.

## Diagnostic claims need evidence too

This rule is not only about "done." A root-cause claim — "the bug is X," "the writer wrote N words," "it failed because of the rate limit" — is also a completion claim about your *investigation*, and it needs the same discipline.

- A diagnosis built from logs or tool output alone is a hypothesis. It becomes a diagnosis only when you've confirmed it at the source (the code path, the stored data) — see `rules/debugging.md`.
- Do not present a plausible narrative as a verified report. Say "my current hypothesis is X (from the logs); I haven't confirmed it in code yet" rather than stating it as fact.
- When challenged, re-investigate from a new source. Restating the same log-based conclusion with more confidence is not verification.

## When verification is hard

- **Can't run it locally?** Say so explicitly. Don't substitute confidence for evidence.
- **UI work?** Open it in a browser. Click the thing. Look at the result. Type-checking and unit tests verify code correctness, not feature correctness.
- **Long-running test suite?** Run the relevant subset, name it, and tell the user what you didn't run.
- **External dependency down?** Stub it at the boundary, run the rest, and flag the unverified slice.

## Closing the loop

When you report a task complete, include:

- What you ran (`npm test`, `pnpm typecheck`, etc.)
- The relevant output line ("Tests: 47 passed, 0 failed")
- Anything you did NOT verify and why

## Why this rule exists

**Violation**

> "I've fixed the null-pointer bug. The function now handles missing inputs correctly."

No command was run. No output was read. The agent inferred correctness from reading its own diff.

**Compliance**

> "Fixed in `utils/parse.py:42`. Ran `pytest tests/test_parse.py::test_null_input -x -v`. Output: `1 passed in 0.04s`. The previously failing assertion `assert parse(None) == []` now succeeds."

Command stated, output quoted, the specific assertion that proves the fix is identified.

**What ships without this rule**

A PR claiming the bug is fixed, merged on the strength of the claim, breaks in production two days later because the fix path was never actually executed. The reviewer trusted the claim; the agent trusted its own optimism; the test was never run. This is the single highest-frequency failure mode in agent-generated code.

## Sources

- obra/superpowers — verification-before-completion skill
