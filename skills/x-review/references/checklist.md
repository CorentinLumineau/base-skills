# x-review — Review Checklist

Load trigger: Read this file at the start of the review phase.

## Per-File Audit

For each file in the diff, check:

### SOLID Compliance
- [ ] SRP: Does the class/module have exactly one reason to change?
- [ ] OCP: Can behavior be extended without modifying existing code?
- [ ] LSP: Do subtypes honor the contract of their parent?
- [ ] ISP: Are interfaces narrow (clients not forced to depend on unused methods)?
- [ ] DIP: Do high-level modules depend on abstractions, not concretions?

### DRY
- [ ] No duplication >10 lines (HIGH violation)
- [ ] No duplicated magic values (use named constants)

### KISS
- [ ] No unnecessary abstraction layers (factory-builder chains, indirection)
- [ ] No nesting deeper than 3 levels

### YAGNI
- [ ] No speculative features ("just in case" code, unused parameters)
- [ ] No premature optimization without a measured bottleneck

### Security
- [ ] No injection vulnerabilities (SQL, shell, template, path traversal)
- [ ] No hardcoded secrets, tokens, or credentials
- [ ] No auth/authz bypass
- [ ] No XSS vulnerabilities in output handlers

### Tests
- [ ] All new production code has corresponding tests
- [ ] Tests have meaningful assertions (not just `assert result is not None`)
- [ ] Edge cases covered (null inputs, empty collections, boundary values)

### Documentation
- [ ] Public API changes reflected in docs/comments
- [ ] No stale comments describing removed behavior

## Finding Format

For each violation found:

```
[SEVERITY] {file}:{line} — {V-code if known}: {description}
Mitigation: {concrete action, not "be careful"}
```

Severity: CRITICAL | HIGH | MEDIUM | LOW

## Completion Check

Before presenting findings:
- [ ] Every file in the diff reviewed
- [ ] Findings have concrete mitigations (not "review this" or "consider refactoring")
- [ ] No finding references code outside the diff boundary
- [ ] Suggestion proportionality: no over-engineering recommendations

See `references/approval-gate.md` for the gate conditions before chaining to git-commit.
