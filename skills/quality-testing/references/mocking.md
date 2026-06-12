# Mocking Patterns

<!-- ported from mercure-plugin/skills/quality-testing/ -->

Mocking allows isolation of the unit under test by replacing dependencies with controlled substitutes.

## Test Double Types

| Type | Purpose | Verifies Behavior? |
|------|---------|-------------------|
| Stub | Return canned values | No |
| Mock | Verify interactions | Yes |
| Spy | Record calls, use real impl | Yes |
| Fake | Working simplified impl | No |
| Dummy | Fill parameter slots | No |

## Mocking Decision Matrix

| Scenario | Recommended Double |
|----------|-------------------|
| External API calls | Stub/Mock |
| Database access | Fake (in-memory) |
| Time-dependent code | Stub (fake timers) |
| Event verification | Mock/Spy |
| Complex collaborator | Fake |
| Unused parameter | Dummy |

## Stubs — Controlling Indirect Inputs

```typescript
class StubPricingService implements PricingService {
  private prices: Map<string, number> = new Map();

  setPrice(productId: string, price: number): void {
    this.prices.set(productId, price);
  }

  async getPrice(productId: string): Promise<number> {
    return this.prices.get(productId) ?? 0;
  }
}

// Usage
const pricingService = new StubPricingService();
pricingService.setPrice('PROD-001', 100);
const orderService = new OrderService(pricingService);
```

Anti-pattern: Stubs that return the same value for all inputs regardless of context.

## Mocks — Verifying Interactions

```typescript
describe('NotificationService', () => {
  it('should send email when user registers', async () => {
    const emailSender = { send: jest.fn().mockResolvedValue(true) };
    const service = new NotificationService(emailSender);

    await service.notifyRegistration({ email: 'test@example.com', name: 'Test' });

    expect(emailSender.send).toHaveBeenCalledTimes(1);
    expect(emailSender.send).toHaveBeenCalledWith({
      to: 'test@example.com',
      subject: 'Welcome!',
      template: 'registration',
    });
  });
});
```

Anti-pattern: Verifying implementation details instead of observable behavior.

## Spies — Recording Without Replacing

```typescript
describe('MetricsCollector', () => {
  it('should increment counter on success', async () => {
    const realMetrics = new MetricsService();
    const incrementSpy = jest.spyOn(realMetrics, 'increment');

    await service.processWithMetrics(data);

    expect(incrementSpy).toHaveBeenCalledWith('operations.success');
    // Real implementation still ran
  });
});
```

## Fakes — Working In-Memory Implementations

```typescript
class FakeUserRepository implements UserRepository {
  private users: Map<string, User> = new Map();

  async save(user: User): Promise<void> {
    this.users.set(user.id, user);
  }

  async findById(id: string): Promise<User | null> {
    return this.users.get(id) || null;
  }

  async findByEmail(email: string): Promise<User | null> {
    return Array.from(this.users.values()).find(u => u.email === email) || null;
  }

  // Test helpers
  clear(): void { this.users.clear(); }
  seed(users: User[]): void { users.forEach(u => this.users.set(u.id, u)); }
}
```

Anti-pattern: Fakes that diverge from the real implementation's behavior.

## Fake Timers

```typescript
describe('RetryService', () => {
  it('should retry 3 times with exponential backoff', async () => {
    jest.useFakeTimers();

    const operation = jest.fn()
      .mockRejectedValueOnce(new Error('fail 1'))
      .mockRejectedValueOnce(new Error('fail 2'))
      .mockResolvedValueOnce({ success: true });

    const promise = retryService.withRetry(operation, { maxAttempts: 3 });

    jest.advanceTimersByTime(100);   // First retry delay
    jest.advanceTimersByTime(200);   // Second retry delay

    const result = await promise;
    expect(result.success).toBe(true);
    expect(operation).toHaveBeenCalledTimes(3);

    jest.useRealTimers();
  });
});
```

## Module-Level Mocking (Jest)

```typescript
// Mock entire module
jest.mock('../services/emailService', () => ({
  sendEmail: jest.fn().mockResolvedValue({ messageId: 'test-123' }),
}));

// Partial mock — preserve real implementation for some exports
jest.mock('../utils/crypto', () => ({
  ...jest.requireActual('../utils/crypto'),
  generateToken: jest.fn().mockReturnValue('test-token'),
}));
```

Anti-pattern: Mocking internal implementation modules rather than interface boundaries.

## Mocking Boundaries

| Boundary | Mock It? | Reason |
|----------|----------|--------|
| External HTTP APIs | Yes | Slow, unreliable, costs money |
| Databases (unit tests) | Yes | Need isolation |
| Databases (integration) | No | Need real behavior |
| Internal service classes | Rarely | Prefer fake over mock |
| Pure utility functions | Never | Test them directly |
| Time (Date.now) | Yes | Determinism |

## Common Pitfalls

| Pitfall | Impact | Fix |
|---------|--------|-----|
| Over-mocking | Tests pass but code is broken | Use fakes for complex collaborators |
| Mocking private methods | Tests implementation details | Test observable behavior only |
| Shared mock state | Flaky tests | Reset mocks in beforeEach |
| Missing mock reset | Unexpected interactions | Use jest.clearAllMocks() |
| No mock verification | Silent failures | Assert on mock calls |
