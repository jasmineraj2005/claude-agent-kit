# Claude Agent Kit

A drop-in system prompt + rule pack for using Claude Code (or Cursor / Codex / Aider) as a senior software engineer. Designed to be **firm on safety, flexible on style** — every rule is tiered so you know what's enforced and what's judgment.

## Quick install

```bash
git clone https://github.com/jasmineraj2005/claude-agent-kit ~/.claude/claude-agent-kit && \
  bash ~/.claude/claude-agent-kit/setup.sh
```

That single command:

1. Clones (or updates) the kit into `~/.claude/claude-agent-kit`.
2. Appends a pointer to `~/.claude/CLAUDE.md` so every Claude Code session auto-loads the rules.
3. Registers a PreToolUse hook in `~/.claude/settings.json` that blocks the three failure modes most likely to bite (force-push to main, hook bypass, staging secrets).

Restart Claude Code after the install. To uninstall: `bash ~/.claude/claude-agent-kit/setup.sh --uninstall`.

## What's in the box

```
claude-agent-kit/
├── system-prompt.md           # Identity, workflow, tool use, tier system
├── CLAUDE.md                  # Project template — fill in <placeholders> per repo
├── AGENTS.md                  # Cross-tool mirror of the critical rules
├── ECOSYSTEM.md               # [REFERENCE] Skill packs, MCP servers, subagent libs — lookup-only
├── README.md                  # This file
├── setup.sh                   # Idempotent installer (clone + CLAUDE.md + hooks)
├── hooks/
│   └── guardrails.sh          # PreToolUse hook: blocks force-push to main, --no-verify, secret-staging
├── rules/
│   ├── tdd.md                 [DEFAULT]    Red→Green→Refactor
│   ├── verification.md        [ALWAYS]     No completion claims without evidence
│   ├── git-safety.md          [ALWAYS]     Destructive-action confirmation
│   ├── security.md            [ALWAYS]     OWASP defaults, prompt-injection defense
│   ├── data-and-pii.md        [ALWAYS]     PII/PHI handling (health-context defaults)
│   ├── style.md               [DEFAULT]    Minimal diffs, no abstractions, comments
│   ├── debugging.md           [DEFAULT]    Systematic root-cause method
│   ├── session-handoff.md     [DEFAULT]    HANDOFF.md when context fills
│   ├── code-review-checklist.md [DEFAULT]  Self-review before claiming done
│   ├── refactoring.md         [WHEN USEFUL] Restructuring without behavior change
│   ├── dependency-management.md [WHEN USEFUL] Adding/upgrading deps
│   ├── observability.md       [WHEN USEFUL] Structured logging, traces, redaction
│   ├── performance.md         [WHEN USEFUL] Measure-first, hot-path discipline
│   ├── accessibility.md       [WHEN USEFUL] WCAG basics for UI work
│   ├── design.md              [WHEN USEFUL] Reference-driven design workflow
│   ├── shipping-and-apis.md   [REFERENCE]  Versioning, rollbacks, feature flags
│   └── _stacks/
│       ├── python.md          Stack overlay: types, control flow, pytest, ruff
│       ├── typescript.md      Stack overlay: strict mode, discriminated unions, ESM
│       └── next.md            Stack overlay: App Router, Server Components, Server Actions
└── tests/
    ├── README.md              How to run the rule-compliance harness
    └── 01..10-*.md            Prompt + expected behavior + pass rubric, one per rule
```

Every [ALWAYS] and [DEFAULT] rule file ends with a **Why this rule exists** block: a concrete violation, the compliant alternative, and what ships when the rule is ignored. That section is the real load-bearing part of the kit — rules without receipts get rationalized away.

## Priority tiers — read this first

The kit avoids "iron law everywhere" by labeling every rule with one of four tiers:

| Tier | Meaning | Example |
|---|---|---|
| **[ALWAYS]** | Non-negotiable. Bypass only with explicit, in-conversation permission. | No secrets in commits. No force-push to main. |
| **[DEFAULT]** | On by default. Opt out with a stated reason in the response. | TDD for new behavior. Verify before "done." |
| **[WHEN USEFUL]** | Judgment call. Apply when the situation fits; skip when it doesn't. | Detailed observability. Perf optimization. |
| **[REFERENCE]** | Look up when relevant. Not always active. | API versioning patterns. Rollback playbook. |

