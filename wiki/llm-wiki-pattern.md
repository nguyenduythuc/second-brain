---
title: LLM Wiki Pattern
type: concept
created: 2026-06-12
updated: 2026-06-12
sources: [sources/2026-06-12-karpathy-llm-wiki.md]
---

# LLM Wiki Pattern

A knowledge-management pattern proposed by [[wiki/andrej-karpathy]]: an AI
agent incrementally builds and maintains a persistent wiki of plain markdown
files, instead of re-reading raw documents on every question. This second
brain is a direct implementation of it (see [[wiki/about-this-brain]]).

## Core insight

Human wikis die because maintenance grows faster than value. An LLM agent
doesn't get bored, never forgets a cross-reference, and can touch many files
in one pass — so the wiki compounds instead of rotting.

## Architecture (three layers)

1. **Raw sources** — immutable inputs; the agent reads, never modifies.
2. **The wiki** — agent-owned markdown: summaries, entity/concept pages,
   syntheses, all cross-linked.
3. **The schema** — a config doc (`CLAUDE.md`) defining conventions and the
   ingest/query/lint workflows.

Two control files keep it inspectable: `index.md` (one-line catalog) and
`log.md` (append-only, grep-parseable history).

## Operations

- **Ingest** — read → discuss takeaways with the user → file + cross-link.
- **Query** — read relevant pages, synthesize; good answers become new pages,
  so using the brain grows the brain.
- **Lint** — periodic health check: contradictions, stale claims, orphans,
  missing pages/links.

## Design stance

No vector DB, no RAG, no embeddings — modern context windows hold a personal
knowledge base as plain text. Evidence it scales: Karpathy's single-topic wiki
reached ~100 articles / ~400k words with zero hand-written content.
