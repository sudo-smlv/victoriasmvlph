# Git author identity policy

ClawTeam Engineering uses Paperclip agents to drive development. Every
commit is part of an audit trail — a chain of custody that tells reviewers
and incident responders which agent did which work. To keep that trail
trustworthy, each agent role has a canonical `name` and `email`, and CI
refuses to merge a PR whose head commit is authored by an identity that
is not in the policy.

This document is the runbook. For the machine-readable source of truth,
see [`.paperclip/git-identity.json`](../.paperclip/git-identity.json).

## Identity table

The table below is the canonical per-role identity. The policy file is
the single source of truth; the table is duplicated here for humans.

| Paperclip role        | `user.name`                     | `user.email`              |
| --------------------- | ------------------------------- | ------------------------- |
| Frontend Developer    | `Frontend Developer (ClawTeam)` | `frontend@clawteam.local` |
| Backend Developer     | `Backend Developer (ClawTeam)`  | `backend@clawteam.local`  |
| DevOps Engineer       | `DevOps Engineer (ClawTeam)`    | `devops@clawteam.local`   |
| QA Engineer           | `QA Engineer (ClawTeam)`        | `qa@clawteam.local`       |
| System Architect      | `System Architect (ClawTeam)`   | `architect@clawteam.local`|
| CEO / Tech Lead       | `CEO (ClawTeam)`                | `ceo@clawteam.local`      |
| UI/UX Designer        | `UI/UX Designer (ClawTeam)`     | `design@clawteam.local`   |
| System Analyst        | `System Analyst (ClawTeam)`     | `analyst@clawteam.local`  |
| Product Manager       | `Product Manager (ClawTeam)`    | `pm@clawteam.local`       |

> **Note on historic commits.** Earlier commits in this repo used
> `*-dev@paperclip.local` or similar addresses. They are left as-is for
> auditability; new commits must use the `@clawteam.local` table above.
> Rebases that bring a historic email forward should either re-author
> the commit or set the opt-out env var on the CI lint (see below).

## How identity is set on the agent's machine

When a Paperclip agent spins up a new workspace, the bootstrap runs
`scripts/paperclip-set-git-identity.sh`. The script reads the policy
file, resolves the active agent (from `PAPERCLIP_AGENT_NAME`,
`PAPERCLIP_AGENT_ID`, or a `--agent=<name>` flag), and writes
`user.name` / `user.email` via `git config --local`. It is idempotent
and safe to re-run.

If the agent commits without running the bootstrap first, the local
identity is whatever was left in `.git/config` from a previous session —
which is exactly the bug that produced the `8480b4e` incident. Always
run the bootstrap on a new worktree before the first commit.

## How the local pre-push hook checks identity

`scripts/install-git-hooks.sh` installs a managed pre-push hook into
`.git/hooks/pre-push` (or `.paperclip/hooks/pre-push.sh` is symlinked
in by the installer). The hook reads the policy and the current
`user.name` / `user.email`; if either does not match the active
agent's entry, the push is rejected with a readable error.

The local hook is a first line of defence, not a guarantee. A
determined agent can bypass it with `PAPERCLIP_SKIP_IDENTITY_CHECK=1`
or `--no-verify`. For that reason, CI runs its own check.

## CI lint (CLAAAAA-168)

`.github/workflows/build.yml` defines a `lint-pr-author` job that
runs on every `pull_request` whose base is `main`. The job invokes
`scripts/check-pr-author.sh`, which:

1. Reads `.paperclip/git-identity.json`.
2. Resolves the PR head commit's author via
   `git log -1 --format='%an <%ae>'`.
3. Compares the author against every `(name, email)` pair in
   `policy.agents`. A match requires **both** the name and the email
   to equal an entry.
4. On match, prints a `::notice::` annotation naming the policy entry
   and exits 0.
5. On mismatch, prints one or more `::error file=...,line=...::`
   annotations naming the expected and actual identities, suggests the
   fix, and exits 1.

### What it does not check

- It checks only the **head commit** of the PR. Re-checking every
  commit in the PR is out of scope (architect decision: re-author at
  PR time is a one-comment handoff to the committing agent, not a
  CI job).
- It does **not** check PRs to other branches (e.g. `feat/cla-5-integration`).
  The `lint-pr-author` job's `if:` gate restricts it to PRs whose
  base ref is `main`, satisfying the "main only" acceptance criterion.
- It does **not** block direct pushes to `main`. Branch protection is
  a separate concern; the `peaceiris/actions-gh-pages` deploy already
  covers that surface.

### Opt-out for historic rebases

If a PR brings forward a commit with a non-policy email (e.g. an
amend on top of a `paperclip.local` historic commit), set
`PAPERCLIP_SKIP_IDENTITY_CHECK=1` on the lint step. The script will
print a `::notice::` annotation naming the opt-out so reviewers can
see the override in the run log. The env var is **not** a permanent
escape hatch; it is documented here for the rare rebase case.

## Adding a new agent

1. Append a new entry to `.paperclip/git-identity.json` under
   `agents`. Use a lowercase role key (`"frontend developer"`,
   `"data scientist"`, etc.) and supply `name` and `email`.
2. Mirror the entry in the table above.
3. Open a PR. The bootstrap script and the CI lint will pick up the
   new entry on merge.

## Troubleshooting

- **CI fails with "PR head commit author is not in the per-agent
  identity policy".** Either amend the commit with the right
  identity (see the table) or, for a rebase, set
  `PAPERCLIP_SKIP_IDENTITY_CHECK=1` on the `lint-pr-author` step and
  explain the override in the PR description.
- **CI fails with "jq is required for the PR author identity lint
  but was not found on PATH".** This is a runner image regression —
  `ubuntu-latest` has `jq` preinstalled. Open a CI infra ticket and,
  in the meantime, set `PAPERCLIP_SKIP_IDENTITY_CHECK=1`.
- **CI passes with a warning about a missing policy file.** That is
  the lint's graceful path. The PR is the first to introduce
  `.paperclip/git-identity.json`, or the file was removed in this PR.
  Either restore the file or accept the warning and add a follow-up
  ticket to re-add it.
