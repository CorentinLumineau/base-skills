# Branching Strategies

<!-- ported from mercure-plugin/skills/delivery-release-git/references/branching.md -->

## Overview

Branching strategies define how teams collaborate on code and manage releases. This reference covers common strategies and their appropriate use cases.

## Quick Reference (80/20)

| Strategy | Best For | Complexity |
|----------|----------|------------|
| Trunk-Based | Continuous deployment | Low |
| GitHub Flow | Web apps, frequent deploys | Low |
| GitFlow | Scheduled releases | High |
| Release Branches | Multiple versions supported | Medium |

## Patterns

### Pattern 1: Trunk-Based Development

**When to Use**: Teams practicing continuous deployment

**Example**:
```
main (trunk)
  │
  ├── Feature flags control releases
  │
  ├── commit: feat: add user profile
  │     └── Deployed immediately
  │
  ├── commit: feat: new checkout flow (behind flag)
  │     └── Deployed but disabled
  │
  └── commit: fix: resolve payment bug
        └── Deployed immediately

Short-lived branches (< 1 day):
  feature/quick-fix ──► main (via PR)
```

```bash
# Workflow
git checkout main
git pull origin main

# Create short-lived branch
git checkout -b feature/add-button

# Make changes and commit
git add .
git commit -m "feat: add submit button"

# Push and create PR
git push -u origin feature/add-button

# After review, merge to main
# Delete local branch
git branch -d feature/add-button
```

**Rules**:
- All commits to main are deployable
- Branches live less than 1-2 days
- Feature flags for incomplete features
- Comprehensive automated testing

**Anti-Pattern**: Long-lived feature branches.

### Pattern 2: GitHub Flow

**When to Use**: Web applications with frequent deployments

**Example**:
```
main ────────────────────────────────────►
  │         │              │
  │         │              └── PR #3: merged
  │         │
  │         └── PR #2: merged
  │
  └── feature/user-auth ──► PR #1: merged

Branches:
  feature/user-auth
  feature/payment-integration
  fix/login-bug
  hotfix/security-patch
```

**Rules**:
- Main is always deployable
- Branch from main for any change
- Pull requests for all merges
- Deploy after merge to main

**Anti-Pattern**: Direct commits to main without review.

### Pattern 3: GitFlow

**When to Use**: Products with scheduled releases

**Example**:
```
main ─────────────────────────────────────────────►
  │                    │                    │
  │                    └── v1.0.0           └── v2.1.0
develop ──────────────────────────────────────────►
  │      │       │                 │        │
  │      │       └── release/2.0 ──┘        │
  │      │             │                    │
  │      └── feature/payments ──────────────┘
  │
  └── feature/user-profiles
```

```bash
# Initialize GitFlow
git flow init

# Start feature
git flow feature start user-profiles
# Work on feature...
git flow feature finish user-profiles

# Start release
git flow release start 1.0.0
# Bugfixes only in release branch...
git flow release finish 1.0.0

# Hotfix for production
git flow hotfix start critical-fix
# Fix the issue...
git flow hotfix finish critical-fix
```

**Branch types**:
- `main`: Production releases only
- `develop`: Integration branch
- `feature/*`: New features
- `release/*`: Release preparation
- `hotfix/*`: Production fixes

**Anti-Pattern**: Feature development in release branches.

### Pattern 4: Release Branches

**When to Use**: Supporting multiple production versions

**Example**:
```
main ──────────────────────────────────────────────►
  │           │           │
  │           │           └── v3.x development
  │           │
  │           └── release/v2 ──────────────────────►
  │                  │        │        │
  │                  │        │        └── v2.2.1 (backport)
  │                  │        └── v2.2.0
  │                  └── v2.1.0
  │
  └── release/v1 ──────────────────────────────────►
           │        │
           │        └── v1.5.1 (security fix)
           └── v1.5.0 (LTS)
```

```bash
# Create release branch from main
git checkout main
git checkout -b release/v2

# Tag releases from release branch
git tag -a v2.1.0 -m "Release v2.1.0"
git push origin v2.1.0

# Backport security fixes
git checkout release/v1
git cherry-pick <security-fix-commit>
git tag -a v1.5.1 -m "Security fix"
```

**Rules**:
- Each major version has a release branch
- Security fixes backported as needed
- Features only go to main
- Clear version support policy

**Anti-Pattern**: Maintaining too many version branches.

### Pattern 5: Monorepo Branching

**When to Use**: Multiple projects in single repository

**Example**:
```yaml
# CI with path filters
# .github/workflows/ci.yml
on:
  push:
    branches: [main]
    paths:
      - 'services/api/**'
      - 'libs/shared/**'
  pull_request:
    paths:
      - 'services/api/**'
      - 'libs/shared/**'

jobs:
  api-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test --workspace=services/api
```

**Anti-Pattern**: Single CI pipeline for all modules.

## Checklist

- [ ] Strategy matches team size and release cadence
- [ ] Branch protection rules configured
- [ ] CI/CD triggers match branch strategy
- [ ] Clear naming conventions established
- [ ] Merge strategy defined (squash/rebase/merge)
- [ ] Branch cleanup automated
- [ ] Release tagging process defined
- [ ] Hotfix process documented
- [ ] Team trained on chosen strategy
- [ ] Strategy documented in CONTRIBUTING.md
