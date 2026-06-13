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
- **Log-faith**: drawing a root-cause conclusion from log / console / tool output without tracing it to the code or data that produced it. Output is a claim, not proof.
- **Doubling down**: when challenged, re-reading the same evidence and re-asserting, instead of going to a new source of truth.
- **Narrative over diagnosis**: shipping a tidy, plausible story as a "report" before the actual root cause has been confirmed at the source.

## Evidence has layers — verify the diagnosis at its source

A log line, a console print, a tool result, another agent's summary — these are *claims about what happened*, not proof of the root cause. They tell you what was emitted, not what is true. Before you name a root cause, follow the evidence down to the source that cannot lie: the code that produced the output, the row actually written to the database, the file actually on disk.

- "The log says `wrote 1751 words`" proves the function printed that line. It does not prove the content was saved, was correct, or ever reached the user. Open the code path and confirm where that content actually goes.
- A green exit code, a "success" toast, a "queued" message — confirm the *effect*, not the *announcement*.
- If two layers disagree (the log says success, the queue is empty), the gap between them IS the bug. Go find it; don't pick the layer that fits your story.

Rule of thumb: you have not found the root cause until you've read the line of code (or inspected the data) that makes it inevitable. A plausible narrative built from logs is a hypothesis, not a diagnosis — never ship it as a "report."

## Hold the diagnosis loosely — especially under challenge

When the user, a teammate, or new evidence contradicts your conclusion, treat it as a signal your investigation was incomplete — not as something to explain away.

- Do NOT re-read the same evidence and restate the same conclusion with more confidence. Re-deriving the same answer from the same log twice is confirmation bias, not investigation.
- Go to a *different, more authoritative* source than the one you already used. If you concluded from logs, now read the code. If you concluded from code, now run it or inspect the data.
- "Are you sure?" is almost never a request for reassurance. It usually means the person can see something your investigation missed. Lower your confidence and dig — don't defend.

## When you're stuck

- Explain the bug out loud (or to a sub-agent). Half the time you spot the cause while explaining.
- Re-read the error. Slowly. The relevant phrase is usually in there.
- Check the dumbest possible explanation first: typo, wrong file, wrong branch, stale cache, off-by-one, null/undefined, wrong type, timezone, encoding.
- Take a break if you've been going >30 min without progress. Returning fresh routinely beats grinding.

## Closing the loop

- The repro test stays in the suite forever as a regression guard.
- If the bug pattern could exist elsewhere in the codebase, grep for the pattern and check.
- Note the root cause in the commit body, not just the symptom.

## Why this rule exists

**Violation**

> Error at `OrderSummary` line 34 reading a `name` property on an undefined value. Fix: wrap the access in an optional-chain guard. Tests pass, ship it.

The symptom is gone. The root cause (some upstream code is letting the order reach this component without a user attached) is untouched. The same bug will appear at the next access site and in adjacent components next sprint.

**Compliance**

> Same error. Traced up: `OrderSummary` is rendered from `OrderList`, which calls `fetchOrders`. Inspected `fetchOrders`: recently changed to a lighter projection that omits the user join. Real fix: restore the join or change the component contract explicitly. Added a regression test for the empty-user case and one for the projection shape.

The fix is at the source. The test prevents recurrence. The trace is documented so the next person does not repeat the investigation.

**What ships without this rule**

A codebase studded with optional-chain guards and silent catches around a real upstream bug nobody has named. Every new feature adds more guards. Performance suffers from defensive checks at every layer. The actual root cause never gets fixed because every report looks "already handled."

## Sources

- obra/superpowers — systematic-debugging skill
