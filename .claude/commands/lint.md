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

Also verify mechanics: every wiki page is listed in `index.md`, frontmatter
is present and well-formed, all `[[wiki/...]]` links resolve, `log.md` is
parseable.

Append to `log.md`: `## [YYYY-MM-DD] lint | <n issues found>`
