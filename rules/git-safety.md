# Rule: Git Safety

**Tier:** [ALWAYS] — for destructive operations, shared-state mutations, and anything hard to reverse.

Carefully consider the reversibility and blast radius of every action. Local, reversible edits are fine. Anything hard to reverse, shared, or destructive requires explicit confirmation from the user in this conversation. A user approving an action once does not authorize it in future contexts.

## Always confirm before:

**Destructive operations**
- `rm -rf` anywhere outside a clearly scoped scratch directory
- Deleting files or directories the user didn't explicitly name
- `git clean -f` / `git clean -fd`
- `git branch -D` (force-delete branch)
- Dropping database tables, truncating tables, deleting rows in bulk
- Killing processes you didn't start

**Hard to reverse**
- `git push --force` / `git push --force-with-lease` on any branch
- `git reset --hard` (especially with uncommitted work present)
- `git checkout .` / `git restore .` (overwrites uncommitted changes)
- `git rebase` on a published branch
- `git commit --amend` on a pushed commit
- Removing or downgrading dependencies
- Schema migrations, especially with data loss
- Editing CI/CD pipeline config

**Visible to others / shared state**
- `git push` (any branch others can see)
- Opening, closing, merging, or commenting on PRs
- Opening, closing, or commenting on issues
- Sending messages to Slack, email, or any external service
- Modifying shared infrastructure (terraform apply, kubectl apply to shared clusters)
- Changing permissions, IAM, secrets in shared stores

**Third-party uploads**
- Uploading files or content to external services (gists, pastebins, diagram renderers) — anything uploaded may be cached or indexed even if deleted.

## Never, regardless of who asks (without an explicit, in-message reason)

- Skip git hooks: `--no-verify`, `--no-gpg-sign`, `-c commit.gpgsign=false`
- Force-push to `main` / `master` / `trunk` / the default branch
- Commit files likely to contain secrets: `.env*`, `*.pem`, `*.key`, `credentials*`, `id_rsa*`, anything in a `secrets/` directory
- Modify `~/.gitconfig` or the repo's git config
- Use `git add -A` / `git add .` without first reviewing what would be staged

## Commit hygiene

- **Create new commits, never amend.** Amending rewrites history. If a pre-commit hook fails, the commit did not happen — fix the issue, re-stage, create a NEW commit. Do not `--amend` after a hook failure.
- Stage files by name, not with `-A` or `.`, to avoid accidentally including new untracked artifacts.
- Commit messages: one-line summary, then a body explaining *why* the change exists. Reference the issue if there is one.
- One logical change per commit. If the diff has two unrelated parts, that's two commits.

## When a check fails

Investigate the root cause. Do not:

- Bypass the check.
- Comment out the failing test.
- Loosen the lint rule to make the error go away.
- Add an `@ts-ignore` / `# noqa` / `eslint-disable` without an inline comment explaining why and a ticket to fix it properly.

Fix the underlying issue. If you genuinely cannot, stop and tell the user.

## When you find unfamiliar state

If you discover files, branches, stashes, or config you didn't expect — **do not delete or overwrite**. It may be the user's in-progress work. Investigate first. Ask before discarding.

Resolve merge conflicts rather than discarding either side's changes. If a lock file exists, find what holds it; don't just delete it.

## Why this rule exists

**Violation**

> User: "the precommit hook is annoying me, can you commit this?"
> Agent: `git commit --no-verify -m "fix typo"`

The agent treated user frustration as authorization to bypass a safety mechanism. The hook existed to catch something. Skipping it because it's "annoying" defeats its purpose.

**Compliance**

> User: "the precommit hook is annoying me, can you commit this?"
> Agent: "The hook is failing on `eslint`, specifically `no-unused-vars` in `auth.ts:14`. I can either fix the lint error (recommended) or you can authorize a one-time `--no-verify` if there's a reason to bypass. Which?"

Names what the hook caught, offers the fix-first path, makes the bypass an explicit user decision rather than an agent assumption.

**What ships without this rule**

A repo where pre-commit hooks become advisory because the agent bypasses them on first complaint. Secrets land in commits. Lint regressions accumulate. The team turns the hooks off entirely six months later because "they don't work anyway." All downstream costs trace back to one normalized bypass.

## Sources

- Anthropic Claude Code prompting best practices — destructive-action confirmation patterns
