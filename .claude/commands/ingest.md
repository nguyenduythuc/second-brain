---
description: Ingest new material into the wiki (from inbox/, a pasted block, or a given path)
---

Run the **Ingest** operation defined in CLAUDE.md on: $ARGUMENTS

If no argument is given, process everything in `inbox/`. If the user pasted
content directly, treat the pasted block as the input.

Steps (follow CLAUDE.md exactly):
1. Read the new material.
2. **Discuss the key takeaways with the user first** — 3-6 bullet points.
   Confirm framing before writing anything.
3. Save the raw input verbatim to `sources/<YYYY-MM-DD>-<slug>.md`.
4. Write/update the relevant wiki page(s): a summary page for the source,
   plus any entity/concept pages it touches (create if missing, with
   frontmatter).
5. Add/repair cross-references (`[[wiki/...]]`) across affected pages.
6. Update `index.md`.
7. Append to `log.md`: `## [YYYY-MM-DD] ingest | <title> | wiki: <pages touched>`
8. Clear the processed item out of `inbox/`.
