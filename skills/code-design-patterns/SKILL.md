---
name: code-design-patterns
description: >
  Use when choosing or implementing design patterns for object-oriented software
  (design pattern, Gang of Four, Factory, Repository, Strategy, Observer, Decorator,
  Adapter, Builder, Singleton, god object, circular dependency).
  Covers creational, structural, and behavioral GoF patterns with selection guidance
  and anti-pattern detection.
  Do NOT use for code quality reviews (use code-code-quality) or API design (use code-api-design).
license: MIT
compatibility: always-on knowledge skill
allowed-tools: Read Grep Glob
---

<!-- ported from mercure-plugin/skills/code-design-patterns/ -->

# Design Patterns

Reusable solutions to common software design problems.

## Enforcement Definitions

Referenced by workflow skills during approach-verification when introducing new classes or modules.

**Severity Model**: CRITICAL/HIGH = BLOCK (must fix), MEDIUM = WARN (flag to user), LOW = INFO (note).

### Pattern Violations

| Violation | Severity | Detection |
|-----------|----------|-----------|
| God Object (>7 public methods AND >3 concerns) | CRITICAL | Class with excessive public surface area spanning multiple domains |
| Spaghetti / circular dependencies | HIGH | Module A → B → C → A, tangled import graphs |
| Missing obvious pattern (complex conditionals without Strategy/State) | HIGH | Long if-else/switch chains that should use polymorphism |
| Pattern misuse (pattern where simpler solution works) | HIGH | Over-applied patterns adding complexity without benefit |

## Pattern Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| Creational | Object creation | Factory, Singleton, Builder |
| Structural | Object composition | Adapter, Decorator, Repository |
| Behavioral | Object interaction | Strategy, Observer, Command |

## Most Used Patterns (80/20)

### Factory Pattern
**Use when**: Creating objects without specifying exact class.

```
Client → Factory.create(type) → ConcreteProduct
```

**When to use**:
- Multiple product types share an interface
- Creation logic is complex or conditional
- Decoupling client from concrete implementation is needed

### Repository Pattern
**Use when**: Abstracting data access logic.

```
Service → Repository.find(criteria) → Entity
```

**When to use**:
- Multiple data sources (DB, cache, external API)
- Complex queries that shouldn't leak into domain logic
- Testing with mocks/fakes in place of real persistence

### Strategy Pattern
**Use when**: Algorithms need to be interchangeable.

```
Context → Strategy.execute() → Different implementations
```

**When to use**:
- Multiple algorithms for the same task
- Algorithm selection at runtime
- Avoiding conditional complexity (long switch/if-else on type)

### Observer Pattern
**Use when**: Objects need to be notified of changes.

```
Subject → notify() → Observer1, Observer2, ...
```

**When to use**:
- Event-driven systems
- Loose coupling between producer and consumers
- One-to-many dependency where consumers vary

## Creational Patterns

| Pattern | Intent | Avoid When |
|---------|--------|------------|
| Factory Method | Delegate object creation to subclasses | Simple `new` is sufficient |
| Abstract Factory | Create families of related objects | Only one product family exists |
| Builder | Construct complex objects step-by-step | Object has few fields |
| Singleton | One instance, global access point | Testability matters — prefer DI |
| Prototype | Clone existing objects | Object graph is shallow |

**Singleton caution**: Singletons introduce global mutable state and make unit testing difficult.
Prefer dependency injection with a single registered instance (container-managed singleton).

## Structural Patterns

| Pattern | Intent | Avoid When |
|---------|--------|------------|
| Adapter | Convert interface A to interface B | Interfaces are already compatible |
| Decorator | Add behavior without subclassing | Subclassing is cleaner |
| Facade | Simplify a complex subsystem | Subsystem is already simple |
| Repository | Decouple domain from persistence | CRUD-only, no domain complexity |
| Proxy | Control access to an object | Direct access is sufficient |
| Composite | Treat trees and leaves uniformly | Hierarchy doesn't exist |

## Behavioral Patterns

| Pattern | Intent | Avoid When |
|---------|--------|------------|
| Strategy | Swap algorithms at runtime | Only one algorithm exists |
| Observer | Event-driven notification | Tight coupling is acceptable |
| Command | Encapsulate requests as objects | No undo/redo or queuing needed |
| State | Change behavior based on internal state | State is simple boolean |
| Chain of Responsibility | Pass request along handler chain | Single handler always applies |
| Template Method | Define skeleton; let subclasses fill in steps | Steps don't vary across subclasses |
| Iterator | Sequential access without exposing internals | Collection is already iterable |

## Pattern Selection Guide

| Need | Pattern |
|------|---------|
| Create objects flexibly | Factory |
| Abstract data access | Repository |
| Swap algorithms | Strategy |
| React to events | Observer |
| Add behavior dynamically | Decorator |
| Convert interfaces | Adapter |
| Build complex objects | Builder |
| Single instance | Singleton (rarely, prefer DI) |
| Simplify a subsystem | Facade |
| Encapsulate operations | Command |

## Anti-Patterns

| Anti-pattern | Issue | Fix |
|--------------|-------|-----|
| Singleton abuse | Global state, untestable | Dependency injection |
| Pattern overuse | Over-engineering | KISS — start simple |
| Wrong pattern | Mismatch between problem and solution | Understand problem first |
| Factory for single product | YAGNI — premature abstraction | Use `new` directly |
| Strategy for single strategy | YAGNI — interface with one impl | Use plain function |

## Pattern Checklist

Before applying a pattern:
- [ ] Problem is clearly understood
- [ ] Pattern addresses an actual need (not a hypothetical one)
- [ ] Simpler solution does not exist
- [ ] Team understands the pattern
- [ ] Pattern does not introduce more complexity than it removes

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting pattern violations with file path and structural evidence
- Using severity model: CRITICAL = BLOCK (God Object, circular dependency), HIGH = WARN (pattern misuse, missing obvious pattern), MEDIUM = INFO (minor pattern opportunity)
- Recommending specific applicable patterns with justification from the Pattern Selection Guide (e.g., "Strategy pattern recommended — 5 conditional branches dispatching on type")
- Flagging anti-pattern risks when patterns are over-applied (pattern where simpler solution works)
