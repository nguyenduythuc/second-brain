---
title: Obsidian vs. LLM Wiki (choosing the tool for a second brain)
type: concept
created: 2026-06-29
updated: 2026-06-29
sources: [sources/2026-06-29-karpathy-llm-wiki-field-notes.md]
---

# Obsidian vs. LLM Wiki

Why this brain uses **git markdown + an agent maintainer** instead of
Obsidian/Notion — and why the two aren't mutually exclusive.

## What Obsidian is

A **local-first** note app: notes are plain markdown files in a folder (a
"vault") on your machine. Strengths: bidirectional `[[wikilinks]]`, a **graph
view** that draws the network of notes, backlinks, and a large plugin ecosystem
(Dataview, spaced repetition, …). Free for personal use, cross-platform, mobile.

## The core difference: who maintains it?

| | Obsidian (manual PKM) | LLM Wiki (this brain) |
|---|---|---|
| Gardener | **The human** links, files, prunes | **The agent** links/cross-refs/restructures |
| Human's job | Think *and* maintain | Only *think* (the ingest discussion) |
| Failure mode | Abandon it when upkeep > value | (avoided — the agent doesn't get bored) |
| Interface | Rich GUI, graph view, mobile | No GUI; grep + file reads |
| Cost | Free, no LLM | Token/API cost |

Obsidian's failure mode is exactly what [[wiki/about-this-brain]] and
[[wiki/llm-wiki-pattern]] warn about: *humans abandon a wiki because upkeep grows
faster than its value.* The graph view is pretty but easily becomes a tangled
hairball; many people end up tweaking plugins more than thinking.

In fairness: Obsidian is excellent for anyone who wants **full manual control,
no LLM in the loop, no API cost, and an instant GUI/mobile.** Most PKM advice
predates capable agents. The two optimize for different things: Obsidian trades
for *control + interface*; this brain trades for *zero-maintenance + depth of
conversation*.

## The non-obvious point: use both

Since both are markdown + `[[wikilinks]]`, you can **point Obsidian at this very
`second-brain` folder as a vault** → get graph view, backlinks, mobile reading,
while Claude Code stays the maintainer. This isn't a side trick: Karpathy
**explicitly names Obsidian the "front-end of choice"** (rule VI of
[[wiki/llm-wiki-pattern]]) for spotting clusters, hubs, and orphans on the graph.

*(One technical note to verify: the agent writes path-style links like
`[[wiki/page]]`; Obsidian defaults to `[[note-name]]`. Open it once to confirm
the links resolve before trusting it.)*

## Recommendation

- **Don't switch to** Obsidian as the maintenance tool — it drags back the
  manual upkeep this design exists to escape.
- **Add Obsidian as a viewer** over the same repo if you want the graph view or
  mobile reading — nearly free to try.

## Related

- [[wiki/llm-wiki-pattern]] — the pattern this brain runs on; rule VI on Obsidian.
- [[wiki/about-this-brain]] — why agent-maintained avoids the rot.
