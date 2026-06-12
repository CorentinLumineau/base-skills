# CLI Equivalences

Cross-forge CLI command mapping for GitHub (gh), GitLab (glab), Gitea (tea), and REST API fallbacks.

## Pull Request / Merge Request Operations

| Operation | gh (GitHub) | glab (GitLab) | tea (Gitea) | REST API |
|-----------|------------|--------------|------------|---------|
| Create PR | `gh pr create` | `glab mr create` | `tea pr create` | POST /pulls |
| List PRs | `gh pr list` | `glab mr list` | `tea pr list` | GET /pulls |
| View PR | `gh pr view {n}` | `glab mr view {n}` | `tea pr show {n}` | GET /pulls/{n} |
| Checkout PR | `gh pr checkout {n}` | `glab mr checkout {n}` | `tea pr checkout {n}` | git fetch |
| Approve PR | `gh pr review {n} --approve` | `glab mr approve {n}` | (API only) | POST /reviews |
| Request changes | `gh pr review {n} --request-changes` | `glab mr review {n} --approve=false` | (API only) | POST /reviews |
| Merge PR | `gh pr merge {n} --squash` | `glab mr merge {n} --squash` | `tea pr merge {n}` | PUT /pulls/{n}/merge |
| Close PR | `gh pr close {n}` | `glab mr close {n}` | `tea pr close {n}` | PATCH /pulls/{n} |
| Add label | `gh pr edit {n} --add-label foo` | `glab mr label add {n} foo` | (API only) | POST /labels |

## Issue Operations

| Operation | gh (GitHub) | glab (GitLab) | tea (Gitea) | REST API |
|-----------|------------|--------------|------------|---------|
| Create issue | `gh issue create` | `glab issue create` | `tea issue create` | POST /issues |
| List issues | `gh issue list` | `glab issue list` | `tea issue list` | GET /issues |
| View issue | `gh issue view {n}` | `glab issue view {n}` | `tea issue show {n}` | GET /issues/{n} |
| Close issue | `gh issue close {n}` | `glab issue close {n}` | `tea issue close {n}` | PATCH /issues/{n} |
| Assign issue | `gh issue edit {n} --add-assignee @me` | `glab issue assign {n}` | (API only) | PATCH /issues/{n} |
| Add label | `gh issue edit {n} --add-label bug` | `glab issue label add {n} bug` | (API only) | POST /labels |

## Repository Operations

| Operation | gh (GitHub) | glab (GitLab) | tea (Gitea) | REST API |
|-----------|------------|--------------|------------|---------|
| Clone repo | `gh repo clone owner/repo` | `glab repo clone owner/repo` | `tea repo clone` | git clone |
| Fork repo | `gh repo fork owner/repo` | `glab repo fork owner/repo` | (API only) | POST /forks |
| View repo | `gh repo view` | `glab repo view` | `tea repo` | GET /repos/{owner}/{repo} |
| Create repo | `gh repo create` | `glab repo create` | `tea repo create` | POST /user/repos |
| Delete repo | `gh repo delete` | `glab repo delete` | (API only) | DELETE /repos/{owner}/{repo} |

## CI/CD Operations

| Operation | gh (GitHub) | glab (GitLab) | REST API |
|-----------|------------|--------------|---------|
| List workflows | `gh workflow list` | `glab ci list` | GET /actions/workflows |
| Run workflow | `gh workflow run {name}` | `glab ci run` | POST /actions/workflows/{id}/dispatches |
| List runs | `gh run list` | `glab ci status` | GET /actions/runs |
| View run logs | `gh run view {id} --log` | `glab ci view {id}` | GET /actions/runs/{id}/logs |
| Cancel run | `gh run cancel {id}` | (API only) | POST /actions/runs/{id}/cancel |
| Watch run | `gh run watch` | `glab ci view --follow` | (poll API) |

## Release Operations

| Operation | gh (GitHub) | glab (GitLab) | REST API |
|-----------|------------|--------------|---------|
| Create release | `gh release create v1.0.0` | `glab release create v1.0.0` | POST /releases |
| List releases | `gh release list` | `glab release list` | GET /releases |
| Upload asset | `gh release upload v1.0.0 file.zip` | `glab release upload v1.0.0 file.zip` | POST /assets |
| Delete release | `gh release delete v1.0.0` | `glab release delete v1.0.0` | DELETE /releases/{id} |

## Authentication Commands

| Operation | gh | glab | tea |
|-----------|---|----|-----|
| Login | `gh auth login` | `glab auth login` | `tea login add` |
| Status | `gh auth status` | `glab auth status` | `tea login list` |
| Set token | `gh auth login --with-token` | `glab auth login --stdin` | `tea login add --token` |

## GitHub-Specific Commands (no glab equivalent)

```bash
# Set repository secret
gh secret set SECRET_NAME --body "value"

# Configure branch protection
gh api repos/{owner}/{repo}/branches/main/protection --method PUT --input protection.json

# Enable/disable repository feature
gh api repos/{owner}/{repo} --method PATCH --field has_issues=true

# List repository collaborators
gh api repos/{owner}/{repo}/collaborators
```

## GitLab-Specific Commands (no gh equivalent)

```bash
# Set CI/CD variable
glab variable set KEY value

# List pipelines
glab ci list

# Create environment
glab api projects/{id}/environments --method POST --field name=production

# Protect branch via API
glab api projects/{id}/protected_branches --method POST \
  --field name=main \
  --field push_access_level=0 \
  --field merge_access_level=30
```
