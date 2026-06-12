# History Navigation

Commands for exploring, investigating, and understanding git history.

## Basic Log Commands

```bash
# One-line summary with graph
git log --oneline --graph --decorate --all

# Compact view with author and date
git log --pretty=format:"%h %ad | %s%d [%an]" --date=short

# Show file changes per commit
git log --stat

# Show full diff per commit
git log -p

# Limit to last N commits
git log -10

# Filter by date
git log --since="2024-01-01" --until="2024-02-01"

# Filter by author
git log --author="Alice"

# Filter by message keyword
git log --grep="fix(auth)"
```

## Finding Specific Changes

```bash
# Find commits that added or removed a string
git log -S "functionName" --source --all

# Find commits that changed a line matching a pattern
git log -G "pattern" --source --all

# Find all commits touching a file
git log --follow -- path/to/file.ts

# Show when a file was deleted
git log --diff-filter=D -- path/to/deleted-file.ts
```

## Blame (Who Changed What)

```bash
# Who last changed each line
git blame src/auth/service.ts

# Show commit hash and author
git blame -l src/auth/service.ts

# Ignore whitespace-only changes
git blame -w src/auth/service.ts

# Blame a specific range of lines
git blame -L 42,68 src/auth/service.ts

# Follow through renames
git blame --follow src/auth/service.ts

# Show blame at a specific commit
git blame {commit-hash} -- src/auth/service.ts
```

## Comparing State

```bash
# Compare two branches (what is in feature but not main)
git diff main...feat/my-feature

# Compare two commits
git diff {hash1} {hash2}

# Compare specific file between branches
git diff main feat/my-feature -- src/auth/service.ts

# Show only file names that changed
git diff --name-only main...feat/my-feature

# Show files and change type (A=added, M=modified, D=deleted)
git diff --name-status main...feat/my-feature
```

## Bisect (Binary Search for Bugs)

Use when you know a bug was introduced between two commits:

```bash
# Start bisect session
git bisect start

# Mark current state as bad
git bisect bad HEAD

# Mark a known good state
git bisect good v1.2.0

# Git checks out the midpoint commit
# Test it: does the bug exist?

# If bad:
git bisect bad

# If good:
git bisect good

# Repeat until git identifies the culprit commit

# End session
git bisect reset
```

**Automated bisect** (when you have a test script):

```bash
# The script exits 0 for "good", non-zero for "bad"
git bisect run ./test-for-bug.sh
```

## Reflog (Undo Anything)

The reflog records every movement of HEAD — your safety net for lost commits:

```bash
# Show all recent HEAD movements
git reflog

# Show reflog for a specific branch
git reflog show feat/my-feature

# Recover a dropped commit
git reflog
# Find the hash from before the reset/rebase
git checkout {hash}  # detached HEAD to inspect
git cherry-pick {hash}  # apply it to current branch
# or
git reset --hard {hash}  # move branch back to that point
```

Reflog entries expire after 90 days by default.

## Searching Across All History

```bash
# Find any commit that touched a string (all branches, all time)
git log --all -S "deleteUser" --oneline

# Find a file that was deleted
git log --all --full-history -- "**/deleted-file.ts"

# Restore a deleted file from history
git checkout {commit-before-delete} -- path/to/file.ts

# Show the content of a file at a specific point in time
git show {commit-hash}:path/to/file.ts
git show HEAD~5:path/to/file.ts
```

## Shortcut References

| Ref | Meaning |
|-----|--------|
| `HEAD` | Current commit |
| `HEAD~1` | Parent of HEAD (one commit back) |
| `HEAD~N` | N commits back from HEAD |
| `HEAD^` | First parent of HEAD (same as `HEAD~1`) |
| `HEAD^2` | Second parent (for merge commits) |
| `{branch}@{1}` | Previous state of a branch (reflog) |
| `{hash}^{}` | Dereference tag to commit |
| `main..feat` | Commits in feat not in main |
| `main...feat` | Commits unique to either side |

## Git Log Format Reference

```bash
# Custom format specifiers
# %h  abbreviated hash
# %H  full hash
# %s  subject
# %b  body
# %an author name
# %ae author email
# %ad author date
# %cr relative date
# %d  decorations (branches, tags)

git log --pretty=format:"%h %cr %an: %s" --graph
```
