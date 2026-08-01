---
title: Transcript Mining — the post-plan correction zone
type: concept
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-27-goal-split-and-transcript-filter.md]
---

# Transcript Mining

Design for **Goal B**: a wiki of *how Thức makes engineering decisions*, built
from his local Claude Code session transcripts. Distinct from
[[wiki/ring-2-encoding-the-craft]] (Goal A), which produces skill files that
stay in the monorepo and needs no transfer at all.

## Why the two goals must stay separate

| | Goal A — Ring 2 | Goal B — this page |
|---|---|---|
| Purpose | The agent codes to his standard without being told twice | His judgment survives the repo and the job |
| Artifact | Skill files **in the monorepo** | Wiki pages **here** |
| Transfer needed | **None** | Yes — this is the mechanism |

The agent originally conflated them: proposed "mine the monorepo," then drifted
into discussing transfer, which Goal A never required. Stating the goal before
designing the mechanism is the lesson (recorded in `STATE.md`).

## What actually belongs in Goal B — narrower than it first looks

Not "a wiki about React Native." That knowledge is public, well documented, and
models will out-know him on it. The only content the open internet cannot
supply is **his decision pattern**: what he trades off, what he *rejects* and
why, where his hard boundaries are. Everything else is commodity.

## The filter — Thức's contribution, and it's the whole design

> Look at conversations that had a **plan**. After the plan is accepted, there
> are usually things that need fixing. **That spot is worth learning from —
> without reading the whole transcript.**

Why this is the right anchor {inference — strong structural argument, not yet
measured}:

- Plan acceptance is a **discrete, greppable event**, not a keyword heuristic.
- What happens after it is the **delta between intent and reality** — precisely
  where his judgment overrode the agent's.
- Volume collapses from "months of transcripts" to a handful of segments per
  session, so it dodges the batch-import failure ([[wiki/llm-wiki-pattern]]
  rule V: importing everything produces a dump, not a wiki).

This also superseded the agent's objection that a manual round was needed
first to discover what the signal looks like — the filter spec already
answers that.

## Four kinds of post-plan correction — the classification is the hard part

Reading the JSONL is trivial; telling these apart is the actual work. **Not
every fix after a plan is an agent error:**

| Correction | What it really means | Where it belongs |
|---|---|---|
| Agent misread the requirement | Clarify/Spec phase failure | `plan-creator`, not a code skill |
| **Agent met the requirement the wrong way** | **His craft judgment** | Skill file — **highest value** |
| Agent touched what it shouldn't | Blast-radius failure | Task spec / containment |
| He changed his mind | New information, **not a lesson** | Discard — encoding a passing preference as law is how a skill library rots |

Row 2 is the target. Row 4 is the trap.

## Tool sketch

Claude Code stores session transcripts locally as JSONL (typically under
`~/.claude/projects/…`) {reported — to be verified against the actual install
before writing code}.

1. **Locate** transcripts for the monorepo project.
2. **Anchor** on plan-acceptance events; take the segment that follows.
3. **Extract** user turns in that segment that read as corrections, plus the
   agent's fix cycle.
4. **Classify** each into the four rows above — this step needs a model, not a
   regex.
5. **Emit** a digest: correction · classification · evidence (session + turn) ·
   proposed destination. **Propose only; write nothing automatically.**

### Three risks to design against

1. **The tool must be a filter, not a pipe.** If it can dump, someone will
   dump, and 17 careful wiki pages drown.
2. **Secrets.** Transcripts contain client code and may contain tokens. Redact
   before anything leaves the machine; decide the repo's visibility first.
3. **Infrastructure before value.** The brain is already a large architecture
   on a small corpus. Run the extractor over **one** session first and judge
   the digest before automating the rest.

## Related

- [[wiki/ring-2-encoding-the-craft]] — Goal A; skill files stay in the monorepo.
- [[wiki/what-ai-structures-still-need]] — gap 4 was "the log records what was
  decided, not the reasoning that produced it." Transcripts *are* that
  reasoning trail; this is the patch for our own gap.
- [[wiki/fact-vs-opinion]] — Rule of Three decides which corrections are worth
  extracting; row 4 above is the "surface coincidence / observer bias" case.
- [[wiki/how-i-want-to-think]] — the output lands here when it says something
  about how he decides.
