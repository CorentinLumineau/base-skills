# GitHub Actions

<!-- ported from mercure-plugin/skills/delivery-ci-cd-delivery/references/github-actions.md -->

## Overview

GitHub Actions enables CI/CD workflows directly in GitHub repositories. This reference covers workflow syntax, common patterns, and best practices for automation.

## Quick Reference (80/20)

| Concept | Purpose |
|---------|---------|
| Workflow | Automated process triggered by events |
| Job | Set of steps running on same runner |
| Step | Individual task within a job |
| Action | Reusable unit of code |
| Matrix | Run job with multiple configurations |
| Artifacts | Persist data between jobs |

## Patterns

### Pattern 1: Basic CI Workflow

**When to Use**: Standard test and build pipeline

**Example**:
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint
    strategy:
      matrix:
        node-version: [18, 20]
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
          fail_ci_if_error: true

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/
          retention-days: 7
```

**Anti-Pattern**: Not using caching, slow pipelines.

### Pattern 2: Reusable Workflows

**When to Use**: Sharing workflows across repositories

**Example**:
```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      version:
        required: true
        type: string
    secrets:
      AWS_ACCESS_KEY_ID:
        required: true
      AWS_SECRET_ACCESS_KEY:
        required: true
    outputs:
      deployment_url:
        description: URL of the deployment
        value: ${{ jobs.deploy.outputs.url }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    outputs:
      url: ${{ steps.deploy.outputs.url }}
    steps:
      - uses: actions/checkout@v4

      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/

      - name: Configure AWS
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to ${{ inputs.environment }}
        id: deploy
        run: |
          echo "url=https://${{ inputs.environment }}.example.com" >> $GITHUB_OUTPUT
```

**Anti-Pattern**: Duplicating workflow code across repositories.

### Pattern 3: Matrix Builds

**When to Use**: Testing across multiple configurations

**Example**:
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [18, 20, 22]
        exclude:
          - os: windows-latest
            node-version: 18
        include:
          - os: ubuntu-latest
            node-version: 20
            coverage: true

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test ${{ matrix.coverage && '-- --coverage' || '' }}

      - name: Upload coverage
        if: matrix.coverage
        uses: codecov/codecov-action@v4
```

**Anti-Pattern**: Testing all combinations when most are redundant.

### Pattern 4: Environment Protection

**When to Use**: Controlled deployments with approvals

**Example**:
```yaml
# Requires environment protection rules in GitHub settings
jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    steps:
      - name: Deploy to staging
        run: ./deploy.sh staging

  approval:
    runs-on: ubuntu-latest
    needs: deploy-staging
    environment: production-approval
    steps:
      - name: Approval checkpoint
        run: echo "Approved for production deployment"

  deploy-production:
    runs-on: ubuntu-latest
    needs: approval
    environment: production
    steps:
      - name: Deploy
        run: ./deploy.sh production
```

**Anti-Pattern**: Direct production deployments without protection.

### Pattern 5: Secrets and OIDC

**When to Use**: Handling sensitive data securely

**Example**:
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write  # For OIDC

    steps:
      - uses: actions/checkout@v4

      # Use OIDC instead of long-lived credentials
      - name: Configure AWS credentials (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789:role/GitHubActions
          aws-region: us-east-1

      - name: Deploy with secrets
        env:
          API_KEY: ${{ secrets.API_KEY }}
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
        run: |
          # Never echo secrets
          ./deploy.sh

      # Mask dynamic secrets
      - name: Generate and mask token
        run: |
          TOKEN=$(generate-token)
          echo "::add-mask::$TOKEN"
          echo "TOKEN=$TOKEN" >> $GITHUB_ENV
```

**Anti-Pattern**: Hardcoding secrets or echoing them in logs.

## Checklist

- [ ] Workflows triggered on appropriate events
- [ ] Concurrency configured to prevent duplicate runs
- [ ] Caching used for dependencies
- [ ] Matrix builds for cross-platform testing
- [ ] Reusable workflows for shared logic
- [ ] Environment protection for deployments
- [ ] Secrets properly managed (OIDC preferred over long-lived keys)
- [ ] Minimal permissions granted
- [ ] Artifacts retained appropriately
- [ ] Status checks required on PRs
