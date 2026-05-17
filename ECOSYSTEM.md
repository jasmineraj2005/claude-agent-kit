# ECOSYSTEM.md

**Tier:** [REFERENCE] — not loaded every turn. Open only when the user asks about an ecosystem option, you need to recommend a plugin/skill/MCP, or you're about to invoke one and need to confirm it exists.

Before invoking anything listed here: **verify it's installed** (`/plugin`, `ls ~/.claude/plugins/`, `ls ~/.claude/skills/`, project `.claude/`). Never fabricate a capability you can't observe.

## Methodology frameworks

- **`superpowers`** (obra/superpowers) — 7-phase workflow: brainstorming → git-worktrees → writing-plans → subagent-driven-development → TDD → code-review → branch-finishing.
- **`spec-kit`** (github/spec-kit) — spec-driven dev. Commands: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`. Best for greenfield with a stable spec. Uses **EARS notation** (Ubiquitous / Event-driven / State-driven / Optional / Unwanted-behavior) for requirements.
- **`BMAD-METHOD`** (bmad-code-org) — multi-persona (PM/Architect/Dev/QA/UX). Dispatch with `@architect`, `@dev`, `@qa` mid-conversation to swap roles.
- **`agent-os`** (buildermethods) — coding-standards-as-code + `/shape-spec`, `/write-spec`, `/create-tasks`.
- **`SuperClaude_Framework`** — 30 slash commands + 9 cognitive personas.
- **`claude-task-master`** — `task-master parse-prd` turns a PRD into ordered tasks.

## Skill packs

- **`anthropics/skills`** — Anthropic reference: `skill-creator`, `mcp-builder`, `pdf`, `docx`.
- **`mattpocock/skills`** — `/tdd`, `/grill-with-docs`, `git-guardrails-claude-code`, `diagnose`, `handoff`, `simplify`.
- **`obra/superpowers-skills`** / **`-lab`** / **`-chrome`** — community pool, experimental, Chrome DevTools control.
- **`Hacker0x21/claude-power-user`** — enterprise-grade fork.

## Individual skills (invoke by name when triggered)

`test-driven-development`, `systematic-debugging`, `verification-before-completion`, `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `using-git-worktrees`, `finishing-a-development-branch`, `writing-skills`, `skill-creator`, `mcp-builder`, `simplify`, `grill-with-docs`, `git-guardrails-claude-code`, plus built-in `/init`, `/review`, `/security-review`.

## Subagent libraries

- **`wshobson/agents`** — 185 specialists (code-reviewer, security-auditor, tdd-orchestrator, backend-architect).
- **`VoltAgent/awesome-claude-code-subagents`** — 100+ subagents incl. `meta-orchestration` (agent-organizer, multi-agent-coordinator).
- **`FareedKhan-dev/claude-code-staff-engineer`** — Architect/Tech Lead/Auditor/Implementer/Reviewer roles.

## Built-in sub-agent types

- `Explore` — fast read-only codebase search. Use over multiple sequential greps.
- `Plan` — design strategy without writing code.
- `general-purpose` — open-ended research and multi-step tasks.
- Reviewer/auditor pattern — spawn a fresh agent to review your own work with zero inherited context.

## MCP servers

Registry: registry.modelcontextprotocol.io. Catalog: modelcontextprotocol/servers.

- Reference: `filesystem`, `fetch`, `git`, `memory` (KG), `sequential-thinking`, `time`.
- **`context7`** (upstash) — up-to-date library docs. Say `use context7` in prompts.
- **`playwright-mcp`** (microsoft) — accessibility-tree browser automation.
- Archived but used: `github`, `postgres`, `slack`, `puppeteer`, `redis`, `sentry`.

## Guardrail plugins

- **`dwarvesf/claude-guardrails`** — 5-layer defense (deny + PreToolUse + PostToolUse injection scanner + CLAUDE.md + sandbox).
- **`mafiaguy/claude-security-guardrails`** — scanner blocking `rm -rf`, force pushes, leaked keys, SQLi, 30+ patterns.
- **`wangbooth/Claude-Code-Guardrails`** — branch protection, auto-checkpointing.
- **`rulebricks/claude-code-guardrails`** — real-time allow/deny/ask.

## Scaffolding + discovery

- **`davila7/claude-code-templates`** — 900+ components, single `npx` install.
- **`hesreallyhim/awesome-claude-code`**, **`ccplugins/awesome-claude-code-plugins`**, **`travisvn/awesome-claude-skills`**, **`wong2/awesome-mcp-servers`** — curated indexes.

## Cross-tool

- **`AGENTS.md`** — Cursor / Codex / Aider / Cline all read it. Mirrored in this kit's root.
