---
name: code-code-quality
description: >
  Use when writing, reviewing, or refactoring code to ensure quality standards
  (SOLID, DRY, KISS, YAGNI, code review, refactoring, code smell, clean code).
  Enforces SOLID principles with violation severity levels, DRY/KISS/YAGNI rules,
  refactoring patterns, and code review practices.
  Do NOT use for API design patterns (use code-api-design) or error handling strategies (use code-error-handling).
allowed-tools: Read Grep Glob
metadata:
  license: MIT
  compatibility: always-on knowledge skill
---

<!-- ported from mercure-plugin/skills/code-code-quality/ -->

# Code Quality

Autonomous enforcement of development best practices for maintainable, scalable software.
Includes SOLID principles, refactoring catalog, and code review practices.

## Enforcement Definitions

**Severity Model**: CRITICAL/HIGH = BLOCK (must fix), MEDIUM = WARN (flag to user), LOW = INFO (note).

### SOLID Violations

| Principle | Violation | Severity | Detection |
|-----------|-----------|----------|-----------|
| SRP | Class/module has >1 reason to change (mixed concerns) | CRITICAL | >300 lines with multiple domains, mixed I/O and logic |
| OCP | Modifying existing code to add new behavior | HIGH | Switch/if-else chains for type dispatch, instanceof checks |
| LSP | Subtype breaks base type contract | CRITICAL | Overridden methods with different semantics, thrown unexpected errors |
| ISP | Fat interface forcing unnecessary implementations | MEDIUM | Empty/stub method implementations, "god interfaces" |
| DIP | High-level module depends on concrete implementation | HIGH | `new` in constructors, direct imports of concrete classes |

### DRY Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| Significant code duplication (>10 lines) | HIGH | Near-identical blocks across files or within same file |
| Minor code duplication (3-10 lines) | MEDIUM | Repeated patterns that should be extracted |
| Magic values repeated in multiple places | MEDIUM | Same literal values (strings, numbers) without named constants |
| Template code with trivial variations | MEDIUM | Copy-paste with only names or trivial values changed |

### KISS Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| Unnecessary complexity where simpler solution exists | HIGH | Factory-builder-provider chains, unnecessary indirection layers |
| Unnecessary nesting (>3 levels) | HIGH | Deep nesting, convoluted control flow, overly generic solutions |
| Boilerplate scaffolding with no business logic | MEDIUM | Empty handlers, pass-through layers, no-op wrappers |

### YAGNI Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| Speculative feature (not requested) | HIGH | "Just in case" code, unused parameters "for future use" |
| Premature abstraction without 3+ consumers | MEDIUM | Interface for single implementation, optimization without measured bottleneck |
| Premature abstraction (single consumer) | MEDIUM | Interface for single implementation, strategy for single strategy |

### Documentation Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| Missing JSDoc/docstring on public API | MEDIUM | Public function/class/module with no docs |
| API docs don't match code signatures | HIGH | API signatures changed but docs not updated |
| Broken documentation references | MEDIUM | Dead links, references to renamed/removed entities |
| Missing change documentation | HIGH | Behavioral changes not reflected in relevant docs |

## SOLID Principles

| Principle | Check | Violation Signs |
|-----------|-------|-----------------|
| **S**ingle Responsibility | One reason to change per function/class | Class over 300 lines, mixed concerns |
| **O**pen/Closed | Extend without modification | Switch statements for types, instanceof checks |
| **L**iskov Substitution | Subtypes substitute base types | Overridden methods with different behavior |
| **I**nterface Segregation | Small, focused interfaces | Unused method implementations, "god interfaces" |
| **D**ependency Inversion | Depend on abstractions | `new` in constructors, concrete dependencies |

### SOLID Examples

**SRP — Before/After**
```
// Bad: mixed concerns
class UserService {
  validateEmail(email) { ... }
  saveToDatabase(user) { ... }
  sendWelcomeEmail(user) { ... }
}

// Good: single responsibility each
class UserValidator { validateEmail(email) { ... } }
class UserRepository { save(user) { ... } }
class UserNotifier { sendWelcome(user) { ... } }
```

**DIP — Before/After**
```
// Bad: depends on concrete
class OrderService {
  constructor() { this.repo = new PostgresRepository(); }
}

// Good: depends on abstraction
class OrderService {
  constructor(private repo: IRepository) {}
}
```

## DRY — Don't Repeat Yourself

**Definition**: Every piece of knowledge has single, unambiguous representation.

**Check For**:
- Duplicated validation logic
- Copy-pasted code blocks
- Magic numbers/strings in multiple places
- Same business rule in different files

**Fix**: Extract to shared utilities, constants, or helper functions.

## KISS — Keep It Simple

**Definition**: Simplicity is a key design goal.

**Check For**:
- Over-engineered solutions (factory-builder-provider chains)
- Unnecessary abstraction layers
- Premature optimization
- Complex code for simple tasks

**Fix**: Start simple, add complexity only when concrete need exists.

## YAGNI — You Aren't Gonna Need It

**Definition**: Don't add functionality until necessary.

**Check For**:
- "Just in case" features
- Speculative APIs
- Unused parameters "for future use"
- Over-generalized solutions

**Fix**: Build only what's required now. Document ideas separately.

## Anti-Patterns Catalog

