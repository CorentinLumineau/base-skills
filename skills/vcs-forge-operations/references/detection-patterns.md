# Detection Patterns

Automated detection of which forge is in use, which CLI tools are available, and which API to call.

## Forge Detection Script

```bash
#!/usr/bin/env bash
# detect-forge.sh — outputs FORGE=github|gitlab|gitea|bitbucket|unknown

detect_forge() {
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null) || { echo "FORGE=unknown"; return; }

  case "$remote_url" in
    *github.com*)    echo "FORGE=github" ;;
    *gitlab.com*|*gitlab.*)  echo "FORGE=gitlab" ;;
    *gitea.*)        echo "FORGE=gitea" ;;
    *bitbucket.org*) echo "FORGE=bitbucket" ;;
    *)               echo "FORGE=unknown" ;;
  esac
}

detect_forge
```

Usage:
```bash
eval "$(./detect-forge.sh)"
echo "Forge is: $FORGE"
```

## CLI Availability Check

```bash
check_forge_cli() {
  local forge="$1"
  case "$forge" in
    github)    command -v gh   >/dev/null && echo "CLI=gh"   || echo "CLI=api" ;;
    gitlab)    command -v glab >/dev/null && echo "CLI=glab" || echo "CLI=api" ;;
    gitea)     command -v tea  >/dev/null && echo "CLI=tea"  || echo "CLI=api" ;;
    bitbucket) echo "CLI=api" ;;  # no standard CLI
    *)         echo "CLI=none" ;;
  esac
}
```

## API Base URL Detection

```bash
get_forge_api_url() {
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)

  case "$remote_url" in
    *github.com*)
      echo "API_URL=https://api.github.com"
      ;;
    *gitlab.com*)
      echo "API_URL=https://gitlab.com/api/v4"
      ;;
    ssh://*gitea*|https://*gitea*)
      # Extract host for self-hosted Gitea
      local host
      host=$(echo "$remote_url" | sed 's|.*@||;s|:.*||;s|/.*||')
      echo "API_URL=https://${host}/api/v1"
      ;;
    *)
      echo "API_URL=unknown"
      ;;
  esac
}
```

## Repository Context Extraction

```bash
# Extract owner and repo name from remote URL
get_repo_context() {
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)

  # SSH format: git@github.com:owner/repo.git
  # HTTPS format: https://github.com/owner/repo.git
  local repo_path
  repo_path=$(echo "$remote_url" | sed 's|.*github.com[:/]||;s|.*gitlab.com[:/]||;s|\.git$||')

  local owner repo
  owner=$(echo "$repo_path" | cut -d/ -f1)
  repo=$(echo "$repo_path" | cut -d/ -f2)

  echo "REPO_OWNER=$owner"
  echo "REPO_NAME=$repo"
}
```

## Full Detection Composite

```bash
#!/usr/bin/env bash
# forge-context.sh — sets FORGE, CLI, API_URL, REPO_OWNER, REPO_NAME

detect_all() {
  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null) || {
    echo "ERROR: not a git repository or no remote 'origin'"
    exit 1
  }

  # Determine forge
  case "$remote_url" in
    *github.com*)    FORGE=github ;;
    *gitlab.com*|*gitlab.*) FORGE=gitlab ;;
    *gitea.*)        FORGE=gitea ;;
    *bitbucket.org*) FORGE=bitbucket ;;
    *)               FORGE=unknown ;;
  esac

  # Determine CLI
  case "$FORGE" in
    github)    command -v gh   >/dev/null && CLI=gh   || CLI=api ;;
    gitlab)    command -v glab >/dev/null && CLI=glab || CLI=api ;;
    gitea)     command -v tea  >/dev/null && CLI=tea  || CLI=api ;;
    *)         CLI=api ;;
  esac

  # Extract repo context
  local repo_path
  repo_path=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)$|\1|;s|\.git$||')
  REPO_OWNER=$(echo "$repo_path" | cut -d/ -f1)
  REPO_NAME=$(echo "$repo_path" | cut -d/ -f2)

  echo "FORGE=$FORGE"
  echo "CLI=$CLI"
  echo "REPO_OWNER=$REPO_OWNER"
  echo "REPO_NAME=$REPO_NAME"
}

detect_all
```

## Authentication Status Check

```bash
# GitHub
gh auth status 2>&1

# GitLab
glab auth status 2>&1

# Check API token directly
curl -sf -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | jq .login
```

## Self-Hosted Forge Detection

For self-hosted instances, check the `FORGE_URL` environment variable convention:

```bash
# Convention: set FORGE_URL in CI environment
# e.g., FORGE_URL=https://git.company.internal

FORGE_HOST="${FORGE_URL:-$(git remote get-url origin | sed 's|.*@||;s|:.*||;s|/.*||')}"

# Try to detect forge type from response headers or well-known paths
if curl -sf "${FORGE_HOST}/api/v4/version" >/dev/null 2>&1; then
  FORGE=gitlab
elif curl -sf "${FORGE_HOST}/api/v1/version" >/dev/null 2>&1; then
  FORGE=gitea
fi
```
