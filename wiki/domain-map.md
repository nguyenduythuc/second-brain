---
title: "Domain Map"
type: meta
domain: brain
summary: "the four domains and how they relate: thinking is the shared kernel; capture is continuous but development is sequential; candidate questions awaiting Thức's ruling."
created: 2026-08-13
updated: 2026-08-13
schema_version: 2
sources: []
---

# Domain Map

Thức named the shape of the brain on 2026-08-13: **thinking (tư duy) is the
core that every other domain draws on**, followed by programming craft
(chuyên môn), psychology & emotion (cảm xúc), and economics (kinh tế) — all
developed *continuously*, never "finished and dropped".

He also said the non-core domains feel directionless (*mất phương hướng*).
This page is the structural answer to that, and it starts by disagreeing with
one premise.

## Correction: there are already two developed domains, not one

He described thinking as the only reasonably complete domain and the rest as
embryonic. Measured on 2026-08-13 {fact ✓2026-08-13 fast; method: `wc -l` over
the page sets}:

| Domain | Pages | Lines |
|---|---|---|
| thinking | 7 | 900 |
| **agents** | **6** | **973** |
| brain (meta) | 6 | ~490 |

**The agent-systems cluster is already larger by volume than thinking.** It
arrived as Question 3 of the [[wiki/thinking-roadmap]] and was never named as a
domain, so it stayed invisible in his own account of the brain. It is not a
subtopic of thinking: [[wiki/shepherd-review-gates]],
[[wiki/hermes-self-improvement-loop]] and [[wiki/self-improving-agent-systems]]
are engineering knowledge about building agent systems.

That matters practically: **he is not starting from zero on the technical
side.** The path to programming craft runs through a body of work that already
exists {inference — from the page counts plus the Ring 2 plan in `STATE.md`}.

## Thinking is a kernel, not just "important"

"Core" is easy to say and usually means nothing. It earns its name only if
there is a rule attached. The rule that makes it real:

> **Each peripheral domain's first question should be an application of the
> core's tools, not a fresh start.**

Fact-vs-opinion classification, the *"fact hay đoán?"* trigger, quantifier
matching, 5 Whys — these are instruments. A domain that never picks them up is
just a pile of notes next to the core rather than downstream of it.

The dependency direction should therefore run **peripheral → core**: economics
pages may lean on [[wiki/fact-vs-opinion]]; thinking pages should not accumulate
dependencies on economics specifics, or the kernel stops being stable. Status
boards (`type: meta`) are exempt — a roadmap legitimately points at everything
it tracks. `scripts/lint.sh` reports core→peripheral edges rather than failing
on them, because the rule has real exceptions and a check that cries wolf gets
ignored {normative-pragmatic, revisited 2026-08}.

## Why thinking worked, stated as a recipe

The directionlessness is not a character problem. Thinking has direction
because it had a *mechanism* the other domains never got. From
[[wiki/thinking-roadmap]] and the 06-12 → 07-16 entries in `log.md`, four
ingredients {inference — reconstructed from the record of what actually
happened}:

1. **A small number of questions — three, not a syllabus.**
2. **His own questions**, not a curriculum handed to him.
3. **Strictly sequenced.** Q2 did not open until Q1 closed.
4. **Closed on demonstrated application**, not on having read enough. Q2 closed
   the day he applied Rule of Three to a live case, not the day it was written.

Everything else — ingest, linking, lint — is bookkeeping around those four. The
new domains have none of them, which is a missing mechanism, not missing
willpower. This is the same lesson as `STATE.md`'s note that a rule without a
mechanism decays into a wish, applied to motivation instead of enforcement.

## Continuous domain, closable questions

There is a real tension in "develop all domains continuously." Thinking became
complete *because its questions closed*. If everything is permanently open,
nothing ever finishes, and the absence of closure is itself a cause of feeling
adrift.

The resolution:

> **The domain is continuous. The questions inside it are closable.**

A domain is never done — new material always arrives. But at any moment it
should have **one open question with a stop condition**, and closing it should
feel like something.

## Capture continuously, develop sequentially

The second tension: four continuous domains, one person, serial attention.
Thinking took roughly two months of concentrated work to reach its current
state. Four domains at that intensity in parallel is not available, and
attempting it reproduces exactly the scattered feeling being complained about
{inference}.

So split the two activities, which have different costs:

- **Capture is continuous and cheap, across all domains.** Anything worth
  keeping goes to `inbox/` or a source, whatever domain it belongs to. No
  roadmap needed, no guilt, no ordering.
- **Development is sequential and expensive — one active domain at a time.**
  Only the active domain gets an open question, ingests that trace implications,
  and pressure to close something.

The inactive domains are not neglected; they are *accumulating raw material*
that makes their eventual active phase much faster. This is what "continuous"
can honestly mean for one person.

## Candidate questions — drafted, not decided

Below are proposed first questions per domain, drawn from what the brain already
knows about him. **These are the agent's drafts, on the table next to his, in
keeping with *"trao đổi, không phó thác"* — a domain's questions must be his or
the mechanism does not work (ingredient 2 above).**
{proposal — awaiting Thức's confirmation, none of these is adopted}

**Programming craft (chuyên môn)**
- What is my craft actually made of — what do I know that a competent
  mid-level engineer does not? (Prerequisite for Ring 2: you cannot encode
  craft into skill files before naming it.)
- Which of my engineering judgments survive agent-written code, and which were
  scaffolding for human limits (review, naming, file size)?

**Psychology & emotion (cảm xúc)**
- Can I name an emotion before it drives a decision? This may not be a separate
  domain at all: his recorded person variable is *monitoring fires at inputs,
  goes silent where conclusions are born* ([[wiki/how-i-want-to-think]]), and
  emotion plausibly has the same guarded-entry/unguarded-exit shape
  {hypothesis, 2026-08 — worth testing before granting it domain status}.
- Which recurring reactions are information, and which are noise?

**Economics (kinh tế)**
- How does personal value actually convert into income — the mechanism, not
  the platitude? (`STATE.md` records his stance that job, salary and side
  income all follow from personal value; that is currently an untested premise.)
- Which economic claims am I holding as facts that are actually consensus
  opinion? (A direct application of [[wiki/fact-vs-opinion]] — the kernel rule
  in action.)

**Agent systems** — already has six pages and five recorded open gaps in
[[wiki/what-ai-structures-still-need]]; it needs a status board, not new
questions.

## Related

- [[wiki/thinking-roadmap]] — the working model every other domain should copy.
- [[wiki/brain-as-data-system]] — why domains are a frontmatter field rather
  than folders: the reader is an LLM, so physical partitioning buys nothing.
- [[wiki/fact-vs-opinion]] — the kernel instrument peripheral domains inherit.
- [[wiki/how-i-want-to-think]] — the practice card the core domain produced.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/about-this-brain]] · [[wiki/brain-as-data-system]] · [[wiki/thinking-roadmap]]
<!-- backlinks:end -->
