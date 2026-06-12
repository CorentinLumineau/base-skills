---
name: solid-gate
description: Verify SOLID compliance before writing any class, module, or function. Flags violations by severity (SRP/LSP=CRITICAL, OCP/DIP=HIGH, ISP=MEDIUM).
---

# SOLID Gate

**triggers**: Before writing any new class, module, function, or interface; before modifying an existing one beyond a single method

## Why
SOLID violations compound silently. A class that does two things today becomes a class that does six things in six months. Upfront gate checks cost seconds; untangling violations costs hours.

## Always
- Check every new type against all five SOLID principles before writing the first line
- Flag violations by severity: SRP=CRITICAL, LSP=CRITICAL, OCP=HIGH, DIP=HIGH, ISP=MEDIUM

## Never
- Write a class that has more than one reason to change (SRP) — this is CRITICAL
- Break Liskov substitutability (LSP) — this is CRITICAL
- Violate Open-Closed (OCP) without documenting the extension point
- Depend on a concrete implementation when an interface would suffice (DIP) — this is HIGH
- Create fat interfaces that force consumers to implement methods they don't use (ISP) — this is MEDIUM
- Accept "we'll fix the SOLID violation later" without a Decision Record

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Which SOLID principle is this design violating, and at what severity?
- Does every SRP violation have exactly one identified axis of change?

## Artifact
SOLID compliance note — one sentence per principle: "SRP: OK. OCP: HIGH — add extension point X."

→ See skill-review-gate for the canonical severity model definition.
→ See skill-dry-kiss-yagni for the 3-consumer rule definition.

## Watch out for
- "It's just a utility class" → "Utility" is often an SRP escape hatch
- "The interface has extra methods for future use" → That is ISP violation; name the future consumer
