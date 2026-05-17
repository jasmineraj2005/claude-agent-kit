# CLAUDE.md

Project-specific instructions loaded into every Claude Code session in this repo. Based on `claude-agent-kit@v0.1` — rule tiers ([ALWAYS] / [DEFAULT] / [WHEN USEFUL] / [REFERENCE]) defined in `system-prompt.md` and `README.md`.

Keep this file under 200 lines, concrete, and verifiable.

## Project overview

<!-- Replace this section with: what this project is, who uses it, what the main pieces are. One paragraph max. -->

## Build, test, lint commands

<!-- Fill in the exact commands. Concrete > generic. -->

```
# Install
<install command>

# Run the app locally
<dev command>

# Tests
<test command>           # full suite
<single-test command>    # one file or pattern

# Lint / typecheck / format
<lint command>
<typecheck command>
<format command>
```

## Architecture (only the non-obvious parts)

<!-- Anything the agent could NOT figure out by reading the tree. Cross-cutting conventions, where the seams are, what's load-bearing. -->

## Code style

- <language-specific style choices — indentation, naming, import order>
- Prefer existing patterns in this repo over the agent's defaults.
- No comments unless the WHY is non-obvious.
- No new abstractions without a second concrete caller.

## Testing conventions

- TDD is required for new behavior. See `senior-eng-kit/rules/tdd.md`.
- Integration tests hit real services where possible (no over-mocking).
- Test files live in `<path>` and are named `<convention>`.
- A failing CI is a hard block — fix the root cause, never the test.

## Git workflow

- Branch from `<main-branch>`.
- Conventional commit prefixes: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- One logical change per commit. New commits, not amends.
- PRs require: green CI, one review, no merge conflicts.

## Forbidden actions

The following require an explicit, in-conversation ask from the user — do not do them on initiative:

- `git push --force` (any branch)
- `git reset --hard`, `git clean -f`, `git branch -D`
- `--no-verify`, `--no-gpg-sign`, or any hook/signing bypass
- `rm -rf` on anything outside a scratch directory
- Editing `.env*`, secrets files, or credentials
- Modifying CI config (`.github/workflows/`, etc.)
- Installing or removing dependencies
- Database migrations or destructive DB operations
- Pushing, merging, or commenting on shared branches/PRs
- Sending messages to external services (Slack, email, etc.)

## External resources

<!-- Where to look for things that aren't in this repo -->

- Issue tracker: <url>
- Design docs: <url>
- Monitoring/dashboards: <url>
- API docs: <url>

## When in doubt

- For **intent** ambiguity (what should this do?): ask.
- For **factual** ambiguity (does this file exist? what does this command output?): use tools.

A 10-second clarification on intent beats an hour of wrong work.

## Rules

Detailed rules live in `senior-eng-kit/rules/`:

- `tdd.md` — test-driven development discipline
- `verification.md` — the Iron Law of completion claims
- `git-safety.md` — destructive-action confirmation list
- `security.md` — secrets, injection, prompt-injection defense
- `style.md` — minimal diffs and change-scope discipline
