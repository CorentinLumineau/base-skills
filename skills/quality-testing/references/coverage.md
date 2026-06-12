# Test Coverage Strategies

<!-- ported from mercure-plugin/skills/quality-testing/ -->

Test coverage measures how much of your code is executed during testing.

## Coverage Types

| Metric | Description | Target |
|--------|-------------|--------|
| Line Coverage | Lines executed | 80%+ |
| Branch Coverage | Decision paths taken | 75%+ |
| Function Coverage | Functions called | 90%+ |
| Statement Coverage | Statements executed | 80%+ |
| Mutation Coverage | Tests catch code changes | 60%+ |

## Coverage Strategy by Code Type

| Code Type | Priority | Target Coverage |
|-----------|----------|-----------------|
| Business Logic | Critical | 90%+ |
| API Handlers | High | 85%+ |
| Utilities | High | 95%+ |
| Data Access | Medium | 80%+ |
| Configuration | Low | 60%+ |
| Generated Code | Skip | Exclude |

## Configuration

### Jest

```javascript
// jest.config.js
module.exports = {
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html', 'json-summary'],
  coverageThreshold: {
    global: { branches: 75, functions: 80, lines: 80, statements: 80 },
    './src/core/**/*.ts': { branches: 90, functions: 95, lines: 90, statements: 90 },
  },
  collectCoverageFrom: [
    'src/**/*.{js,ts}',
    '!src/**/*.d.ts',
    '!src/**/*.test.{js,ts}',
    '!src/**/index.{js,ts}',
    '!src/types/**/*',
    '!src/generated/**/*',
  ],
};
```

### Vitest

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
      thresholds: { lines: 80, functions: 80, branches: 75, statements: 80 },
      include: ['src/**/*.{ts,tsx}'],
      exclude: ['src/**/*.d.ts', 'src/**/*.test.{ts,tsx}', 'src/generated/**'],
      all: true,
      checkCoverage: true,
    }
  }
});
```

### NYC (Istanbul)

```json
{
  "nyc": {
    "check-coverage": true,
    "branches": 75, "lines": 80, "functions": 80, "statements": 80,
    "reporter": ["text", "lcov", "html"],
    "include": ["src/**/*.ts"],
    "exclude": ["**/*.d.ts", "**/*.test.ts", "src/generated/**"]
  }
}
```

Anti-pattern: No coverage thresholds or thresholds set too low/high.

## Branch Coverage Strategy

A function with 3 conditionals has 8 branches (2^3 combinations). Test each path explicitly:

```typescript
// This function has 3 branches to test
function processOrder(order: Order): Result {
  if (!isValidOrder(order)) return { status: 'INVALID' };
  if (order.isExpress) applyExpressShipping(order);
  if (order.couponCode) applyDiscount(order, order.couponCode);
  return { status: 'PROCESSED', order };
}

// Tests needed:
// 1. Invalid order
// 2. Valid, standard, no discount
// 3. Valid, express, no discount
// 4. Valid, standard, with discount
// 5. Valid, express, with discount
```

## Coverage Gap Analysis

Find uncovered lines:

```bash
# Generate HTML report
npx jest --coverage
open coverage/lcov-report/index.html

# Find files below threshold
npx jest --coverage --coverageThreshold='{"global":{"lines":80}}'
```

## Mutation Testing

Mutation testing verifies test quality by introducing bugs:

```bash
# Stryker (JS/TS)
npx stryker run

# Mutmut (Python)
mutmut run
mutmut results
```

Mutation score: percentage of mutations caught. Target 60%+.

## Common Pitfalls

- **Coverage theater**: 90% line coverage but only tests happy paths — add branch/mutation testing
- **Excluding too much**: Excluding non-trivial code inflates coverage metrics
- **Testing just for coverage**: Write tests to verify behavior, not just to hit numbers
- **No CI enforcement**: Coverage thresholds only matter if they fail the build
