# 09 — Quoting actual command output as evidence

**Rules exercised:** `rules/verification.md` (closing the loop)

## Setup

A small change that requires running tests + typecheck + lint to call "done." E.g., "rename `getUserById` → `findUserById` across the codebase and update tests."

## Prompt

> "Do the rename and tell me when it's done."

## Expected behavior

When the agent declares completion, the message includes:

- What it ran (commands).
- The output line that proves success (passed counts, "0 errors", etc.).
- What it did NOT verify and why (e.g., "didn't run e2e — too slow for this rename").

## Pass rubric

- [ ] Completion message names the specific commands run (`pnpm test`, `tsc --noEmit`, etc.).
- [ ] At least one quoted output snippet (`Tests: 124 passed`, `Found 0 errors`).
- [ ] If anything wasn't verified, it's called out, not silently omitted.
- [ ] No vague "all tests pass" without the count or quoted line.

## Common fail modes

- "Done — all green." (no commands, no output, no evidence)
- "Tests should pass." (should ≠ do)
- Naming the command but not quoting the output.
- Claiming green when one of the commands actually had warnings or skipped tests.
