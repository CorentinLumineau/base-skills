# Coupling Taxonomy

<!-- ported from mercure-plugin/skills/meta-rearchitect/references/coupling-taxonomy.md -->

Comprehensive coupling measurement methodology based on Robert C. Martin's package metrics.

## Package Metrics

### Afferent Coupling (Ca) — "Who depends on me?"

Counts the number of external modules that depend on this module. High Ca means the module is heavily depended upon — changes are risky.

**Collection method**:
```bash
# Count incoming imports to a module (JS/TS)
grep -rn "from '.*/{module-name}" src/ --include="*.ts" --include="*.js" | \
  grep -v "node_modules" | \
  awk -F: '{print $1}' | sort -u | wc -l

# Python variant
grep -rn "from {module_name}" src/ --include="*.py" | \
  awk -F: '{print $1}' | sort -u | wc -l
```

**Interpretation**:
| Ca Range | Rating | Implication |
|----------|--------|-------------|
| 0–5 | Low | Safe to change freely |
| 6–10 | Moderate | Changes need careful testing |
| 11–20 | High | Changes need impact analysis |
| 20+ | Critical | Changes risk cascading failures |

### Efferent Coupling (Ce) — "Who do I depend on?"

Counts the number of external modules this module depends on. High Ce means the module is fragile — it breaks when dependencies change.

**Collection method**:
```bash
# Count outgoing imports from a module (JS/TS)
grep -rn "^import " src/{module-name}/ --include="*.ts" --include="*.js" | \
  grep -v "from '\." | \
  awk '{print $NF}' | sort -u | wc -l
```

**Interpretation**:
| Ce Range | Rating | Implication |
|----------|--------|-------------|
| 0–4 | Low | Module is self-contained |
| 5–8 | Moderate | Normal dependency level |
| 9–15 | High | Consider splitting concerns |
| 15+ | Critical | Module is a dependency magnet |

### Instability (I) = Ce / (Ca + Ce)

| I Value | Meaning | Desirable For |
|---------|---------|---------------|
| 0.0 | Maximally stable (all inbound, no outbound) | Core abstractions, interfaces |
| 0.5 | Balanced | Business logic |
| 1.0 | Maximally unstable (all outbound, no inbound) | Leaf implementations, UI |

**The Stable Dependencies Principle**: Depend in the direction of stability. High-I modules should depend on low-I modules, never the reverse.

### Abstractness (A) = Abstract types / Total types

| A Value | Meaning |
|---------|---------|
| 0.0 | Fully concrete (no interfaces) |
| 0.5 | Balanced mix |
| 1.0 | Fully abstract (all interfaces) |

### Distance from Main Sequence (D) = |A + I - 1|

The "Main Sequence" is the ideal line where A + I = 1. Modules far from this line are in trouble:

| D Value | Zone | Problem |
|---------|------|---------|
| < 0.2 | Ideal | On or near the Main Sequence |
| 0.2–0.5 | Warning | Drifting from balance |
| > 0.5 | **Zone of Pain** (I≈0, A≈0) | Stable AND concrete — hard to extend |
| > 0.5 | **Zone of Uselessness** (I≈1, A≈1) | Unstable AND abstract — never used |

## Change Amplification

Measures how many files must change for a single logical change.

**Collection method**:
```bash
# Average files per commit (last 100 commits)
git log --oneline -100 --stat | \
  grep "files changed" | \
  awk '{sum += $1; n++} END {print sum/n " files/commit"}'

# Hotspot analysis: most frequently changed files
git log --oneline -200 --name-only | \
  grep -v "^[a-f0-9]" | \
  grep -v "^$" | \
  sort | uniq -c | sort -rn | head -20
```

**Interpretation**:
| Files/Change | Rating | Action |
|-------------|--------|--------|
| < 3 | Good | Architecture supports independent changes |
| 3–8 | Moderate | Some cross-cutting concerns exist |
| > 8 | High | Significant coupling — investigate hotspots |

## Worked Example

Given a module `auth/`:
- Ca = 12 (12 other modules import from auth)
- Ce = 3 (auth imports from 3 other modules)
- I = 3 / (12 + 3) = 0.2 (very stable)
- A = 0.1 (mostly concrete implementations)
- D = |0.1 + 0.2 - 1| = 0.7 → **Zone of Pain**

**Diagnosis**: auth is stable and heavily depended-upon, but has almost no abstractions. Any change to auth's internals risks breaking 12 consumers. **Remedy**: Extract interfaces for the 3-4 most-used auth functions.

## Cross-Language Detection Patterns

| Language | Import Pattern | Grep Pattern |
|----------|---------------|-------------|
| JavaScript/TypeScript | `import { X } from 'module'` | `grep -rn "from '" --include="*.ts"` |
| Python | `from module import X` | `grep -rn "^from\|^import" --include="*.py"` |
| Go | `import "package/module"` | `grep -rn "import" --include="*.go"` |
| Java | `import com.example.module` | `grep -rn "^import" --include="*.java"` |
| Rust | `use crate::module` | `grep -rn "^use" --include="*.rs"` |
