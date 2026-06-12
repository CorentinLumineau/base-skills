# Anti-Pattern Catalog

<!-- ported from mercure-plugin/skills/meta-rearchitect/references/anti-pattern-catalog.md -->

Expanded architectural anti-pattern descriptions with detection algorithms and remediation playbooks.

## God Object

**Definition**: A single module/class that does too much, knows too much, and is changed too often.

**Detection signals**:
```bash
# Files > 500 LOC
find src/ -name "*.ts" -o -name "*.py" | xargs wc -l | sort -rn | awk '$1 > 500'

# Files with > 10 exported functions/classes
grep -rn "^export " src/ --include="*.ts" | awk -F: '{print $1}' | sort | uniq -c | sort -rn | awk '$1 > 10'

# Files with > 8 imports
grep -rn "^import " src/ --include="*.ts" | awk -F: '{print $1}' | sort | uniq -c | sort -rn | awk '$1 > 8'
```

**Severity**: HIGH — God Objects are the #1 source of merge conflicts and unintended side effects.

**Remediation**:
1. Identify the distinct responsibilities (list them as bullet points)
2. Group related methods/functions by responsibility
3. Extract each responsibility into its own module
4. Create a facade if backward compatibility is needed
5. Update imports across the codebase

## Distributed Monolith

**Definition**: Multiple services that cannot be deployed independently — they share databases, configurations, or runtime state.

**Detection signals**:
- All services always deploy together
- Shared database schema (migrations in one service affect another)
- Services call each other synchronously for every request
- Shared configuration files or environment variables

**Severity**: CRITICAL — Worst of both worlds: distributed complexity with monolith coupling.

**Remediation**:
1. Map service-to-service dependencies (runtime + data)
2. Identify the "independence axis" — which services could be independent?
3. For tightly coupled pairs: merge back into a single service
4. For loosely coupled groups: introduce async messaging (events) instead of sync calls
5. Migrate shared tables to owned tables with event-based sync

## Big Ball of Mud

**Definition**: No discernible architecture — every module can import every other module, no layering, no boundaries.

**Detection signals**:
```bash
# Circular dependency detection
npx madge --circular src/

# Cross-layer imports (e.g., controller importing from data layer directly)
grep -rn "from '.*/(data|models|repositories)" src/controllers/ --include="*.ts"

# Import depth analysis (everything imports from everywhere)
grep -rn "^import " src/ --include="*.ts" | \
  awk -F"from '" '{print $2}' | \
  grep -c "\.\./\.\." # Count deep relative imports
```

**Severity**: CRITICAL — No change is safe, no test is sufficient, onboarding takes months.

**Remediation**:
1. Draw the current dependency graph (use madge, deptree, or manual analysis)
2. Identify natural clusters (groups of modules that change together)
3. Define layer boundaries (presentation → business → data)
4. Enforce one-way dependencies (upper layers import lower, never reverse)
5. Introduce barrel files (index.ts) as module boundaries

## Vendor Lock-in

**Definition**: Platform-specific constructs spread throughout the codebase, making migration impossible.

**Detection signals**:
```bash
# AWS-specific imports throughout
grep -rn "aws-sdk\|@aws-sdk" src/ --include="*.ts" | \
  awk -F: '{print $1}' | sort -u | wc -l

# Framework-specific decorators in business logic
grep -rn "@Injectable\|@Controller\|@Service" src/ --include="*.ts" | \
  grep -v "infrastructure\|adapters"
```

**Severity**: MEDIUM — Not urgent until migration is needed, then it's catastrophic.

**Remediation**:
1. Identify all vendor-specific touchpoints
2. Define ports (interfaces) for each external dependency
3. Create adapters that implement ports using current vendor
4. Move business logic to depend on ports, not adapters
5. New vendors = new adapters, zero business logic changes

## Premature Abstraction

**Definition**: Interfaces with exactly 1 implementation, generic frameworks used once, abstraction layers that add indirection without value.

**Detection signals**:
```bash
# Interfaces with 1 implementation
grep -rn "implements " src/ --include="*.ts" | \
  awk -F"implements " '{print $2}' | sort | uniq -c | sort -rn | awk '$1 == 1'

# Generic utility modules with 1 consumer
for file in src/utils/*.ts; do
  count=$(grep -rn "from '.*$(basename $file .ts)'" src/ --include="*.ts" | wc -l)
  [ "$count" -le 1 ] && echo "PREMATURE: $file ($count consumers)"
done
```

**Severity**: MEDIUM — Adds cognitive load and indirection without delivering flexibility.

**Remediation**:
1. Apply the Rule of Three: don't abstract until 3+ concrete uses exist
2. Inline single-implementation interfaces
3. Delete single-consumer utility modules (move logic to consumer)
4. Remove generic type parameters that are always instantiated with one type

## Circular Dependency

**Definition**: Module A depends on Module B which depends on Module C which depends on Module A.

**Detection signals**:
```bash
# JavaScript/TypeScript
npx madge --circular --extensions ts src/

# Python
pip install pydeps && pydeps --show-cycles src/

# Manual detection
grep -rn "from '.*module-a'" src/module-b/ && grep -rn "from '.*module-b'" src/module-a/
```

**Severity**: HIGH — Causes initialization order bugs, makes refactoring dangerous, prevents independent testing.

**Remediation**:
1. Map the cycle (A → B → C → A)
2. Identify the weakest link (the dependency that "shouldn't be there")
3. Apply Dependency Inversion: extract the shared abstraction into a new module
4. Both sides depend on the abstraction instead of each other
5. Verify cycle is broken: `npx madge --circular src/`
