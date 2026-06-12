.PHONY: validate validate-manual generate check-drift

# Conformance gate: validate all 23 skills against the agentskills.io spec
# Requires: npm install -g skills-ref
validate:
	skills-ref validate \
		skills/anti-slop \
		skills/approval-gate \
		skills/architecture-evidence \
		skills/design-challenge \
		skills/dry-kiss-yagni \
		skills/error-handling \
		skills/future-proof \
		skills/hard-choice \
		skills/naming \
		skills/pareto-focus \
		skills/review-gate \
		skills/root-cause \
		skills/scope-discipline \
		skills/scout \
		skills/solid-gate \
		skills/test-discipline \
		skills/verification-evidence \
		skills/x-analyze \
		skills/x-auto \
		skills/x-fix \
		skills/x-implement \
		skills/x-plan \
		skills/x-review

# Derive system-prompt.md from the 17 behavioral SKILL.md files (offline only)
generate:
	bash scripts/generate-system-prompt.sh

# Fail with exit code 1 if system-prompt.md has drifted from the generated output
# Fallback: git diff --exit-code if diff is unavailable
check-drift:
	bash scripts/generate-system-prompt.sh --check

# Manual fallback when skills-ref is not yet installed
validate-manual:
	@echo "Checking for non-spec frontmatter keys..."
	@grep -r "user-invocable:" skills/ && (echo "FAIL: user-invocable key found" && exit 1) || echo "PASS: no user-invocable keys"
	@grep -r "\*\*activation\*\*:" skills/ && (echo "FAIL: activation body line found" && exit 1) || echo "PASS: no activation body lines"
	@echo "All manual checks passed."
