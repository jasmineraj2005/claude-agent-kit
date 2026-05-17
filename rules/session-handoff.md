# Rule: Session Handoff

**Tier:** [DEFAULT] — apply when context fills, the user pauses for the day, or you're about to compact.

A session that ends without a handoff is a session that started over. Future-you (or the next agent / teammate) needs a tight pickup point.

## When to write a HANDOFF.md

- Context is approaching its limit (the harness suggests `/compact` or you notice degradation).
- The user signals end-of-session ("ok done for today", "let's pick this up tomorrow").
- You're about to spawn a fresh sub-agent that needs full continuity context.
- You hit a blocker that requires user/external input before you can continue.

## What goes in it

A handoff is short and concrete. ~30–60 lines. Aim for the next agent to be productive within 2 minutes of reading.

```markdown
# Handoff — <date> <short-task-name>

## Goal
<one-paragraph: what we're trying to accomplish>

## Status
- ✅ Done and verified: <list>
- 🟡 In progress: <what, where left off, why paused>
- ❌ Blocked: <what's blocking, who/what unblocks it>

## What I verified
- `<command>` → <result>
- `<command>` → <result>

## What I did NOT verify
- <list, with reason>

## Files touched
- `path/to/file.ext` — <what changed, in one line>
- ...

## Open questions for the user
- <question 1>
- <question 2>

## Next concrete step
<the single next action the next agent should take — be specific>
```

## How to use it on next session

- Read `HANDOFF.md` first, before any other context.
- Verify the "done and verified" items are still true (code may have changed since).
- Pick up at "next concrete step."
- Delete the handoff after you've fully resumed and verified — stale handoffs mislead.

## Before `/compact`

- Write the handoff *before* you compact, while you still have full context.
- Then compact, then re-read the handoff + `CLAUDE.md` + the active plan.

## Don't

- Don't make the handoff a brain dump. Concise > complete.
- Don't include code in the handoff that's already in the diff — reference the file path.
- Don't include private session reasoning that the next agent doesn't need.
- Don't fake "verified" items. If you didn't run it, say so.

## Sources

- mattpocock/skills — handoff
- obra/superpowers — finishing-a-development-branch
