---
title: "LLM Wiki Pattern"
type: concept
summary: "Karpathy's agent-maintained wiki pattern (9 rules); the design this brain implements."
created: 2026-06-12
updated: 2026-06-29
schema_version: 2
sources: [sources/2026-06-12-karpathy-llm-wiki.md, sources/2026-06-29-karpathy-llm-wiki-field-notes.md]
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

> *"Most personal knowledge systems die of maintenance, not of bad ideas."*

## The nine rules (field-notes v040426)

Karpathy later formalized the pattern into nine rules. The throughline:
**the human owns judgment and the raw record, the model owns the bookkeeping,
the wiki is a compiled artifact that compounds.**

1. **Sources are immutable.** Everything lands in raw sources and is never
   edited. If a source is wrong, add a *correcting* source — don't rewrite
   history, or you get two records of truth and can't tell which is real.
2. **Separate the layers.** Three layers, three owners: raw (you), wiki (the
   model), schema file (both). Blurring them — model writing into raw, or human
   hand-tuning the wiki to win an argument — destroys the trust boundary.
3. **The model owns the wiki.** You rarely write a wiki page yourself; you
   choose what enters raw, ask questions, and think. If *you* end up doing the
   bookkeeping, the schema is underspecified, not the model.
4. **Compile, don't retrieve.** This is *not* RAG. RAG re-derives from raw
   chunks every query and accumulates nothing. Here sources compile once into
   linked pages. (raw = source code, model = compiler, wiki = executable,
   queries = runtime.) **Compiled knowledge compounds; retrieved knowledge is
   rediscovered.**
5. **Ingest one source at a time.** A good ingest isn't one new page — it's the
   model tracing a source's implications *across the graph*, touching every page
   the new fact changes. Batch-importing your whole digital life in a weekend
   produces a dump, not a wiki.
6. **Link everything.** Every wikilink is a visible edge. An entity that appears
   in five pages but links to none means a lazy ingest. *The value is in the
   edges, not the nodes.* (This is why Obsidian works as a front-end: the graph
   view exposes clusters, hubs, and orphans — see [[wiki/obsidian-vs-llm-wiki]].)
7. **Navigate by index.** Reach an answer via `index.md` → a few relevant pages
   → synthesis, not by loading the whole vault. If the model brute-forces the
   corpus every question, the index has stopped reflecting the territory.
8. **Lint the knowledge.** Treat the wiki like code. A contradiction is
   *information*, not an error to paper over — it means two sources disagree and
   you now know where to look. Skipping lint is how a wiki rots while the graph
   still looks impressive.
9. **Start small.** Ten sources, not ten thousand. Make ingest/query/lint feel
   natural before adding a search engine or a twenty-rule schema. Early pages
   are messy and naming conventions will change — that's normal. *A small wiki
   you actually feed beats a beautiful architecture you abandon in week three.*

## Architecture (three layers)

1. **Raw sources** — immutable inputs; the agent reads, never modifies.
   (This brain names this folder `sources/` rather than Karpathy's `raw/`.)
2. **The wiki** — agent-owned markdown: summaries, entity/concept pages,
   syntheses, all cross-linked. The human does *not* hand-edit these.
3. **The schema** — a config doc (`CLAUDE.md`; `AGENTS.md` also works)
   defining conventions and the ingest/query/lint workflows.

Two control files keep it inspectable: `index.md` (one-line catalog, the
navigation layer) and `log.md` (append-only, grep-parseable history).

## Operations

- **Ingest** — read → discuss takeaways with the user → file + cross-link,
  one source at a time, tracing implications across the graph.
- **Query** — route via `index.md`, read the few relevant pages, synthesize;
  good answers become new pages, so using the brain grows the brain.
- **Lint** — periodic health check: contradictions, stale claims, orphans,
  missing pages/links, entities with two spellings.

## Design stance

No vector DB, no RAG, no embeddings — modern context windows hold a personal
knowledge base as plain text. Evidence it scales: Karpathy's single-topic wiki
reached ~100 articles / ~400k words with zero hand-written content.

## Related

- [[wiki/andrej-karpathy]] — author of the pattern.
- [[wiki/about-this-brain]] — how this repo implements it.
- [[wiki/obsidian-vs-llm-wiki]] — Obsidian as a viewer over the same vault vs.
  as a manual-maintenance tool.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/about-this-brain]] · [[wiki/agent-org-multiplied-self]] · [[wiki/andrej-karpathy]] · [[wiki/brain-as-data-system]] · [[wiki/fact-vs-opinion]] · [[wiki/hermes-self-improvement-loop]] · [[wiki/obsidian-vs-llm-wiki]] · [[wiki/self-improving-agent-systems]]
<!-- backlinks:end -->
