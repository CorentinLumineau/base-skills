# Changelog Management

<!-- ported from mercure-plugin/skills/delivery-release-git/references/changelog.md -->

## Overview

Changelogs communicate changes to users and developers. This reference covers changelog formats, automation, and best practices for maintaining release notes.

## Quick Reference (80/20)

| Section | Content |
|---------|---------|
| Added | New features |
| Changed | Modified features |
| Deprecated | Soon-to-be-removed features |
| Removed | Removed features |
| Fixed | Bug fixes |
| Security | Security patches |

## Patterns

### Pattern 1: Keep a Changelog Format

**When to Use**: Standard human-readable changelog

**Example**:
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v1.0.0.html).

## [Unreleased]

### Added
- User profile customization options
- Dark mode support

### Changed
- Improved performance of search queries

## [2.1.0] - 2024-01-15

### Added
- New payment gateway integration (#234)
- Export functionality for reports (#256)
- API rate limiting with configurable thresholds

### Changed
- Updated authentication flow to use OAuth 2.0
- Improved error messages for validation failures

### Deprecated
- Legacy XML export format (use JSON instead)

### Fixed
- Race condition in order processing (#278)
- Memory leak in long-running tasks (#291)

### Security
- Updated dependencies to patch CVE-2024-1234
- Added CSRF protection to all forms

## [1.0.0] - 2024-01-01

### Changed
- **BREAKING**: Authentication tokens now expire after 24 hours
- **BREAKING**: Renamed `/api/users` to `/api/v2/users`

### Removed
- **BREAKING**: Removed deprecated v1 API endpoints

[Unreleased]: https://github.com/user/repo/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/user/repo/compare/v1.0.0...v2.1.0
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

**Anti-Pattern**: Git log dumps instead of curated changelogs.

### Pattern 2: Automated Changelog Generation

**When to Use**: CI/CD integrated changelog

**Example**:
```json
// package.json
{
  "release": {
    "branches": ["main"],
    "plugins": [
      "@semantic-release/commit-analyzer",
      "@semantic-release/release-notes-generator",
      [
        "@semantic-release/changelog",
        {
          "changelogFile": "CHANGELOG.md"
        }
      ],
      [
        "@semantic-release/git",
        {
          "assets": ["CHANGELOG.md", "package.json"],
          "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
        }
      ],
      "@semantic-release/github"
    ]
  }
}
```

```javascript
// release.config.js - Custom configuration
module.exports = {
  branches: [
    'main',
    { name: 'beta', prerelease: true },
    { name: 'alpha', prerelease: true }
  ],
  plugins: [
    ['@semantic-release/commit-analyzer', {
      preset: 'conventionalcommits',
      releaseRules: [
        { type: 'docs', scope: 'README', release: 'patch' },
        { type: 'refactor', release: 'patch' },
        { type: 'style', release: 'patch' },
        { type: 'perf', release: 'patch' }
      ]
    }],
    ['@semantic-release/release-notes-generator', {
      preset: 'conventionalcommits',
      presetConfig: {
        types: [
          { type: 'feat', section: 'Features' },
          { type: 'fix', section: 'Bug Fixes' },
          { type: 'perf', section: 'Performance Improvements' },
          { type: 'docs', section: 'Documentation', hidden: true },
          { type: 'refactor', section: 'Code Refactoring', hidden: true }
        ]
      }
    }]
  ]
};
```

**Anti-Pattern**: Manual changelog updates that get forgotten.

### Pattern 3: Release Notes Template

**When to Use**: Structured release announcements

**Example**:
```markdown
# Release v2.1.0

**Release Date:** January 15, 2024

## Highlights

This release introduces dark mode support and significantly improves search performance.

## What's New

### Features
- **Dark Mode**: Added dark mode support with automatic system preference detection
- **Search**: Improved search with fuzzy matching and relevance scoring

### Bug Fixes
- Fixed issue where notifications weren't clearing properly
- Resolved memory leak in real-time updates

## Breaking Changes

None in this release.

## Deprecations

- The `GET /api/search` endpoint is deprecated. Use `POST /api/v2/search` instead.
  This endpoint will be removed in v3.0.0.

## Security Updates

- Updated `lodash` to patch prototype pollution vulnerability (CVE-2024-1234)

## Upgrade Instructions

```bash
npm update mypackage@2.1.0
```

No migration steps required for this release.
```

**Anti-Pattern**: Generic release notes without context.

### Pattern 4: API Changelog

**When to Use**: Documenting API changes

**Example**:
```markdown
# API Changelog

## 2024-01-15 (v2.1.0)

### New Endpoints

#### `POST /api/v2/search`
Full-text search with advanced filtering.

### Changed Endpoints

#### `GET /api/users/{id}`
- Added `preferences` field to response
- `lastLogin` now returns ISO 8601 format (was Unix timestamp)

### Deprecated Endpoints

#### `GET /api/search` - Deprecated
Use `POST /api/v2/search` instead. Will be removed in v3.0.0.

**Migration:**
```javascript
// Before
const results = await fetch('/api/search?q=term');

// After
const results = await fetch('/api/v2/search', {
  method: 'POST',
  body: JSON.stringify({ query: 'term' })
});
```
```

**Anti-Pattern**: Undocumented API changes.

### Pattern 5: Internal vs Public Changelog

**When to Use**: Different audiences for changes

Maintain two separate changelogs:
- **Internal**: Database changes, infrastructure updates, performance metrics, rollback procedures, known issues
- **Public**: User-facing features, improvements, bug fixes — no internal technical details

**Anti-Pattern**: Exposing internal details in public changelogs.

## Checklist

- [ ] Changelog format documented
- [ ] Conventional commits enforced
- [ ] Automated changelog generation configured
- [ ] Breaking changes clearly marked
- [ ] Security updates highlighted
- [ ] Migration guides provided
- [ ] API changes documented
- [ ] Internal/public separation as needed
- [ ] Links to issues/PRs included
- [ ] Release dates recorded
