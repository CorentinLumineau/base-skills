# Issue Operations

Issue creation, management, and triage patterns.

## Creating Issues

### GitHub

```bash
# Basic issue
gh issue create \
  --title "fix(api): handle null response from upstream service" \
  --body "$(cat <<'EOF'
## Bug description

When the upstream payment service returns a null response body,
our API throws an unhandled NullPointerException instead of returning 502.

## Steps to reproduce

1. Start dev environment
2. Set UPSTREAM_SERVICE_URL to a mock that returns null body
3. Send POST /api/payment
4. Observe 500 response instead of 502

## Expected behavior

502 Bad Gateway with error message: "upstream service returned empty response"

## Affected versions

All versions since v2.3.0 (introduced in #89)

## Logs

```
ERROR [2024-01-15 10:23:11] NullPointerException at PaymentService.java:142
```
EOF
)" \
  --label "bug,priority:high" \
  --assignee "@me" \
  --milestone "v2.4.0"
```

### Issue Templates

Store at `.github/ISSUE_TEMPLATE/`:

**Bug report** (`bug_report.md`):
```markdown
---
name: Bug report
about: Report a bug
labels: bug
---

## Describe the bug
{Clear description of what is wrong}

## Steps to reproduce
1. {Step 1}
2. {Step 2}
3. Observe {unexpected behavior}

## Expected behavior
{What should happen}

## Environment
- OS: {os}
- Version: {version}
- Browser (if applicable): {browser}

## Logs / screenshots
{Paste relevant output}
```

**Feature request** (`feature_request.md`):
```markdown
---
name: Feature request
about: Suggest a new feature or enhancement
labels: enhancement
---

## Problem this solves
{What problem does this address?}

## Proposed solution
{Your idea for the implementation}

## Alternatives considered
{Other approaches you thought about}

## Additional context
{Mockups, examples, related issues}
```

## Triage Operations

```bash
# List untriaged issues (no labels)
gh issue list --no-assignee --state open

# List all open bugs
gh issue list --label "bug" --state open

# Assign an issue
gh issue edit 42 --add-assignee @teammate

# Add label
gh issue edit 42 --add-label "priority:high"

# Set milestone
gh issue edit 42 --milestone "v2.4.0"

# Close with comment
gh issue close 42 --comment "Resolved in #45"

# Reopen
gh issue reopen 42
```

## Issue Labels

### Recommended Label Set

| Label | Color | Purpose |
|-------|-------|--------|
| `bug` | Red | Something is broken |
| `enhancement` | Blue | New feature or improvement |
| `documentation` | Green | Documentation update needed |
| `good first issue` | Purple | Suitable for new contributors |
| `help wanted` | Yellow | Extra attention needed |
| `priority:critical` | Dark red | Must fix immediately |
| `priority:high` | Red | Fix in current sprint |
| `priority:medium` | Orange | Fix in next sprint |
| `priority:low` | Gray | Nice to have |
| `wontfix` | Light gray | Will not be addressed |
| `duplicate` | Light gray | Duplicate of another issue |
| `blocked` | Dark orange | Cannot proceed until blocker resolved |

### Create Labels via API

```bash
# GitHub
gh api repos/{owner}/{repo}/labels --method POST \
  --field name="priority:critical" \
  --field color="B60205" \
  --field description="Must fix immediately"

# Sync labels from a definition file
cat labels.json | jq -c '.[]' | while read label; do
  gh api repos/{owner}/{repo}/labels --method POST --input - <<< "$label"
done
```

## Linking Issues and PRs

### GitHub auto-close keywords (in PR body or commit)

```
Fixes #42       → closes #42 when PR merges to default branch
Closes #42      → same
Resolves #42    → same
Fixes org/repo#42  → closes issue in different repo
```

### Manually link PR to issue

```bash
# Add development link via API
gh api repos/{owner}/{repo}/issues/42/timeline
# Or use the GitHub UI: "Development" section on issue sidebar
```

## Issue Search

```bash
# Issues mentioning a keyword
gh issue list --search "keyword in:title,body"

# Issues with no response (open, no comments, older than 7 days)
gh issue list --search "is:open comments:0 created:<$(date -d '7 days ago' +%Y-%m-%d)"

# My open issues across all repos
gh issue list --assignee "@me" --state open --repo "{owner}/*"

# Issues labeled as bugs created this month
gh issue list --label bug --search "created:>=$(date +%Y-%m-01)"
```

## Bulk Operations

```bash
# Close all issues with a specific label
gh issue list --label "stale" --state open --json number \
  | jq '.[].number' \
  | xargs -I{} gh issue close {} --comment "Closed: stale issue cleanup"

# Export issues to CSV
gh issue list --state all --json number,title,state,labels,assignees --limit 500 \
  | jq -r '.[] | [.number, .title, .state] | @csv'
```
