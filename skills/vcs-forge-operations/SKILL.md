---
name: vcs-forge-operations
description: >
  Use when interacting with code forges (GitHub, GitLab, Gitea, Bitbucket) via CLI or API:
  creating and reviewing pull requests, managing issues, configuring branch protection,
  triggering CI/CD pipelines, and automating forge workflows via scripts.
  Covers detection of which forge is in use, CLI equivalences, and scripting patterns.
  Do NOT use for local git operations (use vcs-git-workflows) or commit message formatting
  (use vcs-conventional-commits).
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that has access to forge CLI tools
  (gh, glab, tea) or HTTP APIs.
metadata:
  type: knowledge
  domain: vcs
allowed-tools:
  - Read
  - Write
  - Bash
---

<!-- ported from mercure-plugin/skills/vcs-forge-operations/ -->

# Forge Operations

**triggers**: Creating a PR, reviewing a PR, managing issues, configuring branch protection,
automating forge workflows, detecting which forge is in use

## Forge Detection

See [references/detection-patterns.md](references/detection-patterns.md) for automated forge detection.

### Detection Heuristics

```bash
# Check git remote URL
git remote get-url origin

# Patterns
github.com      → GitHub (use gh CLI)
gitlab.com      → GitLab (use glab CLI)
gitea.*/        → Gitea (use tea CLI or REST API)
bitbucket.org   → Bitbucket (use REST API or bb CLI)
```

### Check Installed CLIs

```bash
command -v gh   && echo "GitHub CLI available"
command -v glab && echo "GitLab CLI available"
command -v tea  && echo "Gitea CLI available"
```

## Pull Requests

See [references/pr-operations.md](references/pr-operations.md) for full PR management reference.

### Create a PR

**GitHub (gh)**:
```bash
gh pr create \
  --title "feat(auth): add OAuth2 PKCE flow" \
  --body "$(cat <<'EOF'
## Summary
- Adds PKCE code challenge to OAuth2 authorization flow
- Removes implicit grant support (deprecated per RFC 9700)

## Test plan
- [ ] Unit tests pass
- [ ] OAuth2 integration test passes
- [ ] Manual test with dev client
EOF
)" \
  --base main \
  --draft
```

**GitLab (glab)**:
```bash
glab mr create \
  --title "feat(auth): add OAuth2 PKCE flow" \
  --description "$(cat mr-description.md)" \
  --target-branch main \
  --draft
```

### Review and Merge

```bash
# GitHub: list open PRs
gh pr list --state open

# View specific PR
gh pr view 123

# Check out PR branch locally
gh pr checkout 123

# Approve
gh pr review 123 --approve

# Merge (squash)
gh pr merge 123 --squash --delete-branch
```

### PR Status Checks

```bash
# List CI status for current branch
gh pr checks

# Wait for checks to complete
gh pr checks --watch

# List failed checks
gh pr checks | grep -v pass
```

## Issues

See [references/issue-operations.md](references/issue-operations.md) for issue management reference.

### Create an Issue

```bash
# GitHub
gh issue create \
  --title "fix(api): handle null response from upstream" \
  --body "Description of the bug..." \
  --label "bug,priority:high" \
  --assignee "@me"

# GitLab
glab issue create \
  --title "fix(api): handle null response from upstream" \
  --description "..." \
  --label "bug" \
  --assignee {username}
```

### Manage Issues

```bash
# List open issues
gh issue list --state open --label "bug"

# Close with comment
gh issue close 42 --comment "Fixed in #45"

# Link PR to issue (GitHub: use "Fixes #42" in PR body)
```

## Branch Protection

### GitHub Branch Protection Rules

```bash
# Require PR reviews before merge
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews[required_approving_review_count]=1 \
  --field required_pull_request_reviews[dismiss_stale_reviews]=true \
  --field enforce_admins=true \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]="ci/test" \
  --field restrictions=null
```

**Recommended branch protection for main**:
- Require PR reviews: 1 approver minimum
- Dismiss stale reviews on new push
- Require status checks to pass (CI, lint, test)
- Require branches to be up to date
- Restrict who can push directly (no force push)

## CI/CD Integration

### Trigger Pipeline Manually

```bash
# GitHub: trigger workflow
gh workflow run ci.yml --ref main

# GitHub: view workflow runs
gh run list --workflow=ci.yml

# GitHub: view run logs
gh run view {run-id} --log

# GitLab: trigger pipeline
glab ci run --ref main
```

### Pipeline Status

```bash
# Watch current pipeline
gh run watch

# Get run status
gh run view {run-id} --json status,conclusion
```

## Forge Scripts

See [references/forge-scripts.md](references/forge-scripts.md) for automation scripts.

### Common Automation Patterns

**Auto-assign reviewer based on changed files**:
```bash
# GitHub Actions: use CODEOWNERS file
# .github/CODEOWNERS
src/auth/    @security-team
src/payment/ @payments-team @security-team
```

**Label PR based on size**:
```bash
lines=$(gh pr diff --patch | wc -l)
if [ "$lines" -lt 100 ]; then
  gh pr edit --add-label "size:S"
elif [ "$lines" -lt 400 ]; then
  gh pr edit --add-label "size:M"
else
  gh pr edit --add-label "size:L"
fi
```

## CLI Equivalences

See [references/cli-equivalences.md](references/cli-equivalences.md) for full cross-forge CLI mapping.

| Operation | GitHub (gh) | GitLab (glab) | Gitea (tea) |
|-----------|------------|--------------|------------|
| Create PR | `gh pr create` | `glab mr create` | `tea pr create` |
| List PRs | `gh pr list` | `glab mr list` | `tea pr list` |
| Merge PR | `gh pr merge` | `glab mr merge` | `tea pr merge` |
| Create issue | `gh issue create` | `glab issue create` | `tea issue create` |
| List issues | `gh issue list` | `glab issue list` | `tea issue list` |
| View CI status | `gh run list` | `glab ci status` | (API only) |

## Quality Checklist

Before merging a PR:
- [ ] All required status checks pass
- [ ] At least one reviewer approved
- [ ] Branch is up to date with base
- [ ] PR description explains what and why
- [ ] Breaking changes documented
- [ ] Linked issues will be closed on merge
