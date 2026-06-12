# Feature Flag Implementation

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/flag-implementation.md -->

## Flag Types

| Type | Purpose | Lifetime | Example |
|------|---------|----------|---------|
| Release | Gradual feature rollout | Weeks-months | `new-checkout` |
| Experiment | A/B testing | Days-weeks | `checkout-variant-b` |
| Ops | Operational controls | Long-lived | `maintenance-mode` |
| Permission | Feature access control | Long-lived | `premium-feature` |
| Kill Switch | Emergency disable | Permanent | `disable-payments` |

## Feature Flag Service

### Core Interface

```typescript
interface FeatureFlagService {
  isEnabled(flagKey: string, context: EvaluationContext): boolean;
  getVariant(flagKey: string, context: EvaluationContext): string;
  getAllFlags(context: EvaluationContext): Record<string, boolean>;
}

interface EvaluationContext {
  userId: string;
  attributes: Record<string, any>;  // country, plan, role, etc.
}
```

### Evaluation Strategy

```typescript
function evaluate(flag: Flag, context: EvaluationContext): boolean {
  // 1. Kill switch override (always takes priority)
  if (flag.forceValue !== undefined) return flag.forceValue;

  // 2. User allowlist/blocklist
  if (flag.allowlist?.includes(context.userId)) return true;
  if (flag.blocklist?.includes(context.userId)) return false;

  // 3. Targeting rules (country, plan, etc.)
  for (const rule of flag.rules) {
    if (matchesRule(rule, context)) return rule.enabled;
  }

  // 4. Percentage rollout (deterministic hash)
  if (flag.percentage !== undefined) {
    const hash = deterministicHash(`${flag.key}:${context.userId}`);
    return (hash % 100) < flag.percentage;
  }

  // 5. Default value
  return flag.defaultValue;
}
```

### Deterministic Hashing

Use a deterministic hash so the same user always gets the same variant:

```typescript
function deterministicHash(input: string): number {
  // MurmurHash3 or similar — consistent across languages/platforms
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    hash = ((hash << 5) - hash) + input.charCodeAt(i);
    hash |= 0;
  }
  return Math.abs(hash);
}
```

## React Integration

```typescript
function useFeatureFlag(flagKey: string): boolean {
  const { flags } = useContext(FeatureFlagContext);
  return flags[flagKey] ?? false;
}

// Usage
function CheckoutPage() {
  const showNewCheckout = useFeatureFlag('new-checkout');
  return showNewCheckout ? <NewCheckout /> : <LegacyCheckout />;
}
```

## Server-Side Evaluation

```typescript
// Middleware pattern
function featureFlagMiddleware(req, res, next) {
  const context = { userId: req.user.id, attributes: { country: req.user.country, plan: req.user.plan } };
  req.flags = flagService.evaluateAll(context);
  next();
}

// Route handler
app.get('/api/checkout', featureFlagMiddleware, (req, res) => {
  if (req.flags['new-checkout-api']) {
    return newCheckoutHandler(req, res);
  }
  return legacyCheckoutHandler(req, res);
});
```

## Kill Switch Pattern

```typescript
// Immediate emergency disable — no gradual rollout
const KILL_SWITCHES = {
  'disable-payments': { description: 'Stop all payment processing', severity: 'critical' },
  'disable-signups': { description: 'Stop new user registration', severity: 'high' },
  'read-only-mode': { description: 'Disable all writes', severity: 'critical' },
};

function checkKillSwitch(key: string): boolean {
  // Kill switches bypass all targeting — immediate effect
  return flagService.isEnabled(key, { userId: 'system' });
}
```

## Percentage Rollout Strategy

| Phase | Percentage | Duration | Purpose |
|-------|-----------|----------|---------|
| Canary | 1% | 1 day | Catch critical issues |
| Early adopters | 10% | 3 days | Validate with small group |
| Partial | 50% | 1 week | Broader validation |
| Full | 100% | 2 weeks | Confirm stability before cleanup |

## Testing with Feature Flags

```typescript
describe('Checkout', () => {
  it('renders new checkout when flag enabled', () => {
    render(<CheckoutPage />, { flags: { 'new-checkout': true } });
    expect(screen.getByText('New Checkout')).toBeInTheDocument();
  });

  it('renders legacy checkout when flag disabled', () => {
    render(<CheckoutPage />, { flags: { 'new-checkout': false } });
    expect(screen.getByText('Legacy Checkout')).toBeInTheDocument();
  });
});
```

## Checklist

- [ ] Flag types categorized (release, experiment, ops, kill switch)
- [ ] Deterministic evaluation (same user = same result)
- [ ] Kill switches bypass all targeting rules
- [ ] Percentage rollout uses deterministic hashing
- [ ] Both flag paths tested in CI
- [ ] Flag metadata includes owner, expiration, description
- [ ] Caching with TTL for flag evaluations
- [ ] Metrics emitted on flag evaluation (for monitoring)
