# Rebase Patterns

Safe rebase workflows for clean git history.

## When to Rebase vs Merge

| Situation | Use | Reason |
|-----------|-----|--------|
| Updating feature branch with latest main | Rebase | Linear history, no merge commits |
| Merging feature branch into main | Merge (squash) or rebase | Depends on team preference |
| Fixing up commits before PR | Interactive rebase | Clean, reviewable commits |
| Public/shared branches | Merge only — never rebase | Rebase rewrites history |
| Hotfix onto release branch | Cherry-pick | Precision |

## Basic Rebase onto Main

```bash
# 1. Fetch latest
git fetch origin

# 2. Rebase feature branch onto main
git rebase origin/main

# 3. Resolve any conflicts
# Edit files, then:
git add {resolved-files}
git rebase --continue

# 4. Force push (safe variant)
git push --force-with-lease origin feat/my-feature
```

## Interactive Rebase: Cleaning Up Commits

Before opening a PR, clean up "WIP", "fixup", and typo commits:

```bash
# Rebase last 5 commits interactively
git rebase -i HEAD~5

# Or rebase everything since branching from main
git rebase -i $(git merge-base HEAD origin/main)
```

**In the editor** (`pick` = keep, `squash` = combine, `fixup` = combine+drop message, `reword` = edit message, `drop` = delete):

```
# Before
pick abc1234 feat(auth): add OAuth2 flow
pick def5678 WIP
pick ghi9012 fix typo
pick jkl3456 address review comments
pick mno7890 final cleanup

# After (rewrite to clean history)
pick abc1234 feat(auth): add OAuth2 flow
fixup def5678 WIP
fixup ghi9012 fix typo
fixup jkl3456 address review comments
fixup mno7890 final cleanup
```

Result: single clean commit `feat(auth): add OAuth2 flow`.

## Splitting a Commit

```bash
# Reset to before the commit (keep changes staged)
git reset HEAD~1

# Stage only the first logical change
git add src/auth/
git commit -m "feat(auth): add token validation"

# Stage second logical change
git add src/api/
git commit -m "feat(api): add auth middleware"
```

## Rebase with Autosquash

Commit with `fixup!` or `squash!` prefix to automatically squash into the matching commit:

```bash
# Make a fixup commit
git commit -m "fixup! feat(auth): add OAuth2 flow"

# Rebase with autosquash
git rebase -i --autosquash origin/main
```

The `fixup!` commit will be automatically moved and marked `fixup` in the interactive editor.

## Handling Rebase Conflicts

```bash
# Conflict appears during rebase
# Files with conflicts listed in git status

# See what is in conflict
git diff --name-only --diff-filter=U

# Open conflicted file, resolve markers
# <<<<<<< HEAD ... ======= ... >>>>>>> {hash}
vim {conflicted-file}

# Stage resolved file
git add {resolved-file}

# Continue
git rebase --continue

# If it is too complex, abort
git rebase --abort
```

## Preserving Merge Commits During Rebase

```bash
# Normally rebase linearizes history (drops merge commits)
# To preserve them:
git rebase --rebase-merges origin/main
```

## Upstream Rebase Recovery

When someone else rebased a shared branch (e.g., main was force-pushed):

```bash
# Fetch new base
git fetch origin

# Find where your branch diverged from old main
git merge-base HEAD ORIG_HEAD

# Rebase onto new main using original fork point
git rebase --onto origin/main {old-fork-point} feat/my-feature
```

## Safety Checklist

Before any interactive rebase:
- [ ] Branch is not shared with others (or they are all aware)
- [ ] Using `--force-with-lease`, not `--force`
- [ ] Recent `git fetch origin` completed
- [ ] `git reflog` is the recovery path if something goes wrong (commits recoverable for 30 days)

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| `git push --force` | Overwrites others' pushed commits | Always use `--force-with-lease` |
| Rebase main | Rewrites public history | Merge only on shared branches |
| Rebase with uncommitted work | Working tree conflicts | Stash first: `git stash push -m "before rebase"` |
| Interactive rebase on 50+ commits | Tedious conflict resolution | Squash whole branch to 1 commit: `git merge --squash` |
