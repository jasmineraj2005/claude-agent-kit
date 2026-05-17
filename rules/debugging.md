# Rule: Debugging — Systematic Root-Cause

**Tier:** [DEFAULT] — apply whenever something doesn't work as expected.

Debugging is not "try things until the error goes away." Symptom-removal is not the same as fix.

## The four-phase method

1. **Observe.** What did you actually see? The exact error message, the exact failing assertion, the exact line. Not your paraphrase — the literal text. Quote it if you're going to refer to it.
2. **Immediate cause.** What line of code produced the symptom? Open the file. Read the function. Read the call site.
3. **Trace up.** What sequence of states/calls led here? Walk the chain back until you find something that "shouldn't be possible." That's usually one level above the real bug.
4. **Original trigger.** What change, input, or condition made this start happening? `git log -p`, bisect, check recent deploys, check input shape.

A fix without phases 3–4 is a band-aid. It will come back.

## Reproduce first

- Get a deterministic repro before changing anything. If you can't reproduce, you can't verify the fix.
- Write the repro as a failing test (`rules/tdd.md`). Now you have a regression test for free.
- If the bug is timing/race-dependent, the repro might need a stress loop or seed-controlled randomness. That's still better than guessing.

## Change one thing at a time

- Don't apply three "candidate fixes" simultaneously. You'll never know which one worked, or whether one of them broke something else.
- If you're forced to bundle, write down which change is supposed to do what so you can verify each.

## Use the debugger / logs / repl

- A `pdb` / Chrome DevTools / `dlv` / `gdb` breakpoint usually beats adding print statements.
- If you do add prints/logs for debugging: tag them so you can grep them out (`// DEBUG:`), and remove all of them before claiming done.
- Don't leave `console.log("here")` in the diff. Ever.

## Anti-patterns

- **Whack-a-mole**: fixing each symptom as it appears without finding the cause.
- **Stack-overflow fix**: pasting the top-voted answer without reading why it works.
- **Try/catch the error away**: catching an exception and ignoring it because "it shouldn't happen."
- **Comment out the failing assertion**: making the test pass by deleting what it checks.
- **"It works on my machine"**: stop. Find the environmental difference. That difference IS the bug.
- **Restart and hope**: rebooting / clearing cache / `node_modules` nuke as a fix. That's a band-aid that hides a real bug — and one that will hit production where you can't restart.

## When you're stuck

- Explain the bug out loud (or to a sub-agent). Half the time you spot the cause while explaining.
- Re-read the error. Slowly. The relevant phrase is usually in there.
- Check the dumbest possible explanation first: typo, wrong file, wrong branch, stale cache, off-by-one, null/undefined, wrong type, timezone, encoding.
- Take a break if you've been going >30 min without progress. Returning fresh routinely beats grinding.

## Closing the loop

- The repro test stays in the suite forever as a regression guard.
- If the bug pattern could exist elsewhere in the codebase, grep for the pattern and check.
- Note the root cause in the commit body, not just the symptom.

## Sources

- obra/superpowers — systematic-debugging skill
