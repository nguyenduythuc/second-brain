---
title: Metacognition
type: concept
created: 2026-07-14
updated: 2026-07-16
sources: [sources/2026-07-14-metacognition-q1.md, sources/2026-07-08-three-big-questions.md, sources/2026-07-16-metacognition-own-words.md]
---

# Metacognition

Deliverable of Question 1 on the [[wiki/thinking-roadmap]]. Two halves below:
the philosophy (what it *is*), then the framework (how to *run* it).

## Part 1 — The philosophy

**One line:** metacognition = thinking about your own thinking — a layer that
observes the layer that thinks.

**The stance underneath it:** your thinking is not *you* — it is a *process*,
and processes can be observed, measured, and adjusted. The same move
engineering made when it stopped trusting "the code looks right" and built
profilers, logging, and monitoring. Two commitments follow:

1. **Fallibilism as default (mặc định mình có bug).** The brain ships with
   energy-saving defaults: conclude fast, guess, favor the satisfying answer
   (see [[wiki/understanding-vs-doing]] — this is factory setting, not a moral
   failing). So the rational posture is not "try to be right" but "assume bugs,
   build an observer."
2. **The meta-level is the highest-leverage level.** Improving metacognition
   improves *every* other skill, because it governs when checking, learning,
   and strategy-switching happen at all. It is what turns experience into
   learning — [[wiki/reflection-and-depth]] is metacognition applied
   retrospectively.

**What it is NOT (two boundaries):**

- **Not critical thinking.** Critical thinking asks *"is this claim right?"* —
  it points outward at content (a test suite + lint rules). Metacognition asks
  *"is my thinking right, right now?"* — it points inward, and acts as the
  dispatcher that decides *when* critical thinking gets invoked (watch mode /
  CI trigger). You can own an excellent test suite that never runs on your own
  commits: that is precisely the common human asymmetry — critiquing others'
  claims well, one's own poorly. A metacognition gap, not a critical-thinking
  gap. *(Honest note: some academic frameworks treat metacognition as a
  component of critical thinking; the boundary is debated. The operational
  distinction above is stable and sufficient.)*
- **Not rumination (nghiền ngẫm vô hạn).** An observer layer that re-triggers
  itself — thinking about thinking about thinking — is a `useEffect` with no
  dependency array: infinite re-render, no paint. Healthy metacognition always
  has an exit: observe → detect → adjust → **act** → leave the loop.

## Part 2 — The framework (how to implement it)

Grounded in Flavell (1979), Schraw & Dennison (1994), and MIT TLL. Two
components; each maps to a different owner in a human+tool system.

### Component A — Metacognitive knowledge (storable)

What you *stably know* about the thinking machinery. Three kinds (Flavell):

| Kind | Meaning | Example from this brain |
|---|---|---|
| **Person variables** | Your strengths/weaknesses as a processor | Thức's failure signature: *social-feed input → instant consequence-prediction → felt satisfying* (see incident below) |
| **Task variables** | What kind of task this is, what it demands | "A claim from a social video is low-trust input — treat differently from a paper" |
| **Strategy variables** | Which strategy works when | "For hot news: search first, reason second" |

**This half lives in a tool.** It is data. This brain accumulates it: the
practice card [[wiki/how-i-want-to-think]] holds person variables; incident
reports add more over time.

### Component B — Regulation (trainable)

Three phases (Schraw & Dennison; MIT TLL uses the same triad):

1. **Planning (before):** what do I already know? what strategy fits? what
   will "done" look like?
2. **Monitoring (during):** am I understanding or assuming? fact or guess?
   is my current approach working?
3. **Evaluating (after):** was the outcome right? was the *process* right?
   what gets written back?

### Division of labor — the resolution of "why not just build a strong tool"

| Piece | Owner | Why |
|---|---|---|
| Knowledge (A) | **Tool/brain** | It's data; tools store and recall it perfectly |
| Planning (B1) | **Tool prompts, human decides** | Happens before the task — a checklist can trigger it |
| Monitoring (B2) | **Human only** | Happens real-time inside the head; no tool stands there. Only reps internalize it |
| Evaluating (B3) | **Tool schedules, human judges** | Happens after — retros can be scheduled (this brain's ingest discussions and weekly lint are exactly MIT's journaling / scheduled-reflection examples) |

