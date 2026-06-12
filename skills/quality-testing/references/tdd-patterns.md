# Test-Driven Development Patterns

<!-- ported from mercure-plugin/skills/quality-testing/ -->

TDD: tests are written before the code they test. This reference covers the Red-Green-Refactor cycle and common TDD patterns.

## Quick Reference

| Pattern | When to Use | Benefit |
|---------|-------------|---------|
| Arrange-Act-Assert | All unit tests | Clear structure |
| Given-When-Then | BDD-style tests | Business readable |
| Test Doubles | External dependencies | Isolation |
| Parameterized Tests | Multiple inputs | Coverage |
| Property-Based | Edge cases | Exhaustive testing |

## Pattern 1: Red-Green-Refactor Cycle

```typescript
// RED: Write failing test first
describe('Calculator', () => {
  it('should add two numbers', () => {
    const calculator = new Calculator();
    expect(calculator.add(2, 3)).toBe(5);
  });
});
// This fails because Calculator doesn't exist yet

// GREEN: Write minimal code to pass
class Calculator {
  add(a: number, b: number): number {
    return a + b;
  }
}

// REFACTOR: Improve while keeping tests green
class Calculator {
  add(...numbers: number[]): number {
    return numbers.reduce((sum, n) => sum + n, 0);
  }
}
```

Anti-pattern: Writing production code before tests or skipping the refactor phase.

## Pattern 2: Arrange-Act-Assert (AAA)

```typescript
describe('UserService', () => {
  it('should create a user with valid data', async () => {
    // Arrange
    const repository = new InMemoryUserRepository();
    const service = new UserService(repository);
    const userData = { email: 'test@example.com', name: 'Test User' };

    // Act
    const result = await service.createUser(userData);

    // Assert
    expect(result.id).toBeDefined();
    expect(result.email).toBe(userData.email);
    expect(await repository.findById(result.id)).toBeTruthy();
  });
});
```

Anti-pattern: Mixing arrange/act/assert steps or having multiple acts in one test.

## Pattern 3: Given-When-Then (BDD Style)

```typescript
describe('ShoppingCart', () => {
  describe('given an empty cart', () => {
    let cart: ShoppingCart;
    beforeEach(() => { cart = new ShoppingCart(); });

    describe('when adding a product', () => {
      beforeEach(() => { cart.add(new Product('SKU-001', 'Widget', 10.00)); });

      it('then the cart should have one item', () => {
        expect(cart.itemCount).toBe(1);
      });
      it('then the total should equal the product price', () => {
        expect(cart.total).toBe(10.00);
      });
    });

    describe('when checking out', () => {
      it('then should throw EmptyCartError', () => {
        expect(() => cart.checkout()).toThrow(EmptyCartError);
      });
    });
  });
});
```

Anti-pattern: Overly nested describes or unclear given/when/then transitions.

## Pattern 4: Test Doubles

**Stub — provides canned responses:**
```typescript
class StubPricingService implements PricingService {
  getPrice(productId: string): Promise<number> {
    return Promise.resolve(10.00);  // Fixed price for testing
  }
}
```

**Mock — verifies interactions:**
```typescript
const emailSender = { send: jest.fn().mockResolvedValue(true) };
await service.notifyRegistration(user);
expect(emailSender.send).toHaveBeenCalledWith({
  to: 'test@example.com',
  subject: 'Welcome!',
});
```

**Fake — working in-memory implementation:**
```typescript
class FakeUserRepository implements UserRepository {
  private users: Map<string, User> = new Map();
  async save(user: User): Promise<void> { this.users.set(user.id, user); }
  async findById(id: string): Promise<User | null> { return this.users.get(id) || null; }
  clear(): void { this.users.clear(); }  // Test helper
}
```

Anti-pattern: Over-mocking leading to tests that pass but don't catch real bugs.

## Pattern 5: Parameterized Tests

```typescript
describe.each([
  { password: 'short', expected: false, reason: 'too short' },
  { password: 'nouppercase1!', expected: false, reason: 'no uppercase' },
  { password: 'Valid1Password!', expected: true, reason: 'valid' },
])('validate("$password")', ({ password, expected, reason }) => {
  it(`should return ${expected} because ${reason}`, () => {
    expect(validator.validate(password)).toBe(expected);
  });
});
```

Anti-pattern: Too many parameters making tests hard to understand.

## Pattern 6: Property-Based Testing

```typescript
import fc from 'fast-check';

describe('sort invariants', () => {
  it('sorted array has same length', () => {
    fc.assert(
      fc.property(fc.array(fc.integer()), (arr) => {
        const sorted = [...arr].sort((a, b) => a - b);
        return sorted.length === arr.length;
      })
    );
  });

  it('encode/decode round-trip', () => {
    fc.assert(
      fc.property(fc.string(), (str) => {
        return base64Decode(base64Encode(str)) === str;
      })
    );
  });
});
```

Anti-pattern: Using property-based tests where example-based tests are clearer.

## Pattern 7: Test Data Builders

```typescript
class UserBuilder {
  private user: Partial<User> = {
    id: 'default-id',
    email: 'default@example.com',
    name: 'Default User',
    role: 'user',
  };

  withEmail(email: string): this { this.user.email = email; return this; }
  asAdmin(): this { this.user.role = 'admin'; return this; }
  build(): User { return this.user as User; }
}

// Usage
const admin = new UserBuilder().withId('admin-1').asAdmin().build();
```

Anti-pattern: Test data scattered across files or magic values without explanation.

## Pattern 8: Testing Async Code

```typescript
it('should reject when user not found', async () => {
  await expect(service.findById('non-existent'))
    .rejects
    .toThrow(UserNotFoundError);
});

it('should retry failed operations', async () => {
  jest.useFakeTimers();
  const failThenSucceed = jest.fn()
    .mockRejectedValueOnce(new Error('fail'))
    .mockResolvedValueOnce({ id: 'user-1' });

  const promise = service.findByIdWithRetry('user-1');
  jest.advanceTimersByTime(2000);
  const result = await promise;
  expect(result.id).toBe('user-1');
  jest.useRealTimers();
});
```

Anti-pattern: Not handling async properly leading to flaky tests.

## Checklist

- [ ] Tests written before production code
- [ ] Each test covers single behavior
- [ ] Tests are independent (no shared state)
- [ ] Clear Arrange-Act-Assert structure
- [ ] Test doubles used appropriately
- [ ] Edge cases covered with parameterized tests
- [ ] Async code tested properly
- [ ] Test names describe expected behavior
- [ ] No test logic (conditionals, loops)
