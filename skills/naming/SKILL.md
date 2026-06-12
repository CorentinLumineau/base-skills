---
name: naming
description: "Every identifier must pass the explains-itself test. Banned patterns: data/info/manager/handler/utils/misc/helper. Booleans use is/has/can/shouldX. Functions are verb-first."
---

# Naming

**triggers**: Every new identifier: classes, functions, variables, files, modules, routes, database columns, environment variables, configuration keys

## Why
Names are the most read documentation in any codebase. A bad name misleads every future reader. Because names are cheap to change at creation time and expensive to change later, getting them right at the point of introduction is the highest-leverage quality practice.

## Always
- Apply the **explains-itself test**: can a reader who has never seen this code guess what it does from the name alone, without opening the file?
- Use **verb-first** for functions: `findUser`, `submitOrder`, `calculateTotal`
- Use **is / has / can / shouldX** for booleans: `isActive`, `hasPermission`, `canEdit`
- Calibrate scope to length: short-lived local variables get short names (i, idx, acc); module-level and public identifiers get full descriptive names

## Never
- Use the banned patterns: `data`, `info`, `manager`, `handler`, `utils`, `misc`, `helper`
- Use a generic name that describes the container (`DataProcessor`, `FileManager`) instead of what it does
- Let a name that no longer describes behaviour survive — the lie detector: a stale name is a correctness bug, not a style issue

## Gate
Before acting, answer these. Stop if any is NO or UNKNOWN:
- Does every new identifier pass the explains-itself test?
- Does any identifier use a banned pattern (data / info / manager / handler / utils / misc / helper)?

## Artifact
Naming audit — inline in code review: "naming OK" or "flagged: {identifier} → suggest {alternative}."

## Watch out for
- "It is just an internal variable" → Internal variables are read by people too
- "Everyone knows what a Manager does" → No one knows what a Manager does
- "I will rename it later" → Renaming later requires touching every call site and is rarely done
