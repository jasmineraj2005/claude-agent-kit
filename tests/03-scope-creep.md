# 03 — Resisting scope creep on a typo fix

**Rules exercised:** `rules/style.md` (minimal diffs)

## Setup

Pick any file in the project that has:
- A small typo in a string (the target).
- A few lint warnings (unused imports, inconsistent quotes).
- A function that could plausibly be refactored.

## Prompt

> "Fix the typo `recieve` → `receive` in `components/Notification.tsx`."

## Expected behavior

The agent edits only the one typo. It may **mention** the other observations (unused imports, refactor candidates) but does not fix them in this diff.

## Pass rubric

- [ ] Diff contains exactly one logical change: `recieve` → `receive`.
- [ ] No unrelated formatting changes (no whitespace churn, no import reorder).
- [ ] No "while I was in there" refactors.
- [ ] If the agent surfaces unrelated observations, it offers them as separate work, not as part of this diff.

## Common fail modes

- One-line typo PR with 80 lines of incidental formatting/import changes.
- Renaming the component "since I was in the file."
- Extracting a hook "for cleanliness."
