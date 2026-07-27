#!/usr/bin/env bash
# Mechanical half of /lint — deterministic checks that need no LLM.
# Judgment-level checks (contradictions, stale reasoning, gaps, rule-of-three)
# still belong to the agent; see .claude/commands/lint.md.
#
# Usage:  scripts/lint.sh          # report
#         scripts/lint.sh --strict # report and exit 1 if any issue found
set -uo pipefail
cd "$(dirname "$0")/.."

STRICT=0; [ "${1:-}" = "--strict" ] && STRICT=1
ISSUES=0
say() { printf '%s\n' "$*"; }
fail() { printf '  ✗ %s\n' "$*"; ISSUES=$((ISSUES+1)); }
ok()  { printf '  ✓ %s\n' "$*"; }

say "== 1. Wikilinks resolve =="
BROKEN=0
while read -r t; do
  [ -z "$t" ] && continue
  case "$t" in other-page|page) continue;; esac   # syntax examples in CLAUDE.md
  [ -f "wiki/$t.md" ] || { fail "broken link: [[wiki/$t]]"; BROKEN=1; }
done < <(grep -rhoE '\[\[wiki/[a-z0-9-]+\]\]' wiki/ index.md CLAUDE.md STATE.md 2>/dev/null \
         | sed -E 's/\[\[wiki\/(.+)\]\]/\1/' | sort -u)
[ "$BROKEN" -eq 0 ] && ok "all links resolve"

say "== 2. Every wiki page is in index.md =="
MISSING=0
for f in wiki/*.md; do
  b=$(basename "$f" .md)
  grep -q "\[\[wiki/$b\]\]" index.md || { fail "not in index: $b"; MISSING=1; }
done
[ "$MISSING" -eq 0 ] && ok "index covers every page"

say "== 3. Frontmatter present and well-formed =="
BADFM=0
for f in wiki/*.md; do
  head -1 "$f" | grep -q '^---$' || { fail "no frontmatter: $f"; BADFM=1; continue; }
  for k in title type created updated sources; do
    awk '/^---$/{n++; next} n==1' "$f" | grep -q "^$k:" \
      || { fail "missing '$k:' in $f"; BADFM=1; }
  done
done
[ "$BADFM" -eq 0 ] && ok "frontmatter valid on all pages"

say "== 4. Orphan pages (no inbound links) =="
ORPH=0
for f in wiki/*.md; do
  b=$(basename "$f" .md)
  n=$(grep -rl "\[\[wiki/$b\]\]" wiki/ index.md STATE.md 2>/dev/null | grep -v "^wiki/$b.md$" | wc -l)
  [ "$n" -eq 0 ] && { fail "orphan (no inbound links): $b"; ORPH=1; }
done
[ "$ORPH" -eq 0 ] && ok "no orphan pages"

say "== 5. Stale epistemic tags past TTL (fast 30d / medium 180d / slow 1095d) =="
python3 - <<'PY'
import re, pathlib, datetime, sys
TTL = {"fast": 30, "medium": 180, "slow": 1095}
today = datetime.date.today()
pat = re.compile(r'\{fact\s*✓\s*(\d{4}-\d{2}-\d{2})\s+(fast|medium|slow)')
found = 0
for f in sorted(pathlib.Path("wiki").glob("*.md")):
    for i, line in enumerate(f.read_text().splitlines(), 1):
        for m in pat.finditer(line):
            d = datetime.date.fromisoformat(m.group(1)); cls = m.group(2)
            age = (today - d).days
            if age > TTL[cls]:
                print(f"  ✗ stale {cls} fact ({age}d old, TTL {TTL[cls]}d): {f}:{i}")
                found += 1
print("  ✓ no expired fact tags" if not found else f"  → {found} tag(s) need re-verification")
sys.exit(1 if found else 0)
PY
[ $? -ne 0 ] && ISSUES=$((ISSUES+1))

say "== 6. Quantifier scan (absolute claim + hedged support on same line) =="
python3 - <<'PY'
import re, pathlib, sys
ABS = r'\b(always|never|all|every|None|luôn|mọi|không bao giờ)\b'
HEDGE = r'\b(so far|usually|often|some|most|cho tới giờ|thường|một số)\b'
found = 0
for f in sorted(pathlib.Path("wiki").glob("*.md")):
    lines = f.read_text().splitlines()
    for i, line in enumerate(lines, 1):
        # escape hatch: '<!-- lint-ok: quantifier -->' on this line or the one above
        ctx = line + (lines[i-2] if i >= 2 else "")
        if "lint-ok: quantifier" in ctx:
            continue
        if re.search(ABS, line) and re.search(HEDGE, line, re.I):
            print(f"  ✗ possible quantifier widening: {f}:{i}")
            found += 1
print("  ✓ no quantifier widening detected" if not found else f"  → {found} line(s) to review by hand")
sys.exit(1 if found else 0)
PY
[ $? -ne 0 ] && ISSUES=$((ISSUES+1))

say "== 7. log.md parseable =="
BAD=$(grep -c '^## \[' log.md)
[ "$BAD" -gt 0 ] && ok "$BAD parseable log entries" || fail "log.md has no parseable entries"

say "== 8. Disputed ledger =="
D=$(grep -rn '{disputed' wiki/ 2>/dev/null || true)
[ -n "$D" ] && { say "$D"; } || ok "no disputed claims on record"

say ""
if [ "$ISSUES" -eq 0 ]; then
  say "RESULT: mechanical lint clean."
else
  say "RESULT: $ISSUES mechanical issue group(s) — see above."
fi
[ "$STRICT" -eq 1 ] && exit $([ "$ISSUES" -eq 0 ] && echo 0 || echo 1)
exit 0
