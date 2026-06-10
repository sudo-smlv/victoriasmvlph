#!/usr/bin/env bash
# pre-push hook (managed by .paperclip/hooks, installed by
# scripts/install-git-hooks.sh). Verifies the local git identity matches the
# expected per-agent identity for the active Paperclip agent.
#
# Bypasses:
#   PAPERCLIP_SKIP_IDENTITY_CHECK=1  (escape hatch for emergency fixes)
#
# Exit codes:
#   0  push allowed
#   1  push rejected (identity mismatch or unresolved agent)

set -euo pipefail

if [[ "${PAPERCLIP_SKIP_IDENTITY_CHECK:-0}" == "1" ]]; then
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -z "$REPO_ROOT" ]] && exit 0

POLICY="$REPO_ROOT/.paperclip/git-identity.json"
[[ ! -f "$POLICY" ]] && exit 0

# --- resolve active agent ----------------------------------------------------
AGENT_NAME=""
if [[ -n "${PAPERCLIP_AGENT_NAME:-}" ]]; then
  AGENT_NAME="$PAPERCLIP_AGENT_NAME"
elif [[ -n "${PAPERCLIP_AGENT_ID:-}" && -n "${PAPERCLIP_API_URL:-}" ]] && command -v curl >/dev/null 2>&1; then
  auth_header=()
  [[ -n "${PAPERCLIP_API_KEY:-}" ]] && auth_header=(-H "Authorization: Bearer $PAPERCLIP_API_KEY")
  name_json=$(curl -fsS "${auth_header[@]}" "$PAPERCLIP_API_URL/api/agents/$PAPERCLIP_AGENT_ID" || true)
  if [[ -n "$name_json" ]]; then
    if command -v jq >/dev/null 2>&1; then
      AGENT_NAME=$(jq -r '.name // empty' <<<"$name_json")
    else
      AGENT_NAME=$(python3 -c "import json,sys;print(json.load(sys.stdin).get('name',''))" <<<"$name_json" 2>/dev/null || true)
    fi
  fi
fi

# If we cannot resolve the agent, do not block the push (better false-negative
# than bricked pushes during onboarding or local dev). The bootstrap step is
# still expected to be run manually.
if [[ -z "$AGENT_NAME" ]]; then
  echo "pre-push: paperclip agent not resolved (set PAPERCLIP_AGENT_NAME); skipping identity check" >&2
  exit 0
fi

KEY=$(printf '%s' "$AGENT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]*$//;s/^[[:space:]]*//')

if command -v jq >/dev/null 2>&1; then
  ENTRY=$(jq -r --arg k "$KEY" '.agents[$k] // empty' "$POLICY")
else
  ENTRY=$(KEY="$KEY" POLICY_PATH="$POLICY" python3 -c "
import json, os
data = json.load(open(os.environ['POLICY_PATH']))
print(json.dumps(data.get('agents', {}).get(os.environ['KEY'], {})))
")
fi

if [[ -z "$ENTRY" || "$ENTRY" == "{}" || "$ENTRY" == "null" ]]; then
  echo "pre-push: agent '$AGENT_NAME' not in $POLICY; skipping" >&2
  exit 0
fi

if command -v jq >/dev/null 2>&1; then
  EXPECTED_NAME=$(jq -r '.name'  <<<"$ENTRY")
  EXPECTED_EMAIL=$(jq -r '.email' <<<"$ENTRY")
else
  EXPECTED_NAME=$(python3 -c "import json,sys;print(json.loads(sys.argv[1])['name'])"  "$ENTRY")
  EXPECTED_EMAIL=$(python3 -c "import json,sys;print(json.loads(sys.argv[1])['email'])" "$ENTRY")
fi

ACTUAL_NAME=$(git config --local --get user.name || true)
ACTUAL_EMAIL=$(git config --local --get user.email || true)

if [[ "$ACTUAL_NAME" == "$EXPECTED_NAME" && "$ACTUAL_EMAIL" == "$EXPECTED_EMAIL" ]]; then
  exit 0
fi

cat >&2 <<EOF
pre-push: git identity mismatch for $AGENT_NAME
  expected: $EXPECTED_NAME <$EXPECTED_EMAIL>
  actual:   ${ACTUAL_NAME:-<unset>} <${ACTUAL_EMAIL:-<unset>}>
Fix by running:
  scripts/paperclip-set-git-identity.sh --agent="$AGENT_NAME"
or override with:
  PAPERCLIP_SKIP_IDENTITY_CHECK=1 git push ...
EOF
exit 1
