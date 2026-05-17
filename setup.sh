#!/usr/bin/env bash
# claude-agent-kit installer.
#
# Installs the kit into ~/.claude/claude-agent-kit, wires a pointer into
# ~/.claude/CLAUDE.md so every session loads it, and registers the
# guardrail PreToolUse hook in ~/.claude/settings.json.
#
# Idempotent: safe to re-run. Use `bash setup.sh --uninstall` to remove.

set -euo pipefail

KIT_REPO="https://github.com/jasmineraj2005/claude-agent-kit.git"
KIT_DIR="${HOME}/.claude/claude-agent-kit"
CLAUDE_DIR="${HOME}/.claude"
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"
SETTINGS="${CLAUDE_DIR}/settings.json"
POINTER_MARK="<!-- claude-agent-kit -->"

log() { printf '[claude-agent-kit] %s\n' "$*"; }
warn() { printf '[claude-agent-kit] WARN: %s\n' "$*" >&2; }
die() { printf '[claude-agent-kit] ERROR: %s\n' "$*" >&2; exit 1; }

uninstall() {
  log "Removing kit pointer from ${CLAUDE_MD}..."
  if [ -f "${CLAUDE_MD}" ]; then
    awk -v mark="${POINTER_MARK}" '
      $0 == mark { skip = 1; next }
      skip && $0 == "" { skip = 0; next }
      !skip { print }
    ' "${CLAUDE_MD}" > "${CLAUDE_MD}.tmp" && mv "${CLAUDE_MD}.tmp" "${CLAUDE_MD}"
  fi
  log "Leaving ${KIT_DIR} in place; remove it manually if you want a clean uninstall."
  if command -v jq >/dev/null 2>&1 && [ -f "${SETTINGS}" ]; then
    log "Removing guardrails hook from ${SETTINGS}..."
    jq '
      if .hooks.PreToolUse then
        .hooks.PreToolUse |= map(select(
          (.hooks // []) | map(.command) | any(test("claude-agent-kit/hooks/guardrails.sh")) | not
        ))
      else . end
    ' "${SETTINGS}" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "${SETTINGS}"
  fi
  log "Uninstalled."
  exit 0
}

if [ "${1:-}" = "--uninstall" ]; then uninstall; fi

mkdir -p "${CLAUDE_DIR}"

# 1. Clone or update
if [ -d "${KIT_DIR}/.git" ]; then
  log "Updating existing kit at ${KIT_DIR}"
  git -C "${KIT_DIR}" pull --ff-only
else
  log "Cloning kit to ${KIT_DIR}"
  git clone "${KIT_REPO}" "${KIT_DIR}"
fi

# 2. Pointer in ~/.claude/CLAUDE.md (idempotent)
if [ ! -f "${CLAUDE_MD}" ] || ! grep -qF "${POINTER_MARK}" "${CLAUDE_MD}"; then
  log "Adding kit pointer to ${CLAUDE_MD}"
  cat >> "${CLAUDE_MD}" <<EOF

${POINTER_MARK}
Follow the rules in ~/.claude/claude-agent-kit/system-prompt.md and the files in ~/.claude/claude-agent-kit/rules/. Honor the tier labels: [ALWAYS] is non-negotiable, [DEFAULT] is on unless I opt out, [WHEN USEFUL] is judgment, [REFERENCE] is lookup-only. Load matching overlays from rules/_stacks/ based on the project's language.

EOF
else
  log "Pointer already present in ${CLAUDE_MD}; skipping."
fi

# 3. Make the hook executable
HOOK_SCRIPT="${KIT_DIR}/hooks/guardrails.sh"
chmod +x "${HOOK_SCRIPT}"

# 4. Register the hook in settings.json
if ! command -v jq >/dev/null 2>&1; then
  warn "jq not installed. The guardrails markdown is active but the hook is not registered."
  warn "Install jq (brew install jq / apt install jq) and re-run setup.sh, or edit ${SETTINGS} manually."
  log "Done (markdown-only mode)."
  exit 0
fi

if [ ! -f "${SETTINGS}" ]; then echo '{}' > "${SETTINGS}"; fi

HOOK_CMD="bash ${HOOK_SCRIPT}"

ALREADY_PRESENT="$(jq --arg cmd "${HOOK_CMD}" '
  [.hooks.PreToolUse // [] | .[] | .hooks // [] | .[] | .command] | any(. == $cmd)
' "${SETTINGS}")"

if [ "${ALREADY_PRESENT}" = "true" ]; then
  log "Guardrails hook already registered in ${SETTINGS}; skipping."
else
  log "Registering guardrails hook in ${SETTINGS}"
  jq --arg cmd "${HOOK_CMD}" '
    .hooks //= {} |
    .hooks.PreToolUse //= [] |
    .hooks.PreToolUse += [{
      matcher: "Bash",
      hooks: [{ type: "command", command: $cmd }]
    }]
  ' "${SETTINGS}" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "${SETTINGS}"
fi

log "Done. Restart Claude Code to pick up the hook."
log "What changed:"
log "  - ${KIT_DIR}                          (kit cloned/updated)"
log "  - ${CLAUDE_MD}                        (pointer appended)"
log "  - ${SETTINGS}                         (PreToolUse hook registered)"
log ""
log "To uninstall: bash ${KIT_DIR}/setup.sh --uninstall"
