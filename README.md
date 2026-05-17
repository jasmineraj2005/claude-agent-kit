# Claude Agent Kit

A drop-in system prompt + rule pack for using Claude Code (or Cursor / Codex / Aider) as a senior software engineer. Designed to be **firm on safety, flexible on style** — every rule is tiered so you know what's enforced and what's judgment.

## What's in the box

```
claude-agent-kit/
├── system-prompt.md           # Identity, workflow, tool use, available plugins
├── CLAUDE.md                  # Project template — fill in <placeholders> per repo
├── AGENTS.md                  # Cross-tool mirror of the critical rules
├── README.md                  # This file
└── rules/
    ├── tdd.md                 [DEFAULT]    Red→Green→Refactor
    ├── verification.md        [ALWAYS]     No completion claims without evidence
    ├── git-safety.md          [ALWAYS]     Destructive-action confirmation
    ├── security.md            [ALWAYS]     OWASP defaults, prompt-injection defense
    ├── data-and-pii.md        [ALWAYS]     PII/PHI handling (health-context defaults)
    ├── style.md               [DEFAULT]    Minimal diffs, no abstractions, comments
    ├── debugging.md           [DEFAULT]    Systematic root-cause method
    ├── session-handoff.md     [DEFAULT]    HANDOFF.md when context fills
    ├── code-review-checklist  [DEFAULT]    Self-review before claiming done
    ├── refactoring.md         [WHEN USEFUL] Restructuring without behavior change
    ├── dependency-management  [WHEN USEFUL] Adding/upgrading deps
    ├── observability.md       [WHEN USEFUL] Structured logging, traces, redaction
    ├── performance.md         [WHEN USEFUL] Measure-first, hot-path discipline
    ├── accessibility.md       [WHEN USEFUL] WCAG basics for UI work
    └── shipping-and-apis.md   [REFERENCE]  Versioning, rollbacks, feature flags
```

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

### Option A — Drop into a project

1. Copy this folder into the repo root, or into `~/.claude/` for global use.
2. Rename `system-prompt.md` content into your agent's system prompt slot (Claude Code: `~/.claude/CLAUDE.md` for global; project root `CLAUDE.md` for per-repo).
3. Fill in the `<placeholders>` in `CLAUDE.md` for the project.
4. Optionally `cp AGENTS.md ./AGENTS.md` so Cursor/Codex/Aider share the rules.

### Option B — Reference selectively

Pick the rules that fit your team. Each file is self-contained. You can delete what you don't want without breaking anything else.

### Option C — Wire to Claude Code natively

For full enforcement (not just advisory rules), pair the markdown with:

- `.claude/settings.json` — `permissions.deny` for hard blocks
- `.claude/hooks/` — PreToolUse / PostToolUse / Stop hooks that enforce the rules deterministically (the markdown is advisory; hooks are enforced)
- `.claude/agents/` — subagent definitions
- `.claude/commands/` — slash commands like `/plan`, `/verify`, `/handoff`

Templates for these are not shipped here yet — they're the next iteration.

## Customizing

- **Too strict?** Move a rule from [DEFAULT] to [WHEN USEFUL] in `system-prompt.md`'s rule index, or delete it.
- **Too loose?** Move a rule up a tier, or add the rule's content into `rules/git-safety.md` (which is [ALWAYS]).
- **Project has a constitution?** Add a `CONSTITUTION.md` for inviolable principles that survive PR drift (spec-kit pattern).
- **Different stack?** Override the language-specific bits in `CLAUDE.md`. The rule files are mostly language-agnostic.

## What the kit borrows from

- Anthropic's Claude Code best practices (code.claude.com/docs)
- obra/superpowers — methodology, TDD discipline, verification, the 1% Rule
- github/spec-kit — EARS notation, constitution doc concept
- bmad-code-org/BMAD-METHOD — persona dispatch
- mattpocock/skills, wshobson/agents, VoltAgent — subagent + skill patterns
- dwarvesf/claude-guardrails — defense-in-depth safety
- Kent Beck (TDD, Tidy First?), Hunt/Thomas (Pragmatic Programmer)

## Versioning

This is v0.1. Pin the kit version in your `CLAUDE.md` (`based on claude-agent-kit@v0.1`) so upgrades are deliberate.
