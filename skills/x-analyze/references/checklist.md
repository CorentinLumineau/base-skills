# x-analyze — Phase Execution Checklist

Follow these steps in order. Read each domain file when beginning that domain.

## Phase Start

- [ ] Define the analysis scope (single file, module, feature, or full codebase)
- [ ] Check if WORKFLOW.md exists — if yes, read it for prior context
- [ ] State scope to user: "Analyzing {scope} across quality, security, performance, architecture."

## Domain Analysis

For each domain, read the file first, then assess:

### 1. Quality — read `references/domains/quality.md`

- [ ] SOLID violations (SRP/LSP=CRITICAL, OCP/DIP=HIGH, ISP=MEDIUM)
- [ ] DRY violations (>10 lines duplicated=HIGH, 3-10 lines=MEDIUM)
- [ ] KISS violations (unnecessary complexity, deep nesting)
- [ ] Complexity red flags (god classes, long methods, flag parameters)

### 2. Security — read `references/domains/security.md`

- [ ] Input validation (injection: SQL, command, path traversal)
- [ ] Authentication / authorization (broken auth, missing checks)
- [ ] Data exposure (sensitive data in logs, error messages, responses)
- [ ] OWASP Top 10 — check all 10 categories

### 3. Performance — read `references/domains/performance.md`

- [ ] N+1 queries (loop + DB/API call per iteration)
- [ ] Memory leaks (unclosed resources, unbounded caches)
- [ ] Inefficient algorithms (O(n²) where O(n) is possible)
- [ ] Missing caching (repeated identical computations or queries)

### 4. Architecture — read `references/domains/architecture.md`

- [ ] Layer violations (business logic in UI, DB queries in controllers)
- [ ] Circular dependencies
- [ ] High coupling (class/module knows too much about another's internals)
- [ ] Abstraction level mismatches

## Findings Collection

After all 4 domains:
1. Deduplicate findings that appear in multiple domains (keep highest severity)
2. Rank: CRITICAL → HIGH → MEDIUM → LOW
3. Apply Pareto: identify the top findings explaining 80% of the risk
4. Read `references/output-template.md` to write the audit report

## Phase Completion Check

Before presenting findings:
- [ ] All 4 domains assessed?
- [ ] Findings ranked by severity?
- [ ] Audit report written using `references/output-template.md`?
- [ ] Read `references/approval-gate.md`?
