# Karpathy's LLM Wiki pattern (raw notes)

Captured: 2026-06-12
Origin: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (published 2026-04-04)
plus discussion with Claude while designing this second brain.

---

Karpathy proposes the "LLM Wiki": instead of having an AI re-read raw documents
every time, the AI incrementally builds and maintains a persistent wiki — a
structured, interlinked collection of markdown files that compounds over time.

Key quote:

> "Humans abandon wikis because the maintenance burden grows faster than the
> value. LLMs don't get bored, don't forget to update a cross-reference, and
> can touch 15 files in one pass."

Three-layer architecture:
- Raw Sources — immutable documents (articles, papers, notes). The LLM reads
  but never modifies them.
- The Wiki — LLM-generated markdown: summaries, entity pages, concept pages,
  comparisons, syntheses. The agent owns this layer entirely.
- The Schema — a config document (e.g. CLAUDE.md) with structure conventions
  and operational workflows.

Helper files: index.md (one-line catalog of every page, updated on each
ingest) and log.md (append-only chronicle, grep-parseable, entries like
`## [2026-04-02] ingest | Title`).

Core operations:
- Ingest: read source → discuss takeaways with the user → write summary page →
  update index → update related entity/concept pages → append to log.
- Query: search + read relevant pages, synthesize an answer; good answers
  become new wiki pages.
- Lint: periodic health check — contradictions, stale claims, orphan pages,
  missing concept pages, missing cross-references, data gaps.

Notable result: a single research topic grew to ~100 articles / ~400,000 words
without Karpathy writing any of it directly. He reviews results in Obsidian.

Design consequence he emphasizes: no vector databases, no RAG pipeline, no
embeddings — modern context windows are large enough to hold a personal
knowledge base as plain text.
