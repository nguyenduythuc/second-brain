---
description: Health-check the wiki and report (offer to fix) issues
---

Run the **Lint** operation defined in CLAUDE.md.

Report (and offer to fix):
- Contradictions between pages
- Stale claims superseded by newer sources
- Orphan pages (no inbound links)
- Concepts mentioned often but lacking their own page
- Missing cross-references
- Gaps the user clearly cares about but hasn't captured
- **Stale-fact scan:** every `{fact ✓date decay}` tag older than its TTL
  (fast 30d, medium 6mo, slow 3y) → flag for re-verification; treat as
  unchecked until re-verified
- **Quantifier scan:** absolute quantifiers (always/never/all/luôn/mọi/không
  bao giờ) in claims whose cited support is hedged ("so far", "cho tới giờ",
  "usually") → flag as illicit widening
- **Disputed ledger:** list every `{disputed: A vs B}` tag with both sources
- **Rule-of-Three scan:** patterns appearing 3+ times across sources/log
  without an extraction decision → prompt the "why does it recur?" analysis

Also verify mechanics: every wiki page is listed in `index.md`, frontmatter
is present and well-formed, all `[[wiki/...]]` links resolve, `log.md` is
parseable.

Also check `STATE.md`: are its open threads, working agreements, and
"last session" pointer still accurate? Stale continuity state is the most
expensive kind of rot — it silently misinforms the next session.

Append to `log.md`: `## [YYYY-MM-DD] lint | <n issues found>`
