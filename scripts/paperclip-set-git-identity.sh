#!/usr/bin/env bash
# paperclip-set-git-identity.sh
# Idempotent bootstrap that sets git user.name / user.email for the active
# Paperclip agent in the current worktree. Reads the policy from
# .paperclip/git-identity.json (relative to the repo root) and resolves the
# active agent from, in order:
#   1. --agent=<name> CLI flag
#   2. $PAPERCLIP_AGENT_NAME env var
#   3. $PAPERCLIP_AGENT_ID env var (resolved via the Paperclip API)
#   4. prompt
#
# Usage:
#   scripts/paperclip-set-git-identity.sh
#   scripts/paperclip-set-git-identity.sh --agent="Frontend Developer"
#   PAPERCLIP_AGENT_NAME="DevOps Engineer" scripts/paperclip-set-git-identity.sh
#
# Exit codes:
#   0  identity set (or already correct)
#   1  not inside a git worktree
#   2  policy file not found
#   3  agent not resolved
#   4  agent not present in policy
#   5  jq missing (and not running on a system that can install it)

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
  echo "error: not inside a git worktree" >&2
  exit 1
fi

POLICY="$REPO_ROOT/.paperclip/git-identity.json"
if [[ ! -f "$POLICY" ]]; then
  echo "error: policy file not found at $POLICY" >&2
  exit 2
fi

# --- arg / env parsing -------------------------------------------------------
AGENT_NAME=""
for arg in "$@"; do
  case "$arg" in
    --agent=*) AGENT_NAME="${arg#--agent=}" ;;
    --agent)   shift; AGENT_NAME="${1:-}" ;;
    --help|-h)
      sed -n '2,20p' "$0"
      exit 0
      ;;
  esac
done

if [[ -z "$AGENT_NAME" && -n "${PAPERCLIP_AGENT_NAME:-}" ]]; then
  AGENT_NAME="$PAPERCLIP_AGENT_NAME"
fi

# --- resolve agent id -> name via API if needed -------------------------------
if [[ -z "$AGENT_NAME" && -n "${PAPERCLIP_AGENT_ID:-}" && -n "${PAPERCLIP_API_URL:-}" ]]; then
  if command -v curl >/dev/null 2>&1; then
    auth_header=()
    [[ -n "${PAPERCLIP_API_KEY:-}" ]] && auth_header=(-H "Authorization: Bearer $PAPERCLIP_API_KEY")
    name_json=$(curl -fsS "${auth_header[@]}" "$PAPERCLIP_API_URL/api/agents/$PAPERCLIP_AGENT_ID" || true)
    if [[ -n "$name_json" ]]; then
      AGENT_NAME=$(printf '%s' "$name_json" | (command -v jq >/dev/null 2>&1 && jq -r '.name // empty' || python3 -c "import sys,json;print(json.load(sys.stdin).get('name',''))" 2>/dev/null) || true)
    fi
  fi
fi

# --- prompt if still empty ---------------------------------------------------
if [[ -z "$AGENT_NAME" ]]; then
  if [[ -t 0 ]]; then
    read -r -p "Paperclip agent name (e.g. 'DevOps Engineer'): " AGENT_NAME
  else
    echo "error: agent not resolved. Set PAPERCLIP_AGENT_NAME or pass --agent=<name>." >&2
    exit 3
  fi
fi

# --- look up identity in policy ---------------------------------------------
if ! command -v jq >/dev/null 2>&1; then
  echo "warning: jq not found; falling back to python3" >&2
fi

lookup() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg k "$key" '.agents[$k] // empty' "$POLICY"
  else
    python3 - "$POLICY" "$key" <<'PY'
import json, sys
data = json.load(open(sys.argv[1]))
print(json.dumps(data.get("agents", {}).get(sys.argv[2], {})))
PY
  fi
}

KEY=$(printf '%s' "$AGENT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]*$//;s/^[[:space:]]*//')
ENTRY=$(lookup "$KEY" || true)
if [[ -z "$ENTRY" || "$ENTRY" == "{}" || "$ENTRY" == "null" ]]; then
  echo "error: agent '$AGENT_NAME' (key='$KEY') not present in $POLICY" >&2
  exit 4
fi

if command -v jq >/dev/null 2>&1; then
  NAME=$(jq -r '.name'  <<<"$ENTRY")
  EMAIL=$(jq -r '.email' <<<"$ENTRY")
else
  NAME=$(python3 -c "import json,sys;print(json.loads(sys.argv[1])['name'])"  "$ENTRY")
  EMAIL=$(python3 -c "import json,sys;print(json.loads(sys.argv[1])['email'])" "$ENTRY")
fi

# --- apply (idempotent) -------------------------------------------------------
current_name=$(git config --local --get user.name || true)
current_email=$(git config --local --get user.email || true)

if [[ "$current_name" == "$NAME" && "$current_email" == "$EMAIL" ]]; then
  echo "ok: identity already correct ($NAME <$EMAIL>)"
  exit 0
fi

git config --local user.name  "$NAME"
git config --local user.email "$EMAIL"
echo "set: $NAME <$EMAIL>"
