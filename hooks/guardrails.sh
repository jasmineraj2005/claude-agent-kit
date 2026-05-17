#!/usr/bin/env bash
# claude-agent-kit guardrails — PreToolUse hook for Bash.
#
# Reads the PreToolUse JSON payload on stdin, inspects the command,
# and exits 2 (with an explanation on stderr) to block dangerous
# operations. Exit 0 to allow.
#
# Blocked:
#   - git push --force[-with-lease] to main/master/trunk
#   - --no-verify, --no-gpg-sign, commit.gpgsign=false
#   - git add of .env*, *.key, *.pem, credentials*, id_rsa*

set -euo pipefail

INPUT="$(cat)"

if command -v jq >/dev/null 2>&1; then
  CMD="$(printf '%s' "${INPUT}" | jq -r '.tool_input.command // ""')"
else
  CMD="$(printf '%s' "${INPUT}" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("tool_input",{}).get("command",""))')"
fi

block() {
  echo "BLOCKED by claude-agent-kit: $1" >&2
  echo "If you genuinely need this, ask the user for explicit confirmation in-conversation, then bypass the hook by editing ~/.claude/settings.json." >&2
  exit 2
}

# 1. Force-push to a default branch
if printf '%s' "${CMD}" | grep -qE 'git[[:space:]]+push\b.*--force(-with-lease)?\b.*\b(main|master|trunk)\b'; then
  block "force-push to a default branch (main/master/trunk)."
fi

# 2. Hook / signing bypass
if printf '%s' "${CMD}" | grep -qE '(^|[[:space:]])--no-verify\b|(^|[[:space:]])--no-gpg-sign\b|commit\.gpgsign=false'; then
  block "git hook or signing bypass. Fix the underlying check instead of skipping it."
fi

# 3. Staging files that commonly hold secrets
if printf '%s' "${CMD}" | grep -qE 'git[[:space:]]+add\b.*(\.env(\.[a-zA-Z0-9_-]+)?\b|\.key\b|\.pem\b|credentials[^[:space:]]*|id_rsa\b)'; then
  block "staging a file that may contain secrets (.env*, *.key, *.pem, credentials*, id_rsa*)."
fi

exit 0
