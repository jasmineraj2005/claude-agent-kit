# Rule: Refactoring

**Tier:** [WHEN USEFUL] — when restructuring code without changing behavior.

A refactor changes structure, not behavior. If behavior changes, it's a feature change or a bug fix. Don't conflate them.

## The contract

- **Tests pass before. Tests pass after. The test diff is empty** (or near-empty — only test renames / file moves).
- One refactor per commit. Never mix "refactor + feature" in a single commit — impossible to review, impossible to revert cleanly.
- Refactors are reversible. If you can't say "I would safely revert this," it's not a refactor.

## "Tidy first" sequencing (Kent Beck)

When you need to make a change and the code is hard to change:

1. **Tidy** in its own commit so the change becomes easy.
2. Make the now-easy change in a second commit.

Don't smuggle a refactor into a feature commit, even if "it's right there."

## For legacy code

- **Characterization test first.** Capture what the code currently does (even if it's wrong) before restructuring.
- Then restructure. Tests still pass = behavior preserved.
- Then fix the bugs the characterization tests revealed, with each fix landing as a separate "behavior change" commit.

## Safe refactor types (low risk, do these often)

- Rename for clarity.
- Extract method / inline method.
- Extract variable for a complex expression.
- Move a function to a better-named module.
- Split a long function into named helpers.
- Replace magic number with a named constant.

## Riskier refactors (Mikado-style)

When a refactor turns out to require N other refactors first:

1. Write down the **goal** ("make function X pure").
2. Try it. Note every prerequisite that blocks you ("oh, X reads from global Y").
3. Revert. Add each prerequisite to a Mikado graph.
4. Do the prerequisites in order, each landing green.
5. The original goal is now a small, safe change.

Trying to do a giant refactor in one go is how giant refactors fail and get reverted.

## When NOT to refactor

- "While I'm here" cleanups in a feature/bugfix branch. Open a separate PR.
- Right before a release — leave the code stable.
- When you don't understand it yet. Read it first. Refactoring without understanding produces bugs.
- When the tests are weak — improve the test coverage first, then refactor.

## When refactoring IS the task

- Define the goal in observable terms ("reduce cyclomatic complexity of X below 10," "remove the cyclic dep between A and B").
- Break it into the smallest sequence of green commits.
- Measure before and after.

## Sources

- Kent Beck — *Tidy First?*
- Martin Fowler — *Refactoring*
- Mikado Method
