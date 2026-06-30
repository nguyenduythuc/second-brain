---
title: About This Brain
type: meta
created: 2026-06-12
updated: 2026-06-29
sources: []
---

# About This Brain

This is a personal **LLM Wiki** — a second brain maintained by an AI agent
(Claude Code) rather than by hand. The pattern is the [[wiki/llm-wiki-pattern]]
from [[wiki/andrej-karpathy]]: keep everything as plain markdown, let the agent
read it into context, and have it own the structured wiki layer so the
maintenance burden never falls on me.

## Why it works

A human abandons a wiki because upkeep grows faster than the value. An agent
doesn't get bored, doesn't forget a cross-reference, and can touch many files in
one pass. So the wiki actually compounds instead of rotting.

## How I use it

- **Capture** anything worth keeping — an AI chat that clicked, an idea, an
  article — and run `/ingest`.
- **Discuss** the takeaways with the agent; that conversation is the real
  thinking. The files are what survive it.
- **Ask** the brain with `/query` when I need to recall or connect things.
- **Lint** periodically to catch contradictions, stale claims, and orphan pages.

## The rule that keeps it honest

`sources/` is immutable raw input. `wiki/` is the agent's living synthesis.
Everything links to everything related — **the value is in the graph, not any
single page.** The human owns `sources/` and judgment; the agent owns `wiki/`
and all bookkeeping. The human does not hand-edit `wiki/`: to change a
conclusion, add a correcting source or discuss it so the agent rewrites the page.

## Language

Wiki content is written in **English**, with **inline Vietnamese glosses** for
terms English doesn't capture cleanly — e.g. *Three Views (Tam Quan)*,
*worldview (thế giới quan)*, *reflection (phản tư)*. Signature personal
self-talk phrases may stay in Vietnamese (e.g. the trigger *"fact hay đoán?"*).
`sources/` stays verbatim in the source's own language. `CLAUDE.md` and
`.claude/commands/` are in English — the agent-facing "code" layer.

See `CLAUDE.md` at the repo root for the full operating schema.
