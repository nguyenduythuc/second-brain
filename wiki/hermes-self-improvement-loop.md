---
title: "Hermes — The Self-Improvement Loop"
type: concept
summary: "how a retro loop is actually built: quantified triggers, signal-based reflection, patch-not-rewrite, provenance, reversible lifecycle; and its admitted failure (agents self-congratulate) fixed by trace-based reflection + automated gates + human PR."
created: 2026-07-16
updated: 2026-07-16
schema_version: 2
sources: [sources/2026-07-16-hermes-self-improvement.md]
---

# Hermes — The Self-Improvement Loop

Second of three architecture documents under Question 3 of the
[[wiki/thinking-roadmap]]. It patches **seam 3** of
[[wiki/human-org-ai-mapping]]: agents forget by default, so learning must be
installed. Where [[wiki/self-improving-agent-systems]] says *what* should
compound, Hermes shows *how the retro loop is actually built* — and, more
valuable, **where it fails**.

## Source trust — the strongest of the three

Two open-source repos (NousResearch, MIT licensed) with code excerpts and
original design comments preserved {reported — code shown is real and
attributed; the agent has not independently pulled the repos}. This is a
working system's source, not an essay: claims about *what the system does*
carry far higher trust than claims about *what works well*. Keep the
distinction — implementation ≠ evidence of effectiveness.

## The core architecture

Two tiers, and the relationship between them is the lesson:

- **Runtime (in-session):** fully automatic. Every N turns a "nudge" fires,
  forking a review agent that updates memory and skills.
- **Offline (GEPA):** human-gated via PR review — **added specifically to
  compensate for the runtime tier's admitted weakness**.

## Six mechanisms worth stealing

### 1. Quantified triggers, not "consider it sometimes"

{fact ✓2026-07-16 medium; method: source code shown} Reflection fires on
concrete thresholds — a task taking 5+ tool calls, a tricky error fixed, a
non-obvious workflow discovered — and is counted **by turn number**, not by
subjective judgment.

