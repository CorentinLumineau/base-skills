# Advanced Operations

Cherry-pick, patch workflows, worktrees, and submodule management.

## Cherry-Pick

Apply a specific commit from another branch to the current branch.

```bash
# Apply a single commit
git cherry-pick {commit-hash}

# Apply a range of commits (exclusive start, inclusive end)
git cherry-pick {start-hash}^..{end-hash}

# Cherry-pick without committing (to edit or inspect first)
git cherry-pick --no-commit {hash}
git cherry-pick -n {hash}  # shorthand

# Cherry-pick a merge commit (specify mainline parent)
git cherry-pick -m 1 {merge-commit-hash}

# Continue after resolving conflict
git add {resolved-file}
git cherry-pick --continue

# Abort
git cherry-pick --abort
```

### Cherry-Pick Use Cases

| Scenario | Command |
|---------|--------|
| Hotfix to release branch | Cherry-pick the fix commit from main to release/v1.x |
| Backport to older version | Cherry-pick feature commits from main to support branch |
| Isolate one change from a large branch | Cherry-pick specific commit to a clean branch |

## Patch Workflows

Share commits without a forge (email, chat, code review systems):

```bash
# Create a patch from the last N commits
git format-patch -N

# Create patch for a range of commits
git format-patch {base-hash}..HEAD

# Create patch for a specific commit
git format-patch -1 {commit-hash}

# Apply a patch
git apply {patch-file}

# Apply with commit metadata (author, message)
git am {patch-file}

# Apply from stdin
cat fix.patch | git am
```

## Worktrees

Check out multiple branches simultaneously in separate directories. Useful for:
- Reviewing a PR while working on a feature
- Hotfix work without disturbing in-progress work
- Running tests on different branches in parallel

```bash
# Add a worktree for a branch
git worktree add ../hotfix-workspace hotfix/critical-bug

# Add a worktree creating a new branch
git worktree add -b feat/new-feature ../feature-workspace origin/main

# List all worktrees
git worktree list

# Remove a worktree (when done)
git worktree remove ../hotfix-workspace

# Prune references to deleted worktrees
git worktree prune

# Lock a worktree (prevent pruning)
git worktree lock ../hotfix-workspace --reason "active hotfix"
```

### Worktree Rules

- A branch can only be checked out in ONE worktree at a time
- All worktrees share the same `.git` repository
- `git worktree prune` before creating new worktrees (hygiene)
- Remove worktrees when done — do not leave stale worktrees

## Submodules

```bash
# Add a submodule
git submodule add https://github.com/owner/repo path/to/submodule

# Clone a repo with submodules
git clone --recurse-submodules {url}

# Initialize submodules after clone (if not done)
git submodule update --init --recursive

# Update all submodules to latest remote
git submodule update --remote

# Update a specific submodule
git submodule update --remote path/to/submodule

# Remove a submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
rm -rf .git/modules/path/to/submodule
```

## Tags

```bash
# Create annotated tag (use for releases)
git tag -a v1.2.0 -m "Release v1.2.0"

# Create lightweight tag
git tag v1.2.0

# Push tag to remote
git push origin v1.2.0

# Push all tags
git push origin --tags

# List tags
git tag -l "v1.*"

# Delete local tag
git tag -d v1.2.0

# Delete remote tag
git push origin :refs/tags/v1.2.0

# Show tag details
git show v1.2.0
```

## Git Clean (Remove Untracked Files)

```bash
# Preview what would be removed
git clean -nd

# Remove untracked files
git clean -fd

# Remove untracked files AND ignored files
git clean -fdx

# Remove only ignored files (useful for cleaning build artifacts)
git clean -fdX
```

**Safety**: Always run `git clean -nd` first to preview. This operation is destructive.

## Sparse Checkout (Large Monorepos)

Check out only part of a repository:

```bash
# Enable sparse checkout
git sparse-checkout init --cone

# Specify which paths to check out
git sparse-checkout set src/service-a src/shared

# Add more paths
git sparse-checkout add src/service-b

# Show current sparse checkout config
git sparse-checkout list

# Disable sparse checkout (get everything)
git sparse-checkout disable
```

## Hooks

```bash
# Hooks live in .git/hooks/ (not version controlled)
# Shareable hooks go in .githooks/ (version controlled)
git config core.hooksPath .githooks

# Common hooks
.githooks/pre-commit      # runs before commit (lint, test)
.githooks/commit-msg      # validates commit message
.githooks/pre-push        # runs before push (test suite)
.githooks/post-checkout   # runs after branch switch
```

Example pre-commit hook:
```bash
#!/usr/bin/env bash
npm run lint --silent
npm test --silent
```
