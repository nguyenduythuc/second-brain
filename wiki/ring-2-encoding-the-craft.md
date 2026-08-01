---
title: Ring 2 — Encoding the Craft (monorepo plan)
type: synthesis
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-08-agent-org-multiplied-self.md, sources/2026-07-16-hermes-self-improvement.md, sources/2026-07-16-shepherd-architecture.md]
---

# Ring 2 — Encoding the Craft

The plan for turning Thức's 10+ years of React Native / Next.js monorepo
judgment into artifacts an agent executes. Ring 2 of the three-ring plan in
[[wiki/agent-org-multiplied-self]] — the ring where the economics actually
change.

**Scope note — Goal A only.** This page covers skill files that live *in the
monorepo* and require **no transfer to this brain**. The separate goal of
building a decision-making wiki here is [[wiki/transcript-mining]]; conflating
the two was a recorded agent error. The monorepo is not this repo — the work
happens in a session opened on it.

**Two ways to carry it over, most direct first:**
1. **`ring2-commands/`** — copy `mine-history.md` and `retro.md` into the
   monorepo's `.claude/commands/` once, then it's `/mine-history` and
   `/retro` forever. This is the real deliverable: the loop becomes typed
   commands, not a document to re-read.
2. `scripts/ring2-kickoff.md` — a self-contained brief to paste, if a one-off
   conversation is preferred over installing commands.

## The precondition is already met

Ring 2 needs real agent-executed work to retro on. Thức has been agentic
coding on the monorepo for months {reported, 2026-07-27}, so the raw material
exists. This changes the first move: **don't start by writing skills from
imagination — mine the history that already encodes them.**

## Where the knowledge is currently trapped

Every time he reviews a PR and says *"no, not that way — it breaks on Android
when the keyboard opens,"* a piece of accumulated judgment fires once and
evaporates. It lives in exactly one place — his head — and activates only
when he personally sits down. It doesn't copy, doesn't run in parallel, and
is unavailable when he's busy or sick.

Ring 2 makes those firings persistent.

## Phase 1 — Mine (the highest-yield step, and nobody starts here)

Apply the **Rule of Three** ([[wiki/fact-vs-opinion]] rule 7) to his own work
history rather than to reading material:

- **PR review comments he has written.** Anything he has said 3+ times is, by
  definition, a rule he holds but hasn't encoded. Those become the first
  `## Known failure modes` entries.
- **Commits that fix an agent's output.** Every "fix:" commit right after an
  agent-authored commit is a recorded gap between the agent's standard and
  his. That diff *is* the missing skill content.
- **Production incidents.** These become `## Anti-patterns (do NOT do)` — the
  highest-value section because it encodes cost paid in real damage.

For each candidate, run the why-does-it-recur test before extracting: root
cause (encode it) / surface coincidence (skip) / observer bias (his own
preference, worth labeling as such rather than presenting as a law).

## Phase 2 — Make the existing skills compound

`plan-creator` and `clean-clear-code` already exist but are **static** —
written once, never updated. Per [[wiki/hermes-self-improvement-loop]], a
static skill is wasted scaffolding. Add to each:

- `## Known failure modes` — from Phase 1 mining
- `## Anti-patterns` — from incidents
- `## Escalate to human` — the boundary where the agent must stop

## Phase 3 — Install the loop (this is what makes it Ring 2, not documentation)

Borrowed directly from what we ingested, minus what those systems admitted
was broken:

1. **Quantified trigger**, not "consider it sometimes": after a task with 5+
   tool calls, a fixed tricky error, or any correction from Thức → run a
   retro pass.
2. **Signal-based retro prompt** — never "did you do well?" but a checklist of
   evidence: *did he correct the style? the workflow? did a loaded skill turn
   out wrong?* Frustration phrases are first-class signals.
3. **Patch, not rewrite** — small diffs to skill files with structural
   validation and an undo path.
4. **Propose, don't apply** — the retro emits a *diff proposal*; Thức reviews
   and accepts. His review-gate instinct was independently validated by the
   Hermes team, who tried full automation first and had to add a human back
   ([[wiki/shepherd-review-gates]], [[wiki/hermes-self-improvement-loop]]).
5. **Provenance** — mark which skills are hand-written; the loop may only
   *propose* changes to those, never overwrite.

## Phase 4 — Monorepo-specific containment

The one Shepherd idea that maps directly onto a monorepo: **declare blast
radius per task.** Every task states which packages it may write to; anything
else is read-only. This is the mechanical answer to "the agent fixing the new
app accidentally touched the legacy one." Start as a declaration in the task
spec; harden later if it proves necessary — enforce hard where an effect is
irreversible, keep it a guideline where git makes it `AUTO`-reversible.

Also worth porting: a `STATE.md` in the monorepo, same role as this brain's —
what was tried, what's verified, what's still open, where the last session
stopped.

## Success criteria (so this can be judged, not felt)

- After 4 weeks: ≥3 skills carry sections that did **not** exist at the start,
  every one of them traceable to a real incident or a real review comment.
- The agent stops making a class of mistake it used to repeat — the cheapest
  evidence that encoding worked.
- Thức's review time per agent task trends down while acceptance rate holds.

## The failure mode to watch

Writing skill files from imagination instead of from evidence. That produces
a plausible-looking library nobody's work actually depends on — exactly the
flat one-off library Hermes warns about. **Every entry must be traceable to
something that really happened.**

## Related

- [[wiki/agent-org-multiplied-self]] — Ring 2 is where execution multiplies;
  quality stays capped by the encoder.
- [[wiki/hermes-self-improvement-loop]] — the retro loop mechanics.
- [[wiki/shepherd-review-gates]] — blast radius and propose-don't-apply.
- [[wiki/self-improving-agent-systems]] — skills as procedural memory.
- [[wiki/fact-vs-opinion]] — Rule of Three, applied here to work history.
