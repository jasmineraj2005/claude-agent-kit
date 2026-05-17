# Rule: Code Style and Change Scope

**Tier:** [DEFAULT] — for every edit. Relax only when matching an explicit pre-existing style decision in the project.

## Minimal diffs

Change only what the task requires.

- A bug fix doesn't need surrounding cleanup.
- A new feature doesn't justify a refactor.
- A typo fix doesn't open the file for a "while I'm here" sweep.
- If you notice unrelated tech debt, name it in the response — don't fix it in this diff.

The smaller the diff, the easier it is to review, revert, and bisect.

## No speculative abstractions

- Three similar lines beats a premature framework.
- Don't introduce a helper for one caller.
- Don't introduce an interface for one implementation.
- Don't design for hypothetical future requirements.
- The right amount of complexity is the minimum needed for the current task.

## Edit, don't create

- Prefer editing an existing file over creating a new one.
- Never create files unless absolutely necessary for the goal.
- Never create `README.md`, `CHANGELOG.md`, or other documentation files unless the user explicitly asked.
- No "notes to self" files. No planning docs unless requested. Work from conversation context.

## Comments

**Default: no comment.**

Only add a comment when the **WHY** is non-obvious and the comment will not rot:

- A hidden constraint ("this must run before X because of Y")
- A subtle invariant ("relies on caller holding the lock")
- A workaround for a specific upstream bug, with a link
- A surprising behavior a careful reader would not guess

**Don't write comments that:**

- Explain WHAT the code does (well-named identifiers do that).
- Reference the current task, fix, or PR ("added for the auth flow", "fix for #123") — those belong in the commit message and rot as the code evolves.
- Restate the function name in prose.
- Mark removed code (`// removed in v2`) — that's what git is for.
- Are docstrings on every function regardless of complexity.

## Error handling

- Handle the errors that can actually happen, at the layer that can do something about them.
- Don't wrap every call in try/catch "just in case." If you can't recover, let it propagate.
- Don't catch and re-throw without adding information.
- Don't swallow errors silently. Ever.
- Fallbacks are a code smell unless the fallback path is itself tested.

## No dead code

- Don't leave commented-out code "in case we need it" — git has it.
- Delete unused exports, unused variables, unreachable branches.
- Delete `// TODO: remove this` code that's been there for more than one PR.

## Naming

- Names should make the code read like English at the layer it operates.
- Bad: `data`, `info`, `temp`, `obj`, `mgr`, `handler` (without context).
- Good: nouns for things, verbs for actions, adjectives for predicates (`isExpired`, not `expired`).
- A name that requires a comment to understand is the wrong name.

## Consistency

- Match the surrounding code's style, even if you disagree with it.
- If the codebase uses tabs, use tabs. If it uses snake_case, use snake_case.
- If you want to change a project-wide convention, that's a separate proposal, not a smuggled change.

## Refactors

- A refactor changes structure without changing behavior. If behavior changes, it's a feature change or a bug fix, not a refactor.
- A refactor needs the tests to pass before and after, with no changes to the tests.
- One refactor per commit. No mixed "refactor + feature" commits — they're impossible to review.

## Why this rule exists

**Violation**

> Task: "fix the typo in the button label." Diff: 1 line for the typo, 47 lines reformatting the surrounding file, 12 lines extracting a `useButtonLabel` hook "while I was in there."

The reviewer now has to read 60 lines and reason about three unrelated changes to approve a one-line fix. The refactor and the typo become coupled; reverting the typo means reverting the refactor.

**Compliance**

> Task: "fix the typo in the button label." Diff: 1 line for the typo. Response: "Fixed. I also noticed the formatting in this file is inconsistent and there's a candidate `useButtonLabel` hook extraction. Want me to do either in a separate PR?"

The fix is reviewable in 5 seconds. The drive-by observations are surfaced for the user to schedule, not smuggled in.

**What ships without this rule**

A `git blame` history where every line traces to a 200-line "minor fix" commit, making it impossible to figure out which change introduced a regression. Reverts become surgery. Reviews become rubber-stamps because the diffs are too big to actually read.

## Sources

- Anthropic prompting best practices
- Kent Beck — Tidy First?
