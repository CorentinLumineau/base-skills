# SOLID Principles at Scale

<!-- ported from mercure-plugin/skills/meta-rearchitect/references/solid-at-scale.md -->

SOLID principles applied at the system and module level, not just class level.

## SRP at Module Level

**Class SRP**: A class should have one reason to change.
**Module SRP**: A module (package, service, bounded context) should have one business reason to change.

### Detection

A module violates SRP when changes to unrelated features both touch it:

```bash
# Check: does module X change for different reasons?
# Group commits by feature/issue, count which touch this module
git log --oneline --all -- src/{module}/ | head -20
# If commits reference unrelated features → SRP violation
```

### Violation Signals
- Module appears in PRs for 3+ unrelated features
- Module has 2+ maintainers from different teams
- Module's CHANGELOG has entries from different business domains
- Merge conflicts between teams working on different features

### Remediation
1. List the distinct business reasons the module changes for
2. Extract each reason into its own module
3. Define clear interfaces between the new modules
4. The old module becomes a thin composition layer (or is deleted)

## OCP at Module Level

**Class OCP**: Open for extension, closed for modification.
**Module OCP**: New features should be addable without modifying existing modules.

### Detection

A module violates OCP when every new feature requires changing its core code:

```bash
# Count how often the core module is modified in feature branches
git log --oneline --all -- src/{core-module}/ | wc -l
# If > 80% of feature branches touch core → OCP violation
```

### Violation Signals
- Every new feature requires changes to a "router", "registry", or "factory"
- Adding a new type requires editing 3+ switch statements
- Plugin or extension system exists but is bypassed for "special cases"
- Module has a growing number of conditionals (if/switch on type)

### Remediation
1. Identify the variation point (what changes with each new feature?)
2. Design a plugin interface that captures the variation
3. Refactor existing features to use the plugin interface
4. New features implement the interface — zero changes to core
5. Strategy pattern, Factory pattern, or plugin registry as implementation

## LSP at Module Level

**Class LSP**: Subtypes must be substitutable for base types.
**Module LSP**: Service implementations must honor their API contracts.

### Detection

A module violates LSP when different implementations of the same interface behave differently:

```bash
# Check: do all implementations of an interface pass the same tests?
for impl in implementations/*; do
  echo "Testing $impl..."
  npm test -- --filter="interface-contract"
done
```

### Violation Signals
- Different implementations return different error codes for the same input
- API versioning hides breaking changes (v2 doesn't honor v1 contracts)
- Consumers use `instanceof` checks to handle specific implementations
- "Works with implementation A but fails with implementation B"

### Remediation
1. Write contract tests that apply to ALL implementations
2. Document the contract explicitly (expected behavior for each input)
3. Fix implementations that violate the contract
4. Add contract test suite to CI for all implementations

## ISP at Module Level

**Class ISP**: No client should depend on methods it doesn't use.
**Module ISP**: No module should depend on a package for a single function.

### Detection

```bash
# Check: what percentage of a dependency's exports does each consumer use?
grep -rn "from '{module}'" src/ --include="*.ts" | \
  awk -F'import ' '{print $2}' | \
  awk -F' from' '{print $1}' | \
  tr ',' '\n' | wc -l
```

### Violation Signals
- Modules import large packages for 1 function
- Bundle size includes unused code from fat dependencies
- Interface changes break consumers that don't use the changed methods
- "Kitchen sink" utility modules that every file imports

### Remediation
1. Split fat interfaces into focused ones (1 interface per consumer role)
2. Split fat modules into focused sub-modules
3. Use tree-shaking-friendly exports (named exports, no default barrel)
4. Apply the Rule of Three before creating new shared interfaces

## DIP at Module Level

**Class DIP**: Depend on abstractions, not concretions.
**Module DIP**: Higher-level modules should not import from lower-level modules directly.

### Detection

```bash
# Check: do higher layers import from lower layers through interfaces?
# Direct lower-layer imports in upper layers = DIP violation
grep -rn "from '.*/(data|repositories|infrastructure)" src/(controllers|services)/ --include="*.ts"
```

### Violation Signals
- Controllers import directly from data layer (bypassing service layer)
- Business logic references database-specific types (SQL queries, ORM entities)
- High-level policies depend on low-level mechanisms (email sending, file I/O)
- Changing a database requires modifying business logic

### Layer Dependency Rules
```
Presentation → Business Logic → Data Access
     ↓               ↓              ↓
  Interfaces ← Interfaces ← Interfaces
```

Each arrow represents an allowed dependency direction. Interfaces (ports) live in the higher layer; implementations (adapters) live in the lower layer.

### Remediation
1. Define ports (interfaces) in the higher-level module
2. Create adapters in the lower-level module that implement the ports
3. Use dependency injection to wire adapters to ports at startup
4. Higher modules import only ports, never adapters directly

## Assessment Matrix Template

| Principle | Module | Compliance | Evidence | Remediation |
|-----------|--------|-----------|----------|-------------|
| SRP | {module} | {Pass/Partial/Fail} | {evidence} | {action} |
| OCP | {module} | {Pass/Partial/Fail} | {evidence} | {action} |
| LSP | {module} | {Pass/Partial/Fail} | {evidence} | {action} |
| ISP | {module} | {Pass/Partial/Fail} | {evidence} | {action} |
| DIP | {module} | {Pass/Partial/Fail} | {evidence} | {action} |
