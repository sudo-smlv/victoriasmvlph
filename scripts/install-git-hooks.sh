#!/usr/bin/env bash
# install-git-hooks.sh
# Installs Paperclip-managed git hooks into the shared .git/hooks/ directory
# of the current worktree. Idempotent: overwrites our managed hooks, leaves
# any unrelated hooks untouched.
#
# Usage:
#   scripts/install-git-hooks.sh
#
# Hooks installed (relative to the shared .git/hooks directory):
#   pre-push  -> .paperclip/hooks/pre-push.sh
#   commit-msg (optional, controlled by env PAPERCLIP_HOOK_COMMIT_MSG=1)

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
  echo "error: not inside a git worktree" >&2
  exit 1
fi

GIT_COMMON_DIR="$(git rev-parse --git-common-dir)"
HOOKS_DIR="$GIT_COMMON_DIR/hooks"
REPO_HOOKS_DIR="$REPO_ROOT/.paperclip/hooks"

mkdir -p "$HOOKS_DIR" "$REPO_HOOKS_DIR"

install_one() {
  local name="$1" src="$2"
  cp -f "$src" "$HOOKS_DIR/$name"
  chmod +x "$HOOKS_DIR/$name"
  echo "installed: $HOOKS_DIR/$name (-> $src)"
}

if [[ -f "$REPO_HOOKS_DIR/pre-push.sh" ]]; then
  install_one "pre-push" "$REPO_HOOKS_DIR/pre-push.sh"
fi

if [[ "${PAPERCLIP_HOOK_COMMIT_MSG:-0}" == "1" && -f "$REPO_HOOKS_DIR/commit-msg.sh" ]]; then
  install_one "commit-msg" "$REPO_HOOKS_DIR/commit-msg.sh"
fi
