# Debugging Strategies

<!-- ported from mercure-plugin/skills/quality-debugging-performance/ -->

## Overview

Effective debugging requires systematic approaches to identify, isolate, and fix defects. This reference covers debugging methodologies, techniques for different bug types, and tools to accelerate the debugging process.

## 80/20 Quick Reference

**Debugging Methodology:**

| Step | Action | Goal |
|------|--------|------|
| 1. Reproduce | Create minimal repro | Confirm the bug |
| 2. Isolate | Binary search / divide | Narrow scope |
| 3. Hypothesize | Form testable theory | Guide investigation |
| 4. Verify | Test hypothesis | Confirm root cause |
| 5. Fix | Implement solution | Resolve issue |
| 6. Validate | Test fix + regression | Prevent recurrence |

**Bug Type to Strategy:**

| Bug Type | Primary Strategy |
|----------|------------------|
| Crash/Exception | Stack trace analysis |
| Logic error | Step-through debugging |
| Race condition | Logging + timing analysis |
| Performance | Profiling + tracing |
| Memory leak | Heap analysis |
| Integration | Contract/boundary testing |

## Patterns

### Pattern 1: Scientific Debugging Method

**When to Use**: All debugging scenarios

**The Process:**
```
1. OBSERVE: Gather facts about the bug
   - What is the expected behavior?
   - What is the actual behavior?
   - When did it start happening?
   - What changed recently?

2. HYPOTHESIZE: Form a testable theory
   - "I believe X is causing Y because Z"
   - Should be specific and falsifiable

3. EXPERIMENT: Test the hypothesis
   - Design minimal test to prove/disprove
   - Change only one variable at a time
   - Record results

4. ANALYZE: Evaluate results
   - Did the experiment confirm the hypothesis?
   - If not, what did we learn?
   - Form new hypothesis based on evidence

5. REPEAT: Until root cause found
```

**Anti-Pattern**: Randomly changing code hoping to fix the bug.

### Pattern 2: Binary Search Debugging

**When to Use**: Bug exists but unclear which change introduced it

**Git Bisect:**
```bash
git bisect start
git bisect bad        # Current commit has the bug
git bisect good v1.2.0  # Known good commit

# Test if bug exists, then mark:
git bisect good  # or git bisect bad

# Git identifies the problematic commit
git bisect reset
```

**Anti-Pattern**: Commenting out large blocks of code randomly.

### Pattern 3: Rubber Duck Debugging

**When to Use**: Complex bugs where you're stuck

**The Technique:**
```
1. Explain the code line by line to an inanimate object
2. Describe what you EXPECT each line to do
3. Often, the act of explaining reveals assumptions
   that don't match reality
```

**Anti-Pattern**: Not actually explaining the code in detail.

### Pattern 4: Delta Debugging

**When to Use**: Large inputs cause failure, need minimal reproduction

Minimize the failing input by binary halving until you have the smallest
input that still triggers the bug.

**Anti-Pattern**: Working with full complex input instead of minimizing.

### Pattern 5: Logging-Based Debugging

**When to Use**: Production bugs, race conditions, async issues

Use structured logging with correlation IDs and checkpoints to trace
execution across async flows without interactive debuggers.

**Anti-Pattern**: Adding too many logs without structure, making them hard to analyze.

### Pattern 6: Interactive Debugging Tools

**When to Use**: Interactive debugging sessions

- Node.js: `node --inspect-brk` + Chrome DevTools / VS Code
- Conditional breakpoints: break only when `user.id === 'problematic-id'`
- Logpoints: log values without stopping execution

**Anti-Pattern**: Using only console.log when a debugger would be more effective.

## Checklist

- [ ] Bug is reproducible before debugging
- [ ] Hypothesis formed before making changes
- [ ] Only one variable changed at a time
- [ ] Minimal reproduction case created
- [ ] Root cause identified, not just symptom
- [ ] Fix verified with test
- [ ] Regression test added
- [ ] Debug logging removed after fix
- [ ] Documentation updated if needed
- [ ] Similar code checked for same bug
