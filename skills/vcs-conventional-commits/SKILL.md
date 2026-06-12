---
name: vcs-conventional-commits
description: >
  Write and validate git commit messages following the Conventional Commits specification:
  structured type(scope): subject lines, optional body and footer, and breaking-change markers.
  Use when authoring a commit message, reviewing commit history, configuring commit linting,
  or enforcing release automation conventions
  (conventional commit, commit message, commit format, semantic versioning from commits,
  feat commit, fix commit, BREAKING CHANGE, commit scope, changelog generation).
compatibility: >
  Always-on knowledge skill. No special agent primitives required. Works with any agent
  that can author or review git commit messages.
---

<!-- ported from mercure-plugin/skills/vcs-conventional-commits/ -->

# Conventional Commits

**triggers**: Authoring a commit message, reviewing commit history style, configuring
`commitlint` or `commitizen`, generating changelogs, or enforcing release automation

## Why

Free-form commit messages break tooling that parses history for changelog generation and
semantic version bumps. Conventional Commits imposes a minimal grammar that lets automation
derive a release version from commits alone: breaking change → major, feat → minor, fix → patch.

## Commit Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Rules

- **type** is required; must be one of the types below
- **scope** is optional; a noun in parentheses identifying the code area (e.g., `auth`, `api`)
- **subject**: imperative mood, present tense ("add" not "added"), no period at end, ≤72 chars
- **body**: free prose, separated from subject by a blank line; wrap at 100 chars
- **footer**: `key: value` format on its own line; `BREAKING CHANGE:` or `Fixes #NNN`

### Breaking Changes

A commit is a breaking change if it:
- Contains `BREAKING CHANGE: <description>` in the footer, **OR**
- Appends `!` to the type: `feat!: remove deprecated endpoint`

Both forms are valid; the `!` form is preferred for visibility.

## Type Catalog

| Type | Release bump | When to use |
|------|-------------|-------------|
| `feat` | minor | Adds a new user-facing feature |
| `fix` | patch | Corrects a bug |
| `perf` | patch | Performance improvement (no behavior change) |
| `refactor` | none | Code restructuring with no behavior change |
| `test` | none | Add or correct tests |
| `docs` | none | Documentation only changes |
| `build` | none | Build system, dependency changes |
| `ci` | none | CI configuration and scripts |
| `chore` | none | Other changes that don't modify src/test files |
| `revert` | depends | Revert a previous commit |

**Rule**: If in doubt between `feat` and `fix`, ask: does this change add capability or correct
incorrect behavior? New capability → `feat`; broken-before-now → `fix`.

## Examples

```
# Minimal patch
fix(auth): prevent session token from expiring before TTL

# Feature with scope
feat(api): add rate-limit header to all responses

# Breaking change with !
feat!: remove XML response format

BREAKING CHANGE: XML format removed; clients must use JSON.
Fixes #142

# Revert
revert: feat(api): add rate-limit header

This reverts commit abc1234.
```

## Gate

Before finalizing any commit message, verify:
- [ ] Type is one of the 10 canonical types above
- [ ] Subject is imperative mood and ≤72 characters
- [ ] Breaking change uses `BREAKING CHANGE:` footer or `!` suffix on type
- [ ] Scope (if present) is a single noun, not a sentence
- [ ] No period at end of subject line

## Gotchas

- `chore` is not a catch-all — if the change adds a feature, use `feat` regardless of how small
- A commit message reading "fix: fixed the thing" is wrong on two counts: past tense and
  redundant type echo — write `fix(module): prevent null pointer on empty input` instead
- `BREAKING CHANGE` in the body (not footer) does not trigger automation — put it in the footer
- Scope collisions: using different scopes for the same area (`auth`, `authentication`, `login`)
  fragments changelogs; agree on one canonical scope per area
- Multiple types in one commit means the commit should be split

## Artifact

Commit message review: "Type: {type} — OK/FAIL. Subject length: {N} — OK/FAIL.
Breaking change: {BREAKING CHANGE footer present / ! suffix / none}."
