# Conflict Resolution

Patterns for resolving merge and rebase conflicts.

## Understanding Conflicts

A conflict occurs when two branches modify the same lines. Git cannot auto-merge and marks the file:

```
<<<<<<< HEAD
// Your version (current branch)
const timeout = 5000;
=======
// Incoming version (branch being merged/rebased)
const timeout = 3000;
>>>>>>> feature/faster-timeouts
```

Your job: choose one, combine both, or write something new — then remove all markers.

## Resolution Workflow

```bash
# 1. See all conflicted files
git status
# or
git diff --name-only --diff-filter=U

# 2. For each conflicted file:
#    a. Open in editor or merge tool
#    b. Resolve the markers
#    c. Stage the file

# 3. Verify no markers remain
grep -rn "<<<<<<" .
grep -rn ">>>>>>>" .

# 4. Continue the operation
git merge --continue     # if merging
git rebase --continue    # if rebasing
git cherry-pick --continue  # if cherry-picking
```

## Common Conflict Types

### Type 1: Simple value conflict

Both branches changed the same value differently. Choose one or write a new value:

```
<<<<<<< HEAD
const MAX_RETRIES = 3;
=======
const MAX_RETRIES = 5;
>>>>>>> origin/main
```

Resolution: Review both values, choose the correct one, delete markers.

### Type 2: Structural conflict (both added code at same location)

Both branches added code in the same area. Usually both changes should be kept:

```
<<<<<<< HEAD
function validateEmail(email: string): boolean {
  return /^[^@]+@[^@]+$/.test(email);
}
=======
function validatePhone(phone: string): boolean {
  return /^\d{10}$/.test(phone);
}
>>>>>>> feat/phone-validation
```

Resolution: Keep both functions (they do not conflict logically).

### Type 3: Delete vs modify

One branch deleted a file/line that the other branch modified. Most dangerous type:

```bash
# See what happened
git log --all --oneline -- {deleted-file}

# Check if the deletion was intentional
git show {delete-commit}:{deleted-file}

# If deletion was correct: remove the file and stage deletion
git rm {file}
# If modification was correct: keep the file
git checkout HEAD -- {file}
```

### Type 4: Rename conflict

One branch renamed a file while another modified it:

```bash
# Git may show as add+delete
git status

# Accept the rename and apply the changes
# Keep the new filename, discard the old-name version
git rm {old-file}
git add {new-file}
```

## Merge Tools

### Built-in (vimdiff / emerge)

```bash
git mergetool
```

### VS Code

```bash
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'
git mergetool
```

### IntelliJ / IDEA

Configure in: Settings → Version Control → Git → Merge Tool → IntelliJ IDEA.

### Meld (graphical)

```bash
git config --global merge.tool meld
git mergetool
```

## Rebase Conflict Strategy

During rebase, conflicts appear for each commit being replayed. Key difference from merge:
**HEAD is the commit being applied** (not your branch tip), and the "incoming" side is the
base branch.

```bash
# Conflict during rebase
# <<<<<<< HEAD shows: the base (origin/main)
# >>>>>>> shows: your commit being applied

# After resolving:
git add {file}
git rebase --continue

# Skip a commit if it is no longer needed (e.g., it was a fixup already applied)
git rebase --skip

# Abort the entire rebase
git rebase --abort
```

## Accepting One Side Entirely

```bash
# Accept "ours" (current branch) for a specific file
git checkout --ours -- {file}
git add {file}

# Accept "theirs" (incoming) for a specific file
git checkout --theirs -- {file}
git add {file}

# Accept ours for ALL conflicts (use with care)
git merge -X ours origin/main

# Accept theirs for ALL conflicts (use with care)
git merge -X theirs origin/main
```

## Lock File Conflicts

Package lock files (package-lock.json, yarn.lock, Pipfile.lock, go.sum) are common conflict sources.
The conflict in the lock file is almost never meaningful to resolve manually.

```bash
# For package-lock.json: accept one side, then regenerate
git checkout --ours -- package-lock.json
npm install  # regenerates the correct lock file
git add package-lock.json

# For yarn.lock
git checkout --ours -- yarn.lock
yarn install
git add yarn.lock
```

## Preventing Conflicts

| Practice | Effect |
|----------|--------|
| Small, frequent merges | Smaller conflict surface |
| Feature flags instead of long branches | Eliminates long-lived divergence |
| Clear module ownership (CODEOWNERS) | Reduces accidental parallel edits |
| Frequent `git fetch && git rebase origin/main` | Catches conflicts early |
| Avoid formatting changes mixed with logic changes | Separates whitespace-only conflicts |
