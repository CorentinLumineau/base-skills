# Architecture Domain — Analysis Checks

Assess structural health: coupling, layering, and dependency patterns.

## Layer Violations

A layer violation occurs when code bypasses the expected dependency direction.

**Common patterns**:
- Business logic layer directly importing DB query functions (bypasses repository layer)
- Presentation layer containing business rules (controllers with complex conditionals)
- Data access code importing HTTP client utilities or UI helpers

Detection: check import/require statements — does the direction match the intended layering?

Severity: HIGH if crossing a major architectural boundary; MEDIUM for minor shortcuts

## Circular Dependencies

**Signs**: Module A imports B, B imports C, C imports A.

Detection:
- Follow import chains — if you return to the starting module, it is circular
- Tools: `madge` (JS/TS), `pydeps` (Python), `go vet` (Go)

Severity: HIGH — causes initialization failures, tight coupling, refactoring pain

## High Coupling

A component is highly coupled when it knows too much about the internals of another.

**Signs**:
- Direct access to internal fields of another class (not through methods)
- Calling 5+ methods of the same external class from one caller
- Knowledge of external class implementation details (not just interface)

Severity: MEDIUM — increases change amplification ("touching X always breaks Y")

## Abstraction Level Mismatches

**Signs**:
- High-level business logic file that also handles low-level string parsing
- A "service" that both orchestrates business logic AND manages DB transactions
- Mixed levels of abstraction within a single function

Severity: MEDIUM — reduces readability and increases SRP violation risk

## Reporting

Only flag issues you can point to concretely (file and component name).
"The architecture feels messy" is not a finding.
For large codebases: focus on modules that change most frequently (80/20 principle).
