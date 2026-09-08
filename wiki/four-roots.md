---
title: Four Roots — what 5 Whys reaches under everything in this brain
type: synthesis
created: 2026-09-08
updated: 2026-09-08
sources: [sources/2026-09-05-ng-using-coding-agents.md, sources/2026-09-05-ng-ai-engineering-skills-map-verbatim.md, sources/2026-09-01-graph-engineering-kopadze.md, sources/2026-07-27-lfvn-coding-convention.md]
---

# Four Roots

Thức asked for the essence (*tinh tuý*): run 5 Whys on Ng's claims **and** this
brain's own claims until they are exhausted, and see what is left.

Sixteen load-bearing claims were drilled. They land on **four** roots. Nothing
so far lands outside them.

{inference — these are derivations, not measurements. The value is that
independently-derived claims converge; convergence is evidence of a shared
cause, not proof of one.}

---

## R1 — Nothing can validate itself. The standard must come from outside.

The widest root. Eight of the sixteen chains end here.

**Ng, "long-horizon autonomy is overhyped":** errors compound → the agent
cannot detect its own drift mid-run → self-assessment happens in the context
that produced the work → a judgement needs a reference point → the run's own
context is the agent's entire world, and nothing in it is privileged as ground
truth. **More computation amplifies whatever was already there.**

**Ng, "evaluate the tests themselves":** a test can pass while measuring the
wrong thing → it encodes an assumption about "correct" → assumptions drift
while tests stay fixed → passing looks like success → the test sits inside the
system it judges.

**Ng, "fundamentals matter more, not less":** you must frame tradeoffs the
agent can't → it optimises what it was told → tradeoffs encode values →
values live outside the task → "better" depends on what you are for.

**Brain, "execution multiplies, judgment does not":** copies share only the
*encoded* standard → tacit judgment is pattern recognition, not an artifact →
n copies of an unstated standard is n copies of no standard.

**Brain, "the artifact outside the model is what accumulates":** improvement is
a delta → a delta needs a previous state → context resets. Same root along the
**time** axis: the record is the external anchor when the other system is your
own past self.

**Thức, "clean-clear = a BA or tester can read it":** clarity defined by
someone else's ability to use it → "clear to me" is unfalsifiable → **the
writer cannot detect their own opacity.** Exactly why the agent cannot detect
its own drift.

*Không có gì tự chứng minh được chính nó. Thước đo phải đến từ bên ngoài.*

**Consequence:** every rule in this brain that works is a way of importing an
outside reference — a cold verifier, a date, a test that ran, a reader who
isn't you, a file that outlives the session.

---

## R2 — A rule without a trigger does not fire.

**Ng, "routines to keep trying new tools":** judgment only fires when something
appears → the field moves faster than things cross your path → you fall behind
without noticing → **absence of signal feels like absence of change** →
nothing schedules the looking.

**Brain, "memory is a cache with no TTL":** facts are time-indexed, memory is
not → storage records content, not validity conditions → familiarity feels like
verification → recall is cheap, re-checking is expensive → nothing forces the
expensive path.

**This brain's own history is the proof.** The weekly lint had good judgment
and a broken trigger, so it never ran once in three weeks. The fix was not
better judgment; it was `check-skill-drift.sh` — a trigger that costs nothing
and stays silent when there is nothing to do.

Thức has a **classifier** for new technology (adopt / migrate / wait) and no
**scanner**. Same gap, in his own practice.

*Có luật mà không có cái gì kích hoạt nó thì luật không chạy.*

---

## R3 — A check that costs more than it is worth gets skipped, and a skipped check is worse than none.

Worse, because it still looks like coverage.

**Thức's ratchet:** old debt does not block the build → blocking on it stops
work → **a gate people bypass is worse than no gate** → they bypass when its
cost exceeds its value *at that moment* → so grade the gate by where you are.

**Ng, "prune skills when obsolete":** obsolete skills cost context → context is
finite and shared → every loaded rule taxes every turn.

**Brain, sparse epistemic tags:** tag only load-bearing claims → tag noise kills
the habit → a habit that dies protects nothing.

**Ng, "decompose into verifiable steps":** verifiability falls as scope grows →
a big step has many failure modes and one summary output → and the check must
stay cheaper than the work or it will not be run.

*Cái gate mà người ta bypass thì tệ hơn là không có gate.*

---

## R4 — Under uncertainty, prefer the option that is cheaper to undo.

**Brain, Rule of Three:** wait for the third sighting → two could be coincidence
→ a wrong abstraction costs more than duplication → because it must be
un-built, and everything downstream depends on it.

**Thức's route 3, *"tắt ngay chứ ko cố sửa"*:** turn the new tech off rather
than fight it → the cost is the sunk effort, not the technology.

**Thức's document-for-recovery:** write the restore procedure at change time →
converting a hard-to-undo change into a compensable one.

**Shepherd's `ReversibilityLevel`, and propose-don't-apply.**

**Ng's MVP-vs-build-carefully:** when to ship fast for feedback, when to slow
down — the same routing by cost-of-being-wrong.

### This resolves an open question

On 2026-07-27 the agent spotted "keep the undo path cheap" at three sightings
and **refused to extract it**, flagging its own over-pattern-matching failure
mode and putting the call to Thức. He never answered.

The 5 Whys now supplies what was missing then: not a resemblance between three
things, but a **shared derivation** — all of them reduce uncertainty cost by
keeping reversal cheap rather than by trying to be right in advance.

**Still his call**, but the argument is now a derivation rather than a hunch.

*Khi chưa chắc, chọn cái dễ quay đầu nhất — không phải cố đoán cho đúng.*

---

## What the four roots are, in one line each

1. **The standard comes from outside.** Build reference points you did not author.
2. **Rules need triggers.** Judgment without a trigger is decoration.
3. **Cheap enough to survive.** A check must cost less than it saves, or it dies and leaves a shadow.
4. **Cheap to undo beats likely to be right.**

They are not independent. **R1 says what to build, R2 says what makes it run,
R3 says what keeps it alive, R4 says what to do when you cannot know.**

## The roots are not independent — R1 and R3 fight

Found 2026-09-08 by running the generator across three domains
([[wiki/framework-generator]]). **The cost of an outside check varies enormously
by domain, and R3 says an expensive check gets skipped.** In code the two roots
agree — an automated test is cheap *and* external. In learning they conflict
hard: every cheap substitute for a real outside reader sits inside your own
head, so it satisfies R3 by violating R1.

**This is the structural cause of self-deception in slow-feedback domains.**
Rule of thumb, not a solution: buy the cheapest *real* external check rather
than a cheap fake one.

## Where this could be wrong

- The chains were drilled by the same agent that wrote most of these pages —
  **R1 applies to this page itself.** It needs an outside reading, and Thức is
  the only one available.
- Four is suspiciously tidy. The honest next step is **falsification**: find a
  load-bearing claim that lands on none of them. Until that search runs, "these
  four cover everything" is unearned.

## Related

- [[wiki/agent-operating-model]] — most of Ng's claims drilled here come from it.
- [[wiki/craft-philosophy]] — R1 is the through-line of his own principles.
- [[wiki/fact-vs-opinion]] — R1 is why rule 6 exists; R3 is why tags stay sparse.
- [[wiki/rule-of-three]] — R4's clearest instance.
- [[wiki/ratchet]] — R3 in his own repo.
- [[wiki/what-ai-structures-still-need]] — the five gaps read differently under these roots.
- [[wiki/metacognition]] — 5 Whys is Move 4 on the practice card; this page is that move run at scale.
