# Per-agent git identity (CLAAAAA-153)

Every commit in this repo must be authored by the Paperclip agent that produced
the work. This is a chain-of-custody / supply-chain hygiene control. The
`DevOps Engineer` is responsible for keeping the policy in sync; the
`System Architect` owns the policy content.

## Policy file

`.paperclip/git-identity.json` is the single source of truth. It maps each
Paperclip agent name (lowercased) to its canonical `user.name` and
`user.email`. The file is intentionally small and human-readable so it can be
reviewed in a PR.

## Current mapping

| Paperclip agent       | `user.name`                     | `user.email`              |
|-----------------------|----------------------------------|---------------------------|
| Frontend Developer    | `Frontend Developer (ClawTeam)`  | `frontend@clawteam.local` |
| Backend Developer     | `Backend Developer (ClawTeam)`   | `backend@clawteam.local`  |
| DevOps Engineer       | `DevOps Engineer (ClawTeam)`     | `devops@clawteam.local`   |
| QA Engineer           | `QA Engineer (ClawTeam)`         | `qa@clawteam.local`       |
| System Architect      | `System Architect (ClawTeam)`    | `architect@clawteam.local`|
| CEO / Tech Lead       | `CEO (ClawTeam)`                 | `ceo@clawteam.local`      |
| UI/UX Designer        | `UI/UX Designer (ClawTeam)`      | `design@clawteam.local`   |
| System Analyst        | `System Analyst (ClawTeam)`      | `analyst@clawteam.local`  |
| Product Manager       | `Product Manager (ClawTeam)`     | `pm@clawteam.local`       |

> Historic commits in the repo used a different convention
> (`frontend-dev@paperclip.local`, `architect@paperclip.local`, …). They are
> not rewritten; the new convention applies to all commits after this policy
> lands.

## Bootstrap (every new worktree)

After Paperclip creates a worktree, the agent should run:

```sh
scripts/paperclip-set-git-identity.sh
```

Resolution order for the active agent:

1. `--agent="<name>"` flag
2. `$PAPERCLIP_AGENT_NAME` env var
3. `$PAPERCLIP_AGENT_ID` env var, looked up via the Paperclip API
4. interactive prompt

The script is idempotent: running it again with the correct agent leaves
`git config` unchanged.

## Pre-push guard

`scripts/install-git-hooks.sh` installs `pre-push` into the shared
`.git/hooks/` directory. The hook:

1. resolves the active agent the same way as bootstrap
2. reads the expected identity from `.paperclip/git-identity.json`
3. compares it to `git config --local user.name` / `user.email`
4. blocks the push with a clear error if they do not match

Escape hatch: `PAPERCLIP_SKIP_IDENTITY_CHECK=1 git push …` (use sparingly;
leave a comment in the issue if you do).

## Adding a new agent

1. Add the entry to `.paperclip/git-identity.json`.
2. Re-run `scripts/paperclip-set-git-identity.sh --agent="<new name>"` in any
   active worktree to confirm resolution.
3. Commit the policy change; the pre-push hook picks it up automatically.

## Why a policy file and not env-var-only

The Paperclip CLI does not yet invoke the bootstrap script when it creates a
worktree, so the only thing that travels with the repo is the policy file plus
a deterministic resolution path. Both the bootstrap and the hook read the
same file, so they cannot drift.
