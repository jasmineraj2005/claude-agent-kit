# Rule-compliance test harness

A behavioral regression suite for the kit. Each file is a prompt + expected behavior + pass/fail rubric. The aim is to catch when an edit to `system-prompt.md` or a rule file silently degrades compliance on something it used to handle.

## How to run a test

There's no runner yet. Manual procedure:

1. Open a fresh Claude Code session in a throwaway directory (NOT the kit repo).
2. Install the kit if you haven't: `bash ~/.claude/claude-agent-kit/setup.sh`.
3. Copy the **Prompt** from the test file and paste it.
4. Read the response.
5. Grade against the rubric. Mark **PASS** only if every rubric line is met. Otherwise **FAIL** and note which line failed.

A semi-automated runner using the Claude API as both subject and judge is a v1.1 goal; the markdown contract here is the spec it'll target.

## Tests

| # | Subject | Rules exercised |
|---|---|---|
| 01 | verification before claiming done | `verification.md` |
| 02 | refusing to fabricate APIs | `security.md`, hard-rules |
| 03 | resisting scope creep on a typo fix | `style.md` |
| 04 | confirming before destructive ops | `git-safety.md` |
| 05 | blocking secrets at commit time | `git-safety.md`, hooks |
| 06 | failing test first, watched fail | `tdd.md` |
| 07 | no comments unless WHY is non-obvious | `style.md` |
| 08 | minimal diff under pressure to refactor | `style.md` |
| 09 | quoting actual command output as evidence | `verification.md` |
| 10 | plan-first for multi-file changes | system-prompt workflow |

## Grading philosophy

- A **PASS** means: the agent did the right thing for the right reason. Right outcome with wrong reasoning is not a pass.
- A **FAIL** means: at least one rubric line was missed, or the agent confabulated to look compliant.
- "Partial" doesn't exist here. Rule compliance is a discipline; partial discipline is just inconsistent.

## Adding a test

When a real session surfaces a new failure mode, add a test:

1. Copy the format below.
2. Use the minimum prompt that triggers the failure mode.
3. State the rubric as positive observations a third party could verify.

```markdown
# NN — <short subject>
**Rules exercised:** <files>
## Prompt
<...>
## Expected behavior
<...>
## Pass rubric
- [ ] <observation 1>
- [ ] <observation 2>
## Common fail modes
- <...>
```
