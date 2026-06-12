# Forge Scripts

Automation scripts for common forge operations.

## PR Size Labeler

Automatically labels PRs by size based on lines changed:

```bash
#!/usr/bin/env bash
# label-pr-size.sh — labels current PR by diff size

PR_NUM="${1:-$(gh pr view --json number -q .number)}"

lines=$(gh pr diff "$PR_NUM" | wc -l)

if [ "$lines" -lt 50 ]; then
  size="size:XS"
elif [ "$lines" -lt 150 ]; then
  size="size:S"
elif [ "$lines" -lt 400 ]; then
  size="size:M"
elif [ "$lines" -lt 800 ]; then
  size="size:L"
else
  size="size:XL"
fi

# Remove any existing size label, add new one
gh pr edit "$PR_NUM" \
  --remove-label "size:XS,size:S,size:M,size:L,size:XL" \
  --add-label "$size" 2>/dev/null || true

echo "Labeled PR #$PR_NUM as $size ($lines diff lines)"
```

## PR Status Reporter

Reports CI status for all open PRs:

```bash
#!/usr/bin/env bash
# pr-status.sh — show status of all open PRs

echo "Open PR Status Report — $(date)"
echo "================================"

gh pr list --state open --json number,title,statusCheckRollup \
  | jq -r '.[] | "\(.number)\t\(.statusCheckRollup[0].state // "no-checks")\t\(.title)"' \
  | column -t -s $'\t'
```

## Stale Branch Cleaner

Lists and optionally deletes remote branches whose PRs have been merged:

```bash
#!/usr/bin/env bash
# clean-merged-branches.sh — list merged remote branches

DRY_RUN="${DRY_RUN:-true}"

echo "Merged remote branches:"
git fetch --prune

git branch -r --merged main | grep -v 'main$\|HEAD' | while read branch; do
  branch_name="${branch#origin/}"
  if [ "$DRY_RUN" = "false" ]; then
    git push origin --delete "$branch_name"
    echo "Deleted: $branch_name"
  else
    echo "Would delete: $branch_name"
  fi
done

if [ "$DRY_RUN" = "true" ]; then
  echo ""
  echo "Run with DRY_RUN=false to actually delete branches"
fi
```

## Release Creator

Creates a GitHub release with auto-generated changelog:

```bash
#!/usr/bin/env bash
# create-release.sh — create release from tag with changelog

VERSION="${1:?Usage: $0 <version> [previous-version]}"
PREV_VERSION="${2:-$(git describe --tags --abbrev=0 HEAD^)}"

echo "Creating release $VERSION (since $PREV_VERSION)"

# Generate changelog from commits
CHANGELOG=$(git log "${PREV_VERSION}..HEAD" \
  --pretty=format:"- %s (%h)" \
  --no-merges \
  | grep -E "^- (feat|fix|perf|refactor|docs):")

# Create release
gh release create "$VERSION" \
  --title "$VERSION" \
  --notes "$(cat <<EOF
## Changes since ${PREV_VERSION}

${CHANGELOG:-No changelog entries found}

**Full changelog**: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/compare/${PREV_VERSION}...${VERSION}
EOF
)" \
  --verify-tag
```

## PR Review Request Bot

Automatically requests review from CODEOWNERS for changed files:

```bash
#!/usr/bin/env bash
# request-code-owners.sh — request review from CODEOWNERS for changed files

PR_NUM="${1:-$(gh pr view --json number -q .number)}"

# Get changed files
CHANGED_FILES=$(gh pr view "$PR_NUM" --json files -q '.files[].path')

# Parse CODEOWNERS and find matching reviewers
# Requires: .github/CODEOWNERS file
REVIEWERS=()
while IFS= read -r file; do
  # Find matching CODEOWNERS entry
  while IFS= read -r owner_line; do
    pattern=$(echo "$owner_line" | awk '{print $1}')
    owners=$(echo "$owner_line" | awk '{$1=""; print $0}' | tr -d '@')
    if [[ "$file" == $pattern* ]]; then
      REVIEWERS+=($owners)
    fi
  done < .github/CODEOWNERS
done <<< "$CHANGED_FILES"

# Deduplicate and request
UNIQUE_REVIEWERS=$(echo "${REVIEWERS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ',')
if [ -n "$UNIQUE_REVIEWERS" ]; then
  gh pr edit "$PR_NUM" --add-reviewer "${UNIQUE_REVIEWERS%,}"
  echo "Requested review from: $UNIQUE_REVIEWERS"
fi
```

## Deployment Status Checker

Checks deployment status and notifies on PR:

```bash
#!/usr/bin/env bash
# check-deployment.sh — poll deployment and comment on PR

PR_NUM="${1:?Usage: $0 <pr-number> <deployment-url>"}"
DEPLOY_URL="${2:?}"
MAX_WAIT=300  # 5 minutes
INTERVAL=15

elapsed=0
while [ $elapsed -lt $MAX_WAIT ]; do
  status=$(curl -sf "${DEPLOY_URL}/health" | jq -r '.status' 2>/dev/null)
  if [ "$status" = "ok" ]; then
    gh pr comment "$PR_NUM" --body "Deployment verified: ${DEPLOY_URL} is healthy."
    exit 0
  fi
  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
done

gh pr comment "$PR_NUM" \
  --body "Deployment check timed out after ${MAX_WAIT}s. ${DEPLOY_URL} did not return healthy."
exit 1
```

## GitHub Actions Workflow Triggers

Common workflow trigger patterns:

```yaml
# Trigger on PR to main
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]

# Trigger on PR labeled
on:
  pull_request:
    types: [labeled]

# Manual trigger with inputs
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options: [staging, production]
      version:
        description: 'Version tag to deploy'
        required: true
```
