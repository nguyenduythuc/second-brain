#!/usr/bin/env bash
# Are the compiled skills behind the wiki they were built from?
#
# Mechanical only — no LLM, no API key. It answers one question: which build
# targets have a source page that changed since the last compile. Recompiling
# is a judgment job (/compile); this script only decides whether that job has
# anything to do.
#
# Usage:  scripts/check-skill-drift.sh          # report
#         scripts/check-skill-drift.sh --strict # exit 1 if any target is stale
set -uo pipefail
cd "$(dirname "$0")/.."

STRICT=0; [ "${1:-}" = "--strict" ] && STRICT=1
MANIFEST=portable-skills/MANIFEST

[ -f "$MANIFEST" ] || { echo "✗ no $MANIFEST — nothing has been compiled yet"; exit 1; }

SHA=$(grep '^compiled_from:' "$MANIFEST" | awk '{print $2}')
[ -n "$SHA" ] || { echo "✗ $MANIFEST has no compiled_from:"; exit 1; }

if ! git cat-file -e "${SHA}^{commit}" 2>/dev/null; then
  echo "✗ compiled_from commit $SHA is not in this clone (shallow checkout?)"
  exit 1
fi

echo "Compiled from: $SHA ($(git log -1 --format=%cs "$SHA" 2>/dev/null))"

CHANGED=$(git diff --name-only "$SHA"..HEAD -- wiki/ | sort -u)
if [ -z "$CHANGED" ]; then
  echo "✓ no wiki page has changed since the last compile — skills are current"
  exit 0
fi

echo ""
echo "Wiki pages changed since then:"
echo "$CHANGED" | sed 's/^/  /'
echo ""

STALE=0
while IFS='|' read -r target source; do
  case "$target" in ''|'#'*) continue;; esac
  [ -n "${source:-}" ] || continue
  if echo "$CHANGED" | grep -qxF "$source"; then
    echo "  ✗ stale: $target  ← $source changed"
    STALE=1
  fi
done < <(grep '|' "$MANIFEST")

if [ "$STALE" -eq 0 ]; then
  echo "✓ wiki changed, but no page any target was compiled from — skills are current"
  exit 0
fi

echo ""
echo "→ run /compile in an agent session to rebuild the stale targets."
[ "$STRICT" -eq 1 ] && exit 1
exit 0