**Tools amplify metacognition; they cannot replace it.** Outsourcing B2 is
outsourcing the very thing that makes the original worth multiplying
([[wiki/agent-org-multiplied-self]]).

## Case study — the SpaceX incident (2026-07)

Facebook video: "China lands and recovers rockets like SpaceX." Thức's instant
reaction: *"cổ phiếu SpaceX lại sấp mặt"* (SpaceX stock is done for). His
wife's one sentence — *"thử search xem có thật không"* (try searching whether
that's real) — stopped him cold; he recognized he'd concluded from feeling,
with no facts as raw material.

The autopsy, in framework terms:

- **The conclusion failed at two fact layers:** (1) Zhuque-3's first recovery
  attempt had *failed* (Dec 2025); a successful SpaceX-style recovery was a
  plan, not an accomplished fact. (2) SpaceX is a private company — there is
  no listed stock to crash. The premise died in a 5-second check.
- **Monitoring was external.** The alert fired in his wife, not in him — he
  received the webhook. The goal of reps: internalize her question so the
  pause fires *before* speaking. (She recurs as his highest-quality feedback
  source — see [[wiki/how-i-want-to-think]].)
- **Control/evaluating was strong.** Once signaled he stopped instantly, no
  defensiveness, and jumped levels on his own: *"the stock price no longer
  matters"* — valuing the meta-lesson over the object question. That is
  Component B3 working.
- **Person variable extracted (the design payoff):** the failure signature is
  *unverified feed input → instant consequence-prediction → arrives fast*
  [and, inference not yet confirmed by Thức: *feels satisfying*]. Hence the
  refined trigger: **speed + relish = red flag** — an instant, tasty
  conclusion is exactly when the guess-probability peaks, because real facts
  usually take effort to recall.

## Practice hooks (what actually changes behavior)

- Trigger 1 (existing): about to lock a conclusion + a flicker of unease →
  *"fact hay đoán?"*
- Trigger 2 (new, from this incident): conclusion arrives *instantly* and
  *feels good* → red flag → same question.
- Move 2 (new, learned from Thức's wife): before reasoning on top of a piece
  of news — *"nguồn đâu, search đã"* (where's the source? search first).
  Verify input before building on it — the sources-first principle of this
  very brain, applied to daily life.

## Thức's working definition (closed the Feynman test, 2026-07-16)

In his own words, kept verbatim (Vietnamese — his thinking language):

> Nghĩ về những lập luận, tư duy mà nó đã tạo ra những quyết định trước đó —
> nghĩ về lập luận chứ không phải nghĩ vào quyết định, vì quyết định là
> output, nên nghĩ về tầng sâu hơn. Từ đó nhận ra lỗ hổng trong lập luận và
> tìm cách fix. [\... ] Metacognition trong lúc đang nghĩ là mỗi khi có một
> lập luận được sinh ra, tự hỏi: có bằng chứng hỗ trợ không, còn lỗ hổng nào
> trong suy luận không.

Two notes on this definition:

- **His original contribution:** examine the *reasoning*, not the *decision* —
  the decision is the return value, the reasoning is the function body. Fixing
  the body fixes whole classes of future outputs; reviewing only decisions is
  whack-a-mole. This came from him, not from the literature summary.
- **Calibration added in discussion:** "every time a claim is born" is too
  expensive — monitoring runs on *triggers* (red flags: instant + satisfying
  conclusion, a flicker of unease, high stakes), not on polling every thought.
  Like alerting vs. reading all logs at DEBUG level: the cost of observation
  must stay below its value, or the observer gets abandoned (or worse, turns
  into rumination).

Closing evidence worth recording: in the very message that completed this
definition, he labeled his own claim as inference ("tôi chỉ có thể tự suy
diễn") and turned the monitor on his own sentence ("ngay cả những gì tôi đang
nói, chúng ta cũng nên tự hỏi tôi nghĩ vậy có đúng không") — a live
demonstration of in-flight monitoring, performed while defining it.

## Related

- [[wiki/how-i-want-to-think]] — the personal practice card these hooks live on.
- [[wiki/reflection-and-depth]] — reflection = retrospective metacognition.
- [[wiki/understanding-vs-doing]] — why reading this page changes nothing
  without reps; monitoring is procedural, not declarative.
- [[wiki/agent-org-multiplied-self]] — why B2 must stay human.
- [[wiki/thinking-roadmap]] — Q1 status board.