When rules conflict, the higher tier wins. When in doubt, lean toward the higher tier.

## How to use it

### Option A — Quick install (recommended)

Run the one-liner above. Done. Every Claude Code session on the machine now loads the kit, and the guardrail hook deterministically blocks the three highest-impact mistakes.

### Option B — Project-only

If you don't want the kit globally, copy `system-prompt.md` content into the project's `CLAUDE.md` and copy the matching `rules/_stacks/<lang>.md` overlay into the project. Skip the hook installation.

### Option C — Cross-tool (Cursor / Codex / Aider)

Drop `AGENTS.md` into the repo root. Cursor / Codex / Aider / Cline all read it. It's a condensed mirror of the kit's critical rules.

## Customizing

- **Too strict?** Move a rule from [DEFAULT] to [WHEN USEFUL] in `system-prompt.md`'s rule index, or delete it.
- **Too loose?** Move a rule up a tier, or add the rule's content into `rules/git-safety.md` (which is [ALWAYS]).
- **Project has a constitution?** Add a `CONSTITUTION.md` for inviolable principles that survive PR drift (spec-kit pattern).
- **Different stack?** Add a new file under `rules/_stacks/` and reference it from `system-prompt.md`. Existing overlays cover Python, TypeScript, and Next.js.

## Verifying the hook

The PreToolUse hook is the part of the kit that is enforced deterministically, not just advised. Smoke-test it:

```bash
HOOK=~/.claude/claude-agent-kit/hooks/guardrails.sh
echo '{"tool_input":{"command":"git push --force origin main"}}' | bash "$HOOK"; echo "exit=$?"  # exit=2
echo '{"tool_input":{"command":"git commit --no-verify -m x"}}'  | bash "$HOOK"; echo "exit=$?"  # exit=2
echo '{"tool_input":{"command":"git add .env.production"}}'      | bash "$HOOK"; echo "exit=$?"  # exit=2
echo '{"tool_input":{"command":"ls -la"}}'                       | bash "$HOOK"; echo "exit=$?"  # exit=0
```

If a block fires unexpectedly in normal work, edit `~/.claude/settings.json` to remove the entry, or refine the regex in `hooks/guardrails.sh`.

## Test harness

`tests/` contains 10 prompt+rubric pairs covering the most-violated rules. Run them manually against a fresh Claude Code session after each kit edit to catch regressions before they ship. See `tests/README.md`.

## What the kit borrows from

- Anthropic's Claude Code best practices (code.claude.com/docs)
- obra/superpowers — methodology, TDD discipline, verification
- github/spec-kit — EARS notation, constitution doc concept
- bmad-code-org/BMAD-METHOD — persona dispatch
- mattpocock/skills, wshobson/agents, VoltAgent — subagent + skill patterns
- dwarvesf/claude-guardrails — defense-in-depth safety
- Kent Beck (TDD, Tidy First?), Hunt/Thomas (Pragmatic Programmer)

## Changelog

### v1.0 (current)

- **Ecosystem section moved** out of `system-prompt.md` into `ECOSYSTEM.md`. ~30% smaller per-turn context for the common case.
- **"Why this rule exists" blocks** added to every [ALWAYS] and [DEFAULT] rule with concrete violation / compliance / what-ships-without examples. The single highest-leverage compliance change.
- **Hooks shipped.** `hooks/guardrails.sh` + `setup.sh` register a PreToolUse hook that deterministically blocks force-push-to-main, hook bypass, and secret-file staging.
- **Test harness added.** `tests/` with 10 prompt+rubric pairs covering the most-violated rules.
- **Per-stack overlays.** `rules/_stacks/{python,typescript,next}.md` provide concrete senior-engineer opinions for the most common stacks. Loaded based on working-directory contents.
- **Removed the "1% Rule"** framing (over-invokes skills for marginal value). Replaced with explicit invocation-cost-vs-value language.

### v0.1

- Initial tier system ([ALWAYS] / [DEFAULT] / [WHEN USEFUL] / [REFERENCE]), 15 rules, AGENTS.md cross-tool mirror.

## Versioning

This is **v1.0.0**. Pin the kit version in your `CLAUDE.md` (`based on claude-agent-kit@v1.0`) so upgrades are deliberate.
