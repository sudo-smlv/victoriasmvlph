#!/usr/bin/env bash
# Lint .github/workflows/*.yml for actions/* pinned to a pre-Node-24 major.
#
# Background: GitHub Actions forces JS actions onto the Node 24 runtime
# (and deprecates Node 20) starting June 16, 2026. Each action has its own
# "Node-24-ready" major. The CLAAAAA-63 bump raised every reference in this
# repo to the current major line. This script is the regression guard: any
# future re-pin below the floor fails CI loudly.
#
# Reference minima (Node-24-ready majors):
#   actions/checkout              >= v5
#   actions/setup-node            >= v5
#   actions/configure-pages       >= v5
#   actions/upload-pages-artifact >= v4
#   actions/deploy-pages          >= v4
#
# Behaviour:
#   - Scans every .yml/.yaml directly under .github/workflows.
#   - Matches the `actions/<name>@vN` form on a `uses:` line.
#   - Ignores lines containing the marker `node-24-lint: disable`.
#   - On a hit, prints one or more `::error file=...,line=...::` annotations
#     so GitHub surfaces the offending reference in the PR Checks UI.
#   - Exits 0 when all references meet the floor; exits 1 otherwise.
#
# Local use:  ./scripts/lint-actions.sh
# CI use:     see the "Lint pinned actions" step in .github/workflows/build.yml.
#
# Compatible with bash 3.2 (macOS default) and bash 5.x (GitHub Linux runners).
# Intentionally avoids `declare -A` and `mapfile` to keep both code paths
# working without depending on the host shell.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKFLOW_DIR="${REPO_ROOT}/.github/workflows"

# floor_for <action-name> -> echoes the minimum major to stdout (empty if untracked).
floor_for() {
  case "$1" in
    checkout)               printf '5' ;;
    setup-node)             printf '5' ;;
    configure-pages)        printf '5' ;;
    upload-pages-artifact)  printf '4' ;;
    deploy-pages)           printf '4' ;;
    *)                      return 1 ;;
  esac
}

if [[ ! -d "${WORKFLOW_DIR}" ]]; then
  echo "::error::No .github/workflows directory at ${WORKFLOW_DIR}" >&2
  exit 1
fi

# Collect workflow files into a NUL-delimited list, sorted.
WORKFLOW_FILES_TMP=$(mktemp)
trap 'rm -f "${WORKFLOW_FILES_TMP}"' EXIT
find "${WORKFLOW_DIR}" -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) -print0 \
  | sort -z > "${WORKFLOW_FILES_TMP}"

if [[ ! -s "${WORKFLOW_FILES_TMP}" ]]; then
  echo "::error::No workflow files found under ${WORKFLOW_DIR}" >&2
  exit 1
fi

OFFENDERS=""

# Read NUL-delimited filenames.
while IFS= read -r -d '' FILE; do
  REL="${FILE#${REPO_ROOT}/}"

  while IFS=: read -r LINENO RAW_LINE; do
    LINENO=$(( LINENO + 1 ))
    LINE="${RAW_LINE%$'\r'}"

    if [[ "${LINE}" == *"node-24-lint: disable"* ]]; then
      continue
    fi

    MATCHES=$(printf '%s\n' "${LINE}" \
      | grep -oE 'actions/([a-zA-Z0-9_-]+)@v([0-9]+)' || true)
    [[ -z "${MATCHES}" ]] && continue

    while IFS= read -r HIT; do
      [[ -z "${HIT}" ]] && continue
      ACTION=$(printf '%s' "${HIT}" | sed -E 's#actions/([a-zA-Z0-9_-]+)@v[0-9]+#\1#')
      MAJOR=$(printf '%s' "${HIT}" | sed -E 's#actions/[a-zA-Z0-9_-]+@v([0-9]+)#\1#')

      # Skip actions we don't have a floor for. Forward-compatible: when
      # a new actions/* reference is added, the script only fails once
      # someone has recorded its floor in `floor_for` above.
      MIN=$(floor_for "${ACTION}" || true)
      [[ -z "${MIN}" ]] && continue

      if (( MAJOR < MIN )); then
        MSG="actions/${ACTION}@v${MAJOR} is below Node-24-ready floor (>= @v${MIN}). Bump to a Node-24-ready major or add \`node-24-lint: disable\` to this line if intentional."
        echo "::error file=${REL},line=${LINENO}::${MSG}" >&2
        OFFENDERS="${OFFENDERS}${REL}:${LINENO}: actions/${ACTION}@v${MAJOR} (need >= @v${MIN})"$'\n'
      fi
    done <<< "${MATCHES}"
  done < <(grep -nE 'actions/[a-zA-Z0-9_-]+@v[0-9]+' "${FILE}" || true)
done < "${WORKFLOW_FILES_TMP}"

if [[ -n "${OFFENDERS}" ]]; then
  COUNT=$(printf '%s' "${OFFENDERS}" | grep -c . || true)
  echo "" >&2
  echo "lint-actions: ${COUNT} pre-Node-24 action reference(s) found:" >&2
  printf '%s' "${OFFENDERS}" | sed 's/^/  - /' >&2
  echo "" >&2
  echo "See scripts/lint-actions.sh for the floor table and opt-out marker." >&2
  exit 1
fi

echo "lint-actions: OK (all actions/* references meet the Node-24-ready floor)"
