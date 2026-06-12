---
description: Answer a question grounded in the wiki, citing the pages used
---

Run the **Query** operation defined in CLAUDE.md for: $ARGUMENTS

Steps (follow CLAUDE.md exactly):
1. `grep` + read the relevant wiki pages (and sources if needed).
2. Synthesize an answer grounded in the brain. Cite the pages you used.
3. If the answer is genuinely new and worth keeping, **offer to save it as
   a new synthesis page** in `wiki/`.
4. Append to `log.md`: `## [YYYY-MM-DD] query | <question>`
