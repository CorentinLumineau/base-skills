---
name: vcs-git-workflows
description: >
  Use when performing local git operations: branching strategies, rebasing, cherry-picking,
  resolving merge conflicts, navigating history, and managing worktrees.
  Covers Gitflow, trunk-based development, and feature branch workflows.
  Do NOT use for forge-specific operations like PR creation or CI pipeline management
  (use vcs-forge-operations instead).
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that can execute git commands
  in a local repository.
metadata:
  type: knowledge
  domain: vcs
allowed-tools:
  - Read
  - Write
  - Bash
---

<!-- ported from mercure-plugin/skills/vcs-git-workflows/ -->

# Git Workflows

**triggers**: Setting up a branching strategy, resolving merge conflicts, rebasing a branch,
cherry-picking a commit, investigating git history, working with worktrees

## Branching Strategies

### Trunk-Based Development (recommended for CI/CD)

```
main (trunk)
  ├── feat/short-lived-feature  ← merge within 1-2 days
  ├── fix/critical-bug          ← merge within hours
  └── release/v1.2             ← cut from main, hotfixes cherry-picked in
```

**Rules**:
- Feature branches live for <2 days — if longer, use feature flags
- All commits on trunk pass CI
- No long-lived branches except release branches
- Hotfixes go to main first, then cherry-picked to release branches

### Gitflow (for versioned releases)

```
main         ← production releases only (tagged)
develop      ← integration branch
  ├── feature/user-auth    ← merged into develop
  ├── release/v1.2         ← cut from develop, merged to main + develop
  └── hotfix/security-fix  ← cut from main, merged to main + develop
```

Use when: independent release cycles, multiple versions in production, long QA phases.

### Feature Branch Workflow

```
main
  ├── feat/add-payment-api   ← open a PR, merge via squash
  ├── fix/null-pointer-api   ← open a PR, merge via squash
```

Every change goes through a PR. No direct commits to main. Simple and effective for most teams.

## Branching Conventions

```
feat/{description}     ← new feature
fix/{description}      ← bug fix
refactor/{description} ← code restructuring
chore/{description}    ← maintenance, dependencies
docs/{description}     ← documentation only
hotfix/{description}   ← critical production fix
release/{version}      ← release preparation
```

## Rebase Patterns

See [references/rebase-patterns.md](references/rebase-patterns.md) for detailed rebase workflows.

### Interactive Rebase (clean up before PR)

```bash
# Squash last N commits
git rebase -i HEAD~3

# Rebase onto updated main
git fetch origin
git rebase origin/main

# Force push after rebase (use --force-with-lease, not --force)
git push --force-with-lease origin feat/my-feature
```

**Interactive rebase commands**:
- `pick` — keep commit as is
- `squash` / `s` — combine with previous commit
- `fixup` / `f` — combine, discard this commit's message
- `reword` / `r` — keep commit, edit message
- `drop` / `d` — delete commit

### Rebase Rules

- **Never rebase shared branches** (main, develop) — only rebase your own feature branches
- **Always `--force-with-lease` not `--force`** — prevents overwriting others' pushed commits
- **Rebase before PR**, not after — keep main's history linear

## Merge Conflict Resolution

See [references/conflict-resolution.md](references/conflict-resolution.md) for detailed conflict patterns.

### Conflict Workflow

```bash
# 1. Start merge/rebase — conflicts appear
git merge origin/main
# or
git rebase origin/main

# 2. See what is conflicted
git status

# 3. Resolve each conflict in your editor (look for <<<<<<< markers)
# Edit files to resolve

# 4. Mark resolved
git add {resolved-files}

# 5. Continue
git merge --continue
# or
git rebase --continue

# 6. Abort if stuck
git merge --abort
git rebase --abort
```

### Understanding Conflict Markers

```
<<<<<<< HEAD (your changes)
const timeout = 5000;
=======
const timeout = 3000;
>>>>>>> origin/main (incoming changes)
```

Remove the markers and keep the correct version (may be a combination of both).

### Merge Strategy Flags

```bash
# Use "ours" for all conflicts (keep current branch)
git merge -X ours origin/main

# Use "theirs" for all conflicts (take incoming)
git merge -X theirs origin/main

# Prefer line endings from ours (useful for whitespace conflicts)
git merge -X ignore-space-change origin/main
```

## History Navigation

See [references/history-navigation.md](references/history-navigation.md) for investigation commands.

### Key Commands

```bash
# Show commit history with graph
git log --oneline --graph --decorate --all

# Find commit that introduced a bug (binary search)
git bisect start
git bisect bad HEAD
git bisect good v1.2.0
# ... test each bisect step, mark good or bad
git bisect reset

# Find which commit changed a line
git blame src/auth/service.ts

# Find string in all history
git log -S "functionName" --source --all

# Show what changed in a commit
git show {commit-hash}

# Compare branches
git diff main...feat/my-feature
```

## Advanced Operations

See [references/advanced-operations.md](references/advanced-operations.md) for cherry-pick,
patch workflows, and worktree management.

### Cherry-Pick

```bash
# Apply single commit to current branch
git cherry-pick {commit-hash}

# Apply range of commits
git cherry-pick {start-hash}..{end-hash}

# Cherry-pick without committing (to edit first)
git cherry-pick --no-commit {hash}
```

### Worktrees (parallel work on multiple branches)

```bash
# Create worktree for hotfix
git worktree add ../hotfix-workspace hotfix/critical-bug

# List worktrees
git worktree list

# Remove when done
git worktree remove ../hotfix-workspace
git worktree prune  # clean stale references
```

## Undo and Recovery

```bash
# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (keep changes unstaged)
git reset HEAD~1

# Discard all local changes (DESTRUCTIVE)
git reset --hard HEAD

# Recover a dropped commit
git reflog
git checkout {hash}  # or git cherry-pick {hash}

# Undo a public commit (safe for shared branches)
git revert {hash}
```

**Safety rule**: `--hard` is destructive. Use `--soft` or `--mixed` when in doubt.
Use `git reflog` to find lost commits within 30 days.

## Stash

```bash
# Save work in progress
git stash push -m "WIP: half-done refactor"

# List stashes
git stash list

# Apply latest stash
git stash pop

# Apply specific stash
git stash apply stash@{2}

# Apply stash to a new branch
git stash branch feat/from-stash stash@{0}
```

## Quality Checklist

Before merging a branch:
- [ ] Branch rebased on latest main
- [ ] No unintended files in diff (`git diff main...HEAD`)
- [ ] Commit messages follow convention
- [ ] No debug code, console.log, or TODOs left behind
- [ ] Tests pass locally
