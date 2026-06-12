---
name: delivery-release-git
description: >
  Use when managing releases, configuring Git workflows, or automating changelogs.
  Covers semantic versioning, conventional commits, branching strategies, PR best
  practices, Git hooks, and release automation tools (semantic-release, release-please,
  changesets, goreleaser).
  Do NOT use for CI/CD automation (use delivery-ci-cd-delivery) or infrastructure
  provisioning (use delivery-infrastructure).
license: MIT
compatibility: >
  Always-on knowledge skill. No special agent primitives required. Works with any
  agent that can author or review release workflows and git configuration.
metadata:
  type: knowledge
  domain: delivery
allowed-tools: Read Grep Glob
---

<!-- ported from mercure-plugin/skills/delivery-release-git/ -->

# Release & Git

Version management, Git workflows, commit conventions, and release automation.

## Quick Reference (80/20)

| Topic | Key Concepts |
|-------|-------------|
| **Semantic Versioning** | MAJOR.MINOR.PATCH -- breaking.feature.fix |
| **Conventional Commits** | `type(scope): description` -- feat, fix, docs, refactor, test, chore |
| **Trunk-based dev** | Short-lived branches (<1 day), feature flags, continuous deploy |
| **GitHub Flow** | Branch from main, PR, merge, deploy |
| **GitFlow** | develop + release + hotfix branches, scheduled releases |
| **Changelog** | Keep a Changelog format: Added, Changed, Deprecated, Removed, Fixed, Security |
| **PR best practices** | Small PRs, descriptive title, linked issues, required reviews |
| **Git hooks** | pre-commit (lint), commit-msg (format), pre-push (test) |
| **Release automation** | semantic-release, release-please, changesets, goreleaser |
| **Merge strategies** | Squash (clean history), rebase (linear), merge commit (preserves context) |

## Semantic Versioning (SemVer)

```
MAJOR.MINOR.PATCH (e.g., 2.1.3)
```

| Change Type | Version Bump |
|-------------|--------------|
| Breaking API change | MAJOR |
| New feature (backward compatible) | MINOR |
| Bug fix | PATCH |
| Documentation only | PATCH |
| Dependency update (non-breaking) | PATCH |
| Deprecation (still works) | MINOR |

## Conventional Commits

```
type(scope): description

Types: feat, fix, docs, refactor, test, chore, perf, ci, style, revert
```

| Type | Purpose | Version Bump |
|------|---------|-------------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `feat!` or `BREAKING CHANGE:` | Breaking change | MAJOR |
| `docs` | Documentation | None (or PATCH) |
| `refactor` | Code change (no bug fix, no feature) | None (or PATCH) |
| `test` | Adding/updating tests | None |
| `chore` | Maintenance tasks | None |
| `perf` | Performance improvement | PATCH |
| `ci` | CI configuration | None |

Examples:
- `feat(auth): add MFA support`
- `fix(api): handle null response`
- `feat(api)!: redesign auth endpoints` (breaking)
- `docs: update README`

## Git Branching Strategies

| Strategy | Best For | Complexity |
|----------|----------|------------|
| Trunk-Based | Continuous deployment, mature CI/CD | Low |
| GitHub Flow | Web apps, frequent deploys | Low |
| GitFlow | Scheduled releases, versioned products | High |
| Release Branches | Multiple supported versions | Medium |

### Trunk-Based Development

```
main (trunk)
  |-- commit: feat (deployed immediately)
  |-- commit: feat (behind flag, deployed but disabled)
  +-- short-lived branch (< 1 day) -> PR -> main
```

### GitHub Flow

```
main --------------------------------------------->
  |         |              |
  |         +-- PR #2      +-- PR #3
  +-- feature/user-auth -> PR #1
```

### GitFlow

```
main ------------------------------------------------>
  |                    |                    |
  |                    +-- v1.0.0           +-- v2.1.0
develop --------------------------------------------->
  |      |       |                 |
  |      |       +-- release/2.0 --+
  |      +-- feature/payments -----+
  +-- feature/user-profiles
```

## Merge vs Rebase

| Strategy | When | Trade-off |
|----------|------|-----------|
| Squash merge | Feature branches with messy commits | Clean history, loses granularity |
| Rebase | Linear history needed, small changes | Clean but rewrites history |
| Merge commit | Preserving branch context matters | Noisy but complete history |

## PR Best Practices

| Practice | Why |
|----------|-----|
| Small, focused PRs | Easier review, faster merge |
| Descriptive title | Clear intent at a glance |
| Link to issue/ticket | Traceability |
| Required reviews (1-2) | Quality gate |
| CI must pass | Prevent broken main |
| No force-push to main | Protect history |

## Git Hooks

| Hook | Purpose | Tool |
|------|---------|------|
| `pre-commit` | Lint, format, type check | husky + lint-staged |
| `commit-msg` | Enforce commit format | commitlint |
| `pre-push` | Run tests, prevent force-push | husky |

## Changelog & Release Checklist

Use Keep a Changelog format (Added, Changed, Deprecated, Removed, Fixed, Security). Pre-release: tests pass, changelog updated, version bumped. Release: tag version, build artifacts, push tag. Post-release: monitor, announce, merge back.

## Safe Git Practices

| Action | Risk |
|--------|------|
| Force push to main | Lost commits |
| Direct push to main | Skip review |
| Unsigned commits | Unknown author |
| Skip CI | Untested code |
| Delete release tags | Lost references |

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting release readiness findings against the Release Checklist with pass/fail per gate (e.g., "FAIL: changelog not updated for breaking change in feat(api)!")
- Using severity model: CRITICAL = BLOCK (breaking change without MAJOR bump, missing changelog entry), HIGH = WARN (unsigned commits, force-push to main), MEDIUM = INFO (suboptimal merge strategy, missing PR link)
- Validating version bump correctness against SemVer rules based on commit types in the release
- Providing versioning conformance summary with recommended version number and changelog section

## When to Load References

- **For branching strategy details**: See `references/branching.md`
- **For Git workflow patterns**: See `vcs-git-workflows` (peer skill)
- **For commit convention details**: See `vcs-conventional-commits` (peer skill)
- **For changelog automation**: See `references/changelog.md`
- **For release automation tools**: See `references/automation.md`