| Anti-pattern | Symptoms | Fix |
|--------------|----------|-----|
| God Object | >7 public methods, 3+ unrelated concerns | Split into focused classes |
| Shotgun Surgery | One change requires editing many files | Consolidate related logic |
| Feature Envy | Method uses more of another class than its own | Move method to the other class |
| Data Clumps | Same group of fields appears in multiple places | Extract to Parameter Object |
| Primitive Obsession | Using primitives for domain concepts | Create Value Objects |
| Long Parameter List | >4 parameters | Introduce Parameter Object |
| Divergent Change | Class changed for different reasons in different ways | Apply SRP split |
| Parallel Inheritance | Subclassing one class requires subclassing another | Merge hierarchies, use composition |

## Refactoring Catalog

Common Fowler refactoring patterns:

| Smell | Refactoring | When |
|-------|-------------|------|
| Duplicate code | Extract Method / Extract Function | Same code in 2+ places |
| Long method | Extract Method | Method >50 lines |
| Large class | Extract Class | Class with multiple concerns |
| Long parameter list | Introduce Parameter Object | >4 parameters |
| Feature envy | Move Method | Method uses another class more |
| Data clumps | Extract Class / Parameter Object | Repeated field groups |
| Switch on type | Replace Conditional with Polymorphism | instanceof or type switch |
| Temp variable | Extract Variable / Inline Temp | Clarity or duplication |
| Nested conditionals | Replace Nested Conditional with Guard Clauses | Deep if/else nesting |

### Safe Refactoring Workflow

1. Ensure tests pass before starting
2. Make one atomic change at a time
3. Run tests after each change
4. Commit when tests pass
5. Repeat — never refactor and add features simultaneously

### Large-Scale Refactoring Strategies

- **Strangler Fig**: Build new implementation alongside old; redirect traffic gradually; delete old
- **Branch by Abstraction**: Introduce abstraction over old code; build new implementation behind it; switch; remove old
- **Parallel Change**: Add new interface, migrate all callers, remove old interface
- Use feature flags to decouple deployment from activation for risky refactors

## Code Review Practices

### PR Review Checklist

- [ ] Code matches the stated requirement (no scope creep, no missing pieces)
- [ ] SOLID violations absent (SRP, OCP, LSP, ISP, DIP)
- [ ] No significant duplication (>10 lines)
- [ ] No speculative features (YAGNI)
- [ ] Tests present and meaningful
- [ ] Public APIs documented
- [ ] Error cases handled explicitly
- [ ] No hardcoded secrets or magic values

### Effective Feedback Guidelines

- Be specific: cite file path, line range, and violation type
- Distinguish blocking issues (CRITICAL/HIGH) from suggestions (MEDIUM/LOW)
- Offer a concrete alternative, not just a critique
- Focus on the code, not the author
- Acknowledge good patterns as well as problems

### Anti-Patterns in Reviews

| Pattern | Problem |
|---------|---------|
| Nitpick storm | Many LOW findings obscure CRITICAL ones |
| Approval without reading | Rubber-stamping defeats the gate |
| Style-only feedback | Automate style; reserve review for logic |
| Scope expansion | "While you're here, also fix X" violates scope discipline |

### Anti-Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Overall the code looks good" | Review is checklist-driven, not impression-driven |
| "These issues are cosmetic" | Check severity — CRITICAL/HIGH are never cosmetic |
| "The user seems in a hurry" | Quality gates protect users from their own urgency |
| "It's just a small change" | Small changes with CRITICAL violations are still CRITICAL |
| "I'll fix it in the next PR" | Tech debt deferred is tech debt compounded |

## Quality Checklist

### Before Coding
- [ ] Understand single responsibility for new code
- [ ] Identify interfaces/abstractions to depend on
- [ ] Confirm feature is actually required (YAGNI)

### During Coding
- [ ] Keep functions focused (<50 lines recommended)
- [ ] Extract duplicated logic immediately (DRY)
- [ ] Inject dependencies, don't instantiate (DIP)
- [ ] Use descriptive names over comments (KISS)

### After Coding
- [ ] Each class has single responsibility (SRP)
- [ ] Can extend without modifying existing code (OCP)
- [ ] No unused interface methods implemented (ISP)
- [ ] No speculative features (YAGNI)
- [ ] No code duplication (DRY)
- [ ] Tests pass before and after refactoring

## Quick Reference

| Smell | Principle | Action |
|-------|-----------|--------|
| Large class | SRP | Split by responsibility |
| Type switches | OCP | Use polymorphism |
| Unused methods | ISP | Split interface |
| Direct instantiation | DIP | Inject dependency |
| Copy-pasted code | DRY | Extract function |
| Complex solution | KISS | Simplify |
| "Maybe needed" code | YAGNI | Remove |
| Long method | Refactoring | Extract Method |
| Data clumps | Refactoring | Introduce Parameter Object |
| Feature envy | Refactoring | Move Method |

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting violations with file path and line context, grouped by principle (SOLID, DRY, KISS, YAGNI)
- Using severity model: CRITICAL/HIGH = BLOCK (must fix before proceeding), MEDIUM = WARN (flag to user), LOW = INFO (note for consideration)
- Providing specific refactoring recommendations per violation (e.g., "Extract Method for significant duplication at lines 45-67")
- Summarizing findings with a count per severity level
