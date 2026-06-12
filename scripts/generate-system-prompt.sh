#!/usr/bin/env bash
# generate-system-prompt.sh — derives system-prompt.md from 17 behavioral SKILL.md files.
# Offline-only (no network access). Exit 0 on success; 1 on drift/error.
# Usage: bash scripts/generate-system-prompt.sh [--check]
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${REPO}/system-prompt.md"
TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
MAX=750

SKILLS=(anti-slop approval-gate architecture-evidence design-challenge dry-kiss-yagni
        error-handling future-proof hard-choice naming pareto-focus review-gate
        root-cause scope-discipline scout solid-gate test-discipline verification-evidence)

# Header
cat >"$TMP" <<'HDR'
<!--
  Base Skills — System Prompt Block
  Copy this entire file into your agent's system instructions.
  Provider-agnostic. Under 1000 tokens. Produces the same behavioural effect as all 17 behavioral skills.
  Full skill definitions: github.com/CorentinLumineau/base-skills
-->

HDR

# extract_section <file> <section_heading>
# Outputs first non-blank bullet line from the named ## section, with bullet stripped.
extract_section() {
  local file="$1" heading="$2"
  awk "/^## ${heading}/{p=1;next}/^## /{p=0}p" "$file" \
    | grep -v '^[[:space:]]*$' \
    | head -1 \
    | sed 's/^[[:space:]]*[-*] *//' \
    || true
}

for skill in "${SKILLS[@]}"; do
  f="${REPO}/skills/${skill}/SKILL.md"
  if [ ! -s "$f" ]; then
    echo "WARNING: $f missing or empty — skipping" >&2
    continue
  fi

  always="$(extract_section "$f" Always)"
  never="$(extract_section "$f" Never)"

  # Strip trailing period before reassembling
  always="${always%.}"
  never="${never%.}"

  if [ -n "$always" ] && [ -n "$never" ]; then
    echo "I ${always}. I never ${never}." >>"$TMP"
  elif [ -n "$always" ]; then
    echo "I ${always}." >>"$TMP"
  fi
done

echo "" >>"$TMP"

# Word count gate
words="$(wc -w <"$TMP" | tr -d ' ')"
if [ "$words" -gt "$MAX" ]; then
  echo "ERROR: generated output is $words words (limit: $MAX)" >&2; exit 1
fi

# Check or write
if [ "${1:-}" = "--check" ]; then
  if diff -q "$OUT" "$TMP" >/dev/null 2>&1; then
    echo "check-drift: OK ($words words)"; exit 0
  else
    echo "check-drift: DRIFT DETECTED" >&2
    diff "$OUT" "$TMP" >&2 || true; exit 1
  fi
else
  cp "$TMP" "$OUT"
  echo "generate: OK — system-prompt.md written ($words words)"
fi
