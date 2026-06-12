# Release Automation

<!-- ported from mercure-plugin/skills/delivery-release-git/references/automation.md -->

## Overview

Release automation reduces manual errors and accelerates delivery. This reference covers automated versioning, release pipelines, and deployment orchestration.

## Quick Reference (80/20)

| Tool | Purpose |
|------|---------|
| semantic-release | Automated versioning and publishing |
| release-please | Google's release automation |
| changesets | Monorepo versioning |
| goreleaser | Go binary releases |
| standard-version | Changelog and versioning |

## Patterns

### Pattern 1: Semantic Release

**When to Use**: Fully automated releases based on commits

**Example**:
```javascript
// .releaserc.js
module.exports = {
  branches: [
    'main',
    { name: 'next', prerelease: true },
    { name: 'beta', prerelease: true }
  ],
  plugins: [
    ['@semantic-release/commit-analyzer', {
      preset: 'conventionalcommits',
      releaseRules: [
        { breaking: true, release: 'major' },
        { type: 'feat', release: 'minor' },
        { type: 'fix', release: 'patch' },
        { type: 'perf', release: 'patch' },
        { scope: 'no-release', release: false }
      ]
    }],
    ['@semantic-release/release-notes-generator', { preset: 'conventionalcommits' }],
    ['@semantic-release/changelog', { changelogFile: 'CHANGELOG.md' }],
    '@semantic-release/npm',
    ['@semantic-release/git', {
      assets: ['CHANGELOG.md', 'package.json', 'package-lock.json'],
      message: 'chore(release): ${nextRelease.version}\n\n${nextRelease.notes}'
    }],
    '@semantic-release/github'
  ]
};
```

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    branches: [main, next, beta]

permissions:
  contents: write
  issues: write
  pull-requests: write
  id-token: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          persist-credentials: false

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - run: npm ci

      - name: Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npx semantic-release
```

**Anti-Pattern**: Manual version bumps in CI.

### Pattern 2: Release Please (Google)

**When to Use**: PR-based release workflow

**Example**:
```yaml
# .github/workflows/release-please.yml
on:
  push:
    branches: [main]

permissions:
  contents: write
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    outputs:
      release_created: ${{ steps.release.outputs.release_created }}
      tag_name: ${{ steps.release.outputs.tag_name }}
    steps:
      - uses: google-github-actions/release-please-action@v4
        id: release
        with:
          release-type: node
          package-name: myapp
          changelog-types: |
            [
              {"type":"feat","section":"Features","hidden":false},
              {"type":"fix","section":"Bug Fixes","hidden":false},
              {"type":"perf","section":"Performance","hidden":false}
            ]

  publish:
    needs: release-please
    if: ${{ needs.release-please.outputs.release_created }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          registry-url: 'https://registry.npmjs.org'
      - run: npm ci
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**Anti-Pattern**: Skipping the release PR review.

### Pattern 3: Monorepo Release (Changesets)

**When to Use**: Versioning multiple packages

**Example**:
```json
// .changeset/config.json
{
  "$schema": "https://unpkg.com/@changesets/config@3.0.0/schema.json",
  "changelog": ["@changesets/changelog-github", { "repo": "org/repo" }],
  "commit": false,
  "access": "public",
  "baseBranch": "main",
  "updateInternalDependencies": "patch"
}
```

```yaml
# .github/workflows/release.yml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - name: Create Release PR or Publish
        uses: changesets/action@v1
        with:
          version: npm run version
          publish: npm run release
          commit: 'chore: version packages'
          title: 'chore: version packages'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**Anti-Pattern**: Independent versioning without linked packages.

### Pattern 4: Go Releaser

**When to Use**: Go binary releases with multiple platforms

**Example**:
```yaml
# .goreleaser.yaml
version: 2

builds:
  - id: myapp
    main: ./cmd/myapp
    binary: myapp
    env:
      - CGO_ENABLED=0
    goos:
      - linux
      - darwin
      - windows
    goarch:
      - amd64
      - arm64
    ldflags:
      - -s -w
      - -X main.version={{.Version}}
      - -X main.commit={{.Commit}}

archives:
  - format: tar.gz
    name_template: "{{ .ProjectName }}_{{ .Version }}_{{ .Os }}_{{ .Arch }}"
    format_overrides:
      - goos: windows
        format: zip

checksum:
  name_template: 'checksums.txt'

changelog:
  sort: asc
  filters:
    exclude:
      - '^docs:'
      - '^test:'
      - '^ci:'

dockers:
  - image_templates:
      - "ghcr.io/org/myapp:{{ .Version }}"
      - "ghcr.io/org/myapp:latest"
    dockerfile: Dockerfile
```

```yaml
# .github/workflows/release.yml
on:
  push:
    tags:
      - 'v*'

permissions:
  contents: write
  packages: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - uses: goreleaser/goreleaser-action@v5
        with:
          version: latest
          args: release --clean
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Anti-Pattern**: Building binaries manually for each platform.

### Pattern 5: Release Gates

**When to Use**: Quality gates before release

**Example**:
```yaml
# .github/workflows/release-gates.yml
jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run tests
        run: npm test

      - name: Check code coverage
        run: |
          COVERAGE=$(npm run coverage:report | grep "All files" | awk '{print $4}')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80%"
            exit 1
          fi

      - name: Security scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

  approval:
    needs: [quality-gates]
    runs-on: ubuntu-latest
    environment: release-approval
    steps:
      - name: Approval checkpoint
        run: echo "Release approved"

  release:
    needs: approval
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Create release
        run: |
          gh release create v${{ inputs.version }} \
            --title "v${{ inputs.version }}" \
            --generate-notes
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Anti-Pattern**: Releasing without quality validation.

## Checklist

- [ ] Versioning automated based on commits
- [ ] Changelog generated automatically
- [ ] Release artifacts built in CI
- [ ] Quality gates enforce standards
- [ ] Environment approvals configured
- [ ] Rollback procedure automated
- [ ] Release notifications sent
- [ ] Artifacts signed and verified
- [ ] Release tested in staging first
- [ ] Documentation updated with release