The design insight: **counting decouples the reflection rhythm from the work
rhythm.** This is the machine version of the calibration Thức and I reached
for human monitoring (rule: trigger-based, not polling — see
[[wiki/metacognition]]). Same problem, same solution, arrived at
independently. {Second appearance of "observation must be triggered, not
continuous" — noted for rule 7.}

### 2. Reflection driven by signals, not self-assessment

The review prompt never asks "did you do well?" — it lists **specific signals
to hunt for**: did the user correct your style? your workflow? was a loaded
skill wrong? Frustration phrases ("stop doing X", "too verbose") are called
**first-class skill signals**.

This is the direct engineering answer to the self-congratulation trap, at the
prompt layer. Compare with what this brain does: my Rule-of-Three analysis of
Thức skipping exercises was exactly this — hunting a concrete behavioral
signal rather than asking myself whether the sessions "went well."

### 3. Patch, not rewrite — with validation and rollback

{fact ✓2026-07-16 medium; source code} The default action is a targeted
find-and-replace, never a full-file rewrite, because rewriting risks breaking
what already works (and costs more tokens). Around it: fuzzy matching so
whitespace differences don't fail the edit, **frontmatter validation after the
patch**, and **automatic rollback** if a security scan objects.

Generalizable rule: **when an LLM edits its own instructions, use small diffs
with structural validation and an undo path** — the same instinct as never
force-pushing to main.

### 4. Provenance — the boundary the automation may not cross

{fact ✓2026-07-16 medium; source code} The curator and optimizer may touch
**only agent-created skills**. Bundled, hub-installed, external, and pinned
skills are untouchable regardless of any flag.

This is the same trust boundary as [[wiki/llm-wiki-pattern]] rule II (human
owns sources, model owns wiki), discovered independently by an engineering
team that had to stop automation from eating hand-written work. **Third
independent appearance of "mark who owns what, or the automation destroys the
human's work"** → rule 7 fires. Why does it recur? Because any system where
an automaton edits shared state faces the same failure: without an ownership
label, the automaton cannot distinguish *its own guesses* from *deliberate
human decisions*. Root cause — structural, not incidental.

### 5. Lifecycle that is reversible, with a grace floor

{fact ✓2026-07-16 medium; source code} Skills age `active → stale (30d) →
archived (90d)`, and the invariants are the interesting part:

- **Never auto-delete — only archive.** Archive is recoverable.
- **Pinned skills bypass everything.**
- **Grace floor:** a never-used skill isn't archived just for being unused —
  *"not used is absence of evidence, not evidence of obsolescence — the
  trigger may simply not have occurred yet."*

That last comment is a clean epistemic distinction — absence of evidence vs.
evidence of absence — implemented as code. It maps directly onto
[[wiki/fact-vs-opinion]]'s status axis: "unchecked" ≠ "false".

### 6. Progressive disclosure and three memory stores

{fact ✓2026-07-16 medium; source code} Only `(name, description)` per skill
sits in the system prompt; bodies load on demand — so 200 skills cost roughly
what 40 cost. **This is precisely `index.md`'s job in this brain** — the
navigation layer, rule VII of [[wiki/llm-wiki-pattern]]. Independent
rediscovery again.

And the memory split, which the doc argues is why most agent memory systems
decay: **episodic** (what happened, when — searched on demand) vs.
**procedural** (how to do this kind of work — index always present) vs.
**prompt memory** (what's always true about the user — always loaded). Mixing
them into one store is the failure mode. Mapping onto this brain: `log.md` =
episodic, `wiki/` = procedural, `CLAUDE.md` + `how-i-want-to-think` = prompt
memory. The separation already exists here, unnamed until now.

## The admitted failure — and why it matters most

> The runtime tier's known weakness: **the agent almost always thinks it did
> well.**

This is stated by the system's own authors {reported — self-reported by the
implementers, which makes it *more* credible, not less: nobody advertises
their system's weakness without cause}. Their fix is an entire offline tier:

- **Trace-based reflection** — read the *execution trace* to learn **why**
  something failed, not merely that it failed. Evidence beats self-report.
- **Constraint gate before the human** — size ceiling, **growth limit vs.
  baseline** (stops prompt bloat), frontmatter still valid, full test suite
  must pass 100%. Proposals failing the gate never reach the reviewer.
- **Holdout comparison** — accept a change only if it scores better on data
  never seen during optimization, to prevent overfitting to the session that
  produced it.
- **PR review** — a human decides last.

**The lesson, stated plainly:** a fully automatic self-improvement loop was
not trustworthy enough on its own; the team had to add evidence-based
reflection, automated gates, and a human at the end. That is a strong
argument for Thức's existing review-gate instinct — arrived at by a team that
tried the automated version first.

Note the layered defense: **automated gates filter the garbage so the human
only reviews plausible proposals.** Human attention is the scarce resource;
the gate protects it. This directly answers a question we haven't asked yet:
what stops "be the bottleneck" from making the human the bottleneck in the
bad sense.

## What it means for this brain

Already present here: provenance boundary (rule II), progressive disclosure
(`index.md`), the three memory stores, human review gate.

**Genuinely missing** — candidates for a future mechanism upgrade:

- **Quantified triggers.** This brain's "track thinking moves" principle is
  qualitative ("when a metacognitive event happens"). Hermes says: count
  something. Not yet adopted — Thức's reps are user-initiated
  ([[wiki/how-i-want-to-think]]), so a turn-counter may misfire here. Open.
- **Growth limit.** Nothing currently stops a wiki page from bloating each
  ingest. A `max_growth vs. baseline` check is a candidate lint rule.
- **Reversible lifecycle for pages.** No stale→archive path for wiki pages
  that stop being referenced; lint reports orphans but nothing ages out.
- **Trace-based reflection.** The log records *what was decided*, not the
  reasoning trail that produced it. Weaker than Hermes's execution traces.

## Related

- [[wiki/self-improving-agent-systems]] — the layer model this implements;
  Hermes is its layer 4 in working code.
- [[wiki/human-org-ai-mapping]] — seam 3 (forgetting) is what this patches.
- [[wiki/fact-vs-opinion]] — the grace-floor comment is "unchecked ≠ false"
  as code; rule 6 (compose verifiers) is what GEPA's design argues for.
- [[wiki/metacognition]] — signal-based review is monitoring done honestly;
  the self-congratulation weakness is why B2 can't be self-graded.
- [[wiki/llm-wiki-pattern]] — rules II and VII rediscovered independently.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/human-org-ai-mapping]] · [[wiki/shepherd-review-gates]] · [[wiki/thinking-roadmap]] · [[wiki/what-ai-structures-still-need]]
<!-- backlinks:end -->
