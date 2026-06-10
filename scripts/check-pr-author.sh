#!/usr/bin/env bash
# CI lint: verify the head commit's author matches the Paperclip agent
# identity policy in .paperclip/git-identity.json.
#
# Background: CLAAAAA-153 added a repo-local policy and a pre-push hook so
# each agent commits with their canonical name+email. A determined agent
# can still bypass the local hook (PAPERCLIP_SKIP_IDENTITY_CHECK=1,
# --no-verify, or a different machine). This lint is the network-side
# guard: GitHub Actions is the trust boundary, and the head commit's
# author must be in the allow-list baked into the policy file.
#
# Behaviour:
#   - Reads .paperclip/git-identity.json from the repo root.
#   - Resolves the head commit's author with `git log -1 --format='%an <%ae>'`.
#   - Compares against every (name, email) pair in the policy's `agents`
#     object. A match is "author name AND email both equal an entry".
#   - On mismatch, prints one or more ::error file=...,line=...::
#     annotations naming the expected vs actual identity, and exits 1.
#   - On match, prints a one-line ::notice:: and exits 0.
#   - Escape hatch: PAPERCLIP_SKIP_IDENTITY_CHECK=1 makes the script a
#     no-op for historic-commit rebases. The escape hatch itself is
#     printed so reviewers can see the opt-out in the run log.
#   - If the policy file is missing, exits 0 with a warning. This lets
#     the very first PR that introduces both the policy and the lint
#     pass; subsequent PRs will fail loudly if the file disappears.
#
# Scope: tip of the PR only. Re-checking every commit in the PR is
# explicitly out of scope (per CLAAAAA-168).
#
# Local use:  ./scripts/check-pr-author.sh
# CI use:     the "lint-pr-author" job in .github/workflows/build.yml.
#
# Compatible with bash 3.2 (macOS default) and bash 5.x (GitHub Linux
# runners). Uses `jq` for JSON parsing; `jq` ships with ubuntu-latest
# and is on the default PATH on macOS via Homebrew. The script does a
# preflight for `jq` and fails closed with a clear error if it is
# missing — the alternative (hand-rolled JSON parsing in shell) is
# fragile, and a missing `jq` should surface as a CI infra bug, not a
# silent pass.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
POLICY_FILE="${REPO_ROOT}/.paperclip/git-identity.json"

# Escape hatch: historic rebases or sanctioned overrides.
if [[ "${PAPERCLIP_SKIP_IDENTITY_CHECK:-0}" == "1" ]]; then
  echo "::notice::PAPERCLIP_SKIP_IDENTITY_CHECK=1 — PR author identity lint is disabled for this run. Use sparingly (historic rebases only) and document the override in the PR description."
  exit 0
fi

if [[ ! -f "${POLICY_FILE}" ]]; then
  echo "::warning::No policy at ${POLICY_FILE}. The first PR that adds the policy file is expected to skip this lint. After merge, any PR that removes the file again will fail this step on subsequent runs."
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "::error::jq is required for the PR author identity lint but was not found on PATH. Install jq or set PAPERCLIP_SKIP_IDENTITY_CHECK=1 to opt out." >&2
  exit 1
fi

# Resolve the head commit author in the canonical "<name> <<email>>" form.
HEAD_AUTHOR="$(git -C "${REPO_ROOT}" log -1 --format='%an <%ae>')"
if [[ -z "${HEAD_AUTHOR}" ]]; then
  echo "::error::Could not read the head commit author via git log -1 (got empty string). Refusing to lint." >&2
  exit 1
fi

HEAD_NAME="${HEAD_AUTHOR% <*}"
HEAD_EMAIL="${HEAD_AUTHOR#*<}"
HEAD_EMAIL="${HEAD_EMAIL%>}"

# Build a tab-delimited list of "<name>\t<email>" pairs from the policy.
# Tab is safe because agent names and emails never contain tabs; NUL-delim
# would be even safer but bash `read` with NUL needs `read -d $'\0'` and
# an extra IFS dance, which the rest of the script already avoids.
PAIRS_TMP="$(mktemp)"
trap 'rm -f "${PAIRS_TMP}"' EXIT
jq -r '.agents | to_entries[] | "\(.value.name)\t\(.value.email)"' "${POLICY_FILE}" > "${PAIRS_TMP}"

if [[ ! -s "${PAIRS_TMP}" ]]; then
  echo "::error file=.paperclip/git-identity.json::Policy file has no agent entries. Add at least one (name, email) pair under .agents." >&2
  exit 1
fi

# Pre-count the policy entries so the success message reports the total
# policy size, not just "entries checked before first match".
TOTAL=$(wc -l < "${PAIRS_TMP}" | tr -d ' ')

MATCHED_LINE=""
MATCHED_INDEX=0
while IFS=$'\t' read -r POLICY_NAME POLICY_EMAIL; do
  MATCHED_INDEX=$(( MATCHED_INDEX + 1 ))
  if [[ "${HEAD_NAME}" == "${POLICY_NAME}" && "${HEAD_EMAIL}" == "${POLICY_EMAIL}" ]]; then
    MATCHED_LINE="${POLICY_NAME} <${POLICY_EMAIL}>"
    break
  fi
done < "${PAIRS_TMP}"

if [[ -n "${MATCHED_LINE}" ]]; then
  echo "::notice::PR head commit author matches policy entry #${MATCHED_INDEX} of ${TOTAL}: ${MATCHED_LINE}"
  exit 0
fi

# No match. Surface every policy entry so the author can pick the right
# one and amend, and include the actual identity we saw.
echo "::error file=.paperclip/git-identity.json::PR head commit author '${HEAD_AUTHOR}' is not in the per-agent identity policy." >&2
echo "::error::Expected one of:" >&2
while IFS=$'\t' read -r POLICY_NAME POLICY_EMAIL; do
  echo "  - ${POLICY_NAME} <${POLICY_EMAIL}>" >&2
done < "${PAIRS_TMP}"
echo "::error::Fix: amend the commit with the correct identity (see docs/git-identity.md) or push a follow-up commit under the right agent. For historic rebases, opt out with PAPERCLIP_SKIP_IDENTITY_CHECK=1." >&2
exit 1
