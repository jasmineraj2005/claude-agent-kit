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

## Sources

- obra/superpowers — verification-before-completion skill
