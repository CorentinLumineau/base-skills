# Quality Domain — Analysis Checks

Assess code quality against SOLID, DRY, and KISS principles.

## SOLID Violations

Detection patterns:

| Principle | Violation Signs | Severity |
|-----------|----------------|---------|
| **SRP** | Class with 2+ unrelated method groups; names like "Manager", "Helper", "Util" | CRITICAL |
| **OCP** | Switch/if-chains that grow with new types; feature flags in core business logic | HIGH |
| **LSP** | Subclass throws NotImplementedException; subclass changes base class behavior | CRITICAL |
| **ISP** | Interface with 5+ methods of which most callers use only 2 | MEDIUM |
| **DIP** | `new ConcreteClass()` deep in business logic; no injection point visible | HIGH |

## DRY Violations

- **>10 lines duplicated** (copy-paste with minor variations): HIGH
- **3-10 lines duplicated**: MEDIUM
- **Repeated magic values / constants** (same string or number in 3+ places): MEDIUM

Detection: search for identical blocks or similar blocks with only variable names changed.

## KISS Violations

- **Unnecessary complexity**: factory-builder-provider chains for a single implementation: MEDIUM
- **Deep nesting** (>3 levels of if/for/try): MEDIUM
- **Over-abstraction** with single consumer (wait for 3+ consumers before abstracting): MEDIUM

## Complexity Red Flags

- Method > 50 lines: candidate for extraction
- Class > 300 lines: likely SRP violation
- More than 3 parameters on a function: consider a parameter object
- Boolean flag parameters: usually two functions in one
- Cyclomatic complexity > 10: hard to test, hard to reason about

## Reporting

Flag only findings you can point to concretely (file and line/class/function name).
"The code feels complex" is not a finding. "UserService.processPayment() has 3 unrelated
responsibilities: logging, validation, and persistence" is a finding.
