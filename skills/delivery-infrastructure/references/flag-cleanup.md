# Feature Flag Cleanup

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/flag-cleanup.md -->

## Flag Lifecycle States

| State | Action | Trigger |
|-------|--------|---------|
| Active | Monitor and document | Flag in use, targeting active |
| Rolled Out | Schedule removal | 100% rollout for 2+ weeks |
| Stale | Alert and investigate | No config change in 30+ days |
| Expired | Remove from code | Past expiration date |
| Archived | Document learnings | Code cleanup complete |

## Flag Lifecycle Management

```yaml
flag_lifecycle:
  name: checkout-v2
  type: release
  created: "2024-01-15"
  owner: checkout-team
  expiration: "2024-04-15"  # Max 90 days for release flags

  states:
    - state: active
      rollout_percentage: 50
    - state: rolled_out       # When at 100% for 2+ weeks
      cleanup_deadline: "2024-03-01"
    - state: expired          # If cleanup_deadline passes
      alert: true
```

### Expiration Policy by Flag Type

| Flag Type | Max Lifetime | Enforcement |
|-----------|-------------|-------------|
| Release | 90 days | Auto-alert, then block deploys |
| Experiment | 60 days | Auto-conclude experiment |
| Ops | No expiry | Annual review |
| Kill Switch | No expiry | Quarterly verification |

## Detecting Stale Flags

### Code Scanning

```bash
# Find flags referenced in code but not in configuration
grep -rn "featureFlag\|isEnabled\|useFeature" src/ | \
  grep -oP "'([a-z-]+)'" | sort -u > code_flags.txt

# Compare with active flags in flag service
curl -s "$FLAG_SERVICE/api/flags" | jq -r '.[].key' | sort > active_flags.txt

# Stale = in code but not in service
comm -23 code_flags.txt active_flags.txt > stale_flags.txt
```

### AST-Based Detection (more accurate)

Parse source code AST to find flag references, then cross-reference with flag service. Detect:
- Flags in code but not in service (orphaned references)
- Flags in service but not in code (unused flags)
- Flags where evaluation always returns same value (permanently true/false)

## Automated Cleanup Pipeline

```yaml
# CI job to detect stale flags
flag-cleanup-check:
  schedule: "0 9 * * 1"  # Weekly Monday
  steps:
    - scan_codebase_for_flag_references
    - query_flag_service_for_active_flags
    - identify_stale_flags  # In code, not in service
    - identify_unused_flags  # In service, not in code
    - check_expiration_dates
    - create_cleanup_issues  # For flags past deadline
    - alert_owners  # Slack notification
```

## Code Cleanup Patterns

### Removing a Flag

1. **Verify** flag is 100% ON in all environments
2. **Search** all references: `grep -rn "flag-name" src/`
3. **Remove** conditional logic, keep the enabled path
4. **Remove** flag from configuration/service
5. **Delete** any A/B test event tracking for this flag
6. **Test** that the feature works without the flag
7. **Create PR** with cleanup as separate commit for easy revert

### Before/After Example

```typescript
// Before: flag check
if (featureFlags.isEnabled('new-checkout')) {
  return <NewCheckout />;
} else {
  return <OldCheckout />;
}

// After: flag removed (keep enabled path)
return <NewCheckout />;
```

## Technical Debt Dashboard

Track flag debt with these metrics:

| Metric | Target | Alert |
|--------|--------|-------|
| Total active flags | Track trend | >50 flags |
| Flags past expiration | 0 | Any expired |
| Average flag age | <30 days | >60 days average |
| Flags without owner | 0 | Any unowned |
| Stale flags (no change 30d) | <5 | >10 stale |

### Ownership Distribution

Every flag must have an owning team. Report flags per team and flag state distribution per team to identify teams accumulating flag debt.

## Checklist

- [ ] Expiration dates set on all release and experiment flags
- [ ] Automated stale flag detection running weekly
- [ ] Cleanup issues auto-created for expired flags
- [ ] Flag owners notified of upcoming expirations
- [ ] Code scanning integrated in CI
- [ ] Technical debt dashboard accessible
- [ ] Quarterly review of long-lived operational flags
- [ ] Flag removal tracked as part of sprint work
