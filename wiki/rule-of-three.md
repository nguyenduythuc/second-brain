---
title: Rule of Three — one principle, three substrates
type: concept
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-27-craft-philosophy-self-report.md]
---

# Rule of Three

**A pattern's third appearance is what justifies investing in a
generalisation.** Not the first (that's an instance), not the second (that
could be coincidence) — the third is evidence that something is *generating*
the repetitions.

This page exists because the rule triggered on itself. Thức supplied it three
times, in three different domains, on three separate occasions, without
noticing they were the same rule:

| Substrate | His formulation | Where it landed |
|---|---|---|
| **Code** | A pattern repeating across components → extract a component or custom hook | Originally offered as an analogy for knowledge work, 2026-07-16 |
| **Knowledge** | A pattern's 3rd appearance across sources/discussions → ask *why does it recur?* before extracting | Rule 7 of [[wiki/fact-vs-opinion]] |
| **Tooling** | *"Cái gì lặp lại 3 lần, cần có tool thay thế. Hoặc tự viết"* — whatever repeats three times needs a tool, or you write one | [[wiki/craft-philosophy]], 2026-07-27 |

## Why it recurs — root cause, not coincidence

{inference — argued, not measured}

Running the rule's own test on it: these are not three rules that happen to
share a number. They are **one decision problem in three materials** — *when
is the evidence sufficient to pay for an abstraction?* — and the cost
structure is identical in all three:

- **Abstract too early** → the wrong abstraction, which costs more than the
  duplication it replaced (the classic result in software design, and the
  reason rule 7 requires a *why* before extraction).
- **Abstract too late** → the repetition compounds: copy-paste drift in code,
  rediscovered lessons in knowledge, manual toil in tooling.

Three is the smallest sample that separates *pattern* from *coincidence* while
the cost of waiting is still low. That is why the same number surfaces
independently in every domain where someone pays both costs.

## The classification step is what makes it a rule rather than a reflex

Counting to three only opens the question. What follows is the actual work —
ask **why it recurs**, then classify:

- **Root cause** — one underlying force wearing different costumes → extract
  (a component, a concept page, a tool).
- **Surface coincidence** — they merely look alike → don't extract; a wrong
  abstraction is more expensive than duplication.
- **Observer bias** — the repetition lives in the observer, not the world →
  record it as a person variable, not as a law. (The agent hit exactly this
  failure right after learning the rule — see the "over-pattern-matching"
  entry in `STATE.md`.)

## Where it's live in this brain

- `CLAUDE.md` carries it as a filing rule; `.claude/commands/lint.md` scans for
  patterns appearing 3+ times without an extraction decision.
- It fired on "ownership labels or the automation eats human work"
  ([[wiki/hermes-self-improvement-loop]]) and on "the artifact outside the
  model is what accumulates" ([[wiki/self-improving-agent-systems]]).
- Currently at 2/3: **weakest-link composition** (argument strength in
  [[wiki/fact-vs-opinion]]; reversibility in [[wiki/shepherd-review-gates]]).
  One more sighting earns its own page.

## Related

- [[wiki/craft-philosophy]] — the tooling formulation, and the wider set of
  principles it sits in.
- [[wiki/fact-vs-opinion]] — rule 7, the knowledge formulation.
- [[wiki/reflection-and-depth]] — extraction *is* compression: many examples
  into one principle.
