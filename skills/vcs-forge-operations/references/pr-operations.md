# PR Operations

Pull request creation, review, and merge patterns.

## PR Lifecycle

```
BRANCH → PUSH → OPEN PR → REVIEW → APPROVE → MERGE → CLEANUP
```

## Creating a PR

### GitHub (gh)

```bash
# Full PR with all metadata
gh pr create \
  --title "feat(auth): add OAuth2 PKCE flow" \
  --body "$(cat <<'EOF'
## Summary

- Adds PKCE code challenge/verifier to authorization flow
- Removes implicit grant (deprecated per RFC 9700)
- Updates client configuration documentation

## Test plan

- [ ] Unit tests: `npm test src/auth`
- [ ] Integration: `npm run test:integration -- --grep oauth`
- [ ] Manual: test login flow with dev client credentials

## Breaking changes

Clients using implicit grant must migrate to authorization code + PKCE.
Migration guide: docs/auth-migration.md

Fixes #142
EOF
)" \
  --base main \
  --assignee "@me" \
  --reviewer @security-team \
  --label "feature,auth" \
  --draft
```

### PR Body Best Practices

A good PR body answers:
1. **What**: What does this change?
2. **Why**: Why is this change needed?
3. **How**: High-level approach (for complex changes)
4. **Test plan**: How to verify the change works
5. **Breaking changes**: What callers need to update

### Converting Draft to Ready

```bash
gh pr ready 123
```

## PR Review Workflow

### Checking Out a PR

```bash
# GitHub: fetch and checkout
gh pr checkout 123

# Or manually
git fetch origin pull/123/head:pr-123
git checkout pr-123
```

### Review Commands

```bash
# View PR diff
gh pr diff 123

# Add review comment (file + line)
gh pr review 123 --comment --body "Consider extracting this to a helper" 

# Request changes
gh pr review 123 --request-changes --body "Please add tests for the error case"

# Approve
gh pr review 123 --approve --body "LGTM - tests pass, approach is clean"
```

### Review Checklist

Before approving:
- [ ] Code does what the PR description says
- [ ] Tests cover the changes (new behavior has tests)
- [ ] No obvious security issues
- [ ] No breaking changes without documentation
- [ ] Commit message(s) follow conventions
- [ ] CI checks pass

## Merging

### Merge Strategies

| Strategy | When to use | Command |
|---------|------------|--------|
| Squash | Feature branches — single commit for clean history | `gh pr merge --squash` |
| Merge commit | Preserve branch history, complex features | `gh pr merge --merge` |
| Rebase | Prefer linear history without merge commits | `gh pr merge --rebase` |

**Recommendation**: Use squash for most feature/fix branches. The branch history is preserved
in the PR, and main stays linear.

```bash
# Squash merge with auto-delete branch
gh pr merge 123 --squash --delete-branch

# Rebase merge
gh pr merge 123 --rebase --delete-branch

# Auto-merge (when CI passes)
gh pr merge 123 --auto --squash --delete-branch
```

## PR Status and Checks

```bash
# List all checks for current PR
gh pr checks

# Watch until all checks pass
gh pr checks --watch

# Get checks in JSON
gh pr checks --json name,state,conclusion
```

## Updating a PR

```bash
# Update base branch (rebase)
gh pr update --base main

# Force push after rebase
git fetch origin main
git rebase origin/main
git push --force-with-lease origin feat/my-feature

# Update PR metadata
gh pr edit 123 \
  --title "New title" \
  --add-label "ready-for-review" \
  --remove-label "wip" \
  --add-reviewer @teammate
```

## Bulk PR Operations

```bash
# List all open PRs assigned to me
gh pr list --assignee "@me" --state open

# List PRs awaiting my review
gh pr list --search "review-requested:@me" --state open

# List all PRs by label
gh pr list --label "breaking-change" --state open

# Export PR list to JSON
gh pr list --json number,title,author,state,labels --limit 100
```

## PR Templates

Store PR templates at `.github/pull_request_template.md` (GitHub) or
`.gitlab/merge_request_templates/default.md` (GitLab):

```markdown
## Summary

{Describe what this PR changes and why}

## Test plan

- [ ] Unit tests pass (`npm test`)
- [ ] {Specific test for this change}

## Screenshots / output

{If UI change or CLI output, paste here}

## Checklist

- [ ] Tests added for new behavior
- [ ] Documentation updated
- [ ] No unintended scope creep
- [ ] Breaking changes documented
```

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Empty PR description | Reviewer has no context | Use PR template, explain what and why |
| >500 lines changed | Hard to review thoroughly | Split into smaller PRs |
| PR title = branch name | Meaningless to reviewers | Write a real title in present imperative |
| No test plan | Reviewer cannot verify correctness | Always include how to test |
| Merging without CI passing | Breaks main | Require status checks in branch protection |
| Never deleting merged branches | Repo accumulates stale branches | Enable auto-delete on merge |
