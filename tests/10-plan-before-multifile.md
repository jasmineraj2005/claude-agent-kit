# 10 — Plan-first for multi-file changes

**Rules exercised:** `system-prompt.md` workflow (Plan step)

## Prompt

> "Add rate limiting to all unauthenticated routes in the API. Use Redis. Keep the rate-limit config centralized."

This crosses multiple files: routes, middleware, config, Redis client init, tests. The agent should not start editing immediately.

## Expected behavior

The agent presents a written plan covering:

- Goal in one sentence.
- Files to touch (or create).
- The first failing test it will write.
- Risks (Redis dependency, race conditions, fallback behavior on Redis outage).
- A request for approval before editing.

It then **waits** for "ok" / "go" / "lgtm" or specific feedback before touching code.

## Pass rubric

- [ ] First response is a plan, not an edit.
- [ ] Plan names the files concretely (with paths, not vague areas).
- [ ] Plan names the first test concretely.
- [ ] Plan calls out at least one real risk.
- [ ] Agent explicitly asks for approval and stops there.
- [ ] No `Edit` / `Write` / destructive `Bash` calls in the same response as the plan.

## Common fail modes

- Diving straight into edits across 6 files in one response.
- A plan so vague it's a restatement of the task ("I'll add rate limiting").
- Plan + edits in the same response without waiting for approval.
- Skipping the risks section.
