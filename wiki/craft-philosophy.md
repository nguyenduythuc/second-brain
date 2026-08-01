---
title: Craft Philosophy — how Thức engineers
type: synthesis
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-27-craft-philosophy-self-report.md]
---

# Craft Philosophy

Thức's engineering principles, in his own account, plus the through-line he
didn't state and the conflict-resolution rules that are the hard-won part.

**Epistemic status of this page:** built from a **self-report from memory**,
not from observed behaviour. Most of it is normative ("code *should* be
clean-clear"); the descriptive claims about his own practice ("I always
prioritise performance") are checkable against the monorepo. This page is the
**hypothesis**; the monorepo is the **evidence**, and
[[wiki/ring-2-encoding-the-craft]] is how it gets tested. Self-reports about
one's own practice are systematically biased — we recorded that agents
self-congratulate ([[wiki/hermes-self-improvement-loop]]); humans do too. The
valuable question after mining: *where did he believe he always does X and
the record disagrees?*

## The stated principles

1. **Thinking over tools.** Held since before AI; he judges it more true now,
   not merely still true.
2. **Clean-clear code** = a BA or tester who can't code can still read it —
   because that means the code is logical, explicit, linear.
3. **Clear = structured.** Fixed slot order in a component: imports → state and
   consts → effects/hooks/functions → the view. (One example among many.)
4. **Reusability** — not only clarity, but less downstream work.
5. **Adopt new technology deliberately.** MMKV over AsyncStorage, New Arch over
   Old Arch, React 19 without memo hooks. Rationale: *new technology exists to
   solve today's problems.* Pre-AI this cost heavy research — framework docs,
   Medium, X, GitHub.
6. **Performance and debuggability, during the work, not after.** Skipping
   performance practice creates tech debt that is very hard to repay later;
   debugging is what localises a problem fast. **In the AI era he adds: make
   sure the AI can get plenty of context from the debuggers.**
7. **Document processes, conventions, difficulties.**
8. **Agile/Scrum** — break work small, stay flexible; **retro is his favourite
   activity**, because it makes him better after each sprint.

## The through-line he didn't state: optimise for the reader

{inference — strong: it fits 6 of the 8 principles above}

Look at what the principles have in common. Clean-clear is defined by *a
non-coder being able to read it*. Fixed slot order means *the reader knows in
advance where things live*. Reusability is justified as *transparency*.
Documentation makes *process* readable. And "give the AI context from the
debuggers" is legibility for a machine reader.

**His craft philosophy optimises for the reader, not the writer.** That is why
it transferred into the agentic era so cleanly: **an agent is just one more
reader.** He has been writing agent-friendly code for ten years without
framing it that way — which is the mechanism behind his claim that "thinking
over tools" became *more* true with AI rather than merely surviving.

(Performance is the partial exception — it serves the machine, not a reader.
He frames it as tech debt, which is a claim about *future readers of the
cost*, so it fits at one remove.)

## Resolving the conflict: adopt-early vs. stay-readable

New technology means unfamiliar patterns, thin documentation, harder reading —
in direct tension with principle 2. He does **not** trade these off globally.
He **routes by migration cost and keeps reversal cheap**:

| Route | The real criterion | His example |
|---|---|---|
| **Adopt now** | API surface is near-identical → migration cost ≈ 0 | MMKV ↔ AsyncStorage |
| **Migrate gradually** | Touch only *new* code → blast radius contained, existing code stays familiar | React 19 without memo hooks, applied to new files and feature updates; testing, starting with unit tests only |
| **Wait** | Ecosystem not ready → **turn it off immediately, don't try to fix it** | New Arch on release: libraries didn't support it, so he disabled it rather than sinking effort |

Two things make this better than a threshold rule:

- **Readability is protected structurally, not by restraint.** Route 2 leaves
  old code untouched; route 3 never leaves a half-migrated mess behind.
- **Route 3 is the behaviourally hard one** — *"I turn it off immediately
  rather than try to fix it."* That is escaping the sunk-cost trap after
  already upgrading, which most engineers fail. This is the part ten years
  buys; the principles themselves can be read anywhere.

Structural echo: route 3 is [[wiki/shepherd-review-gates]]'s
`ReversibilityLevel` — keep the operation `AUTO`-reversible and revert without
ceremony. He reached it through cost; Shepherd reached it through
architecture.

## Related

- [[wiki/rule-of-three]] — his "three repetitions justify a tool" is the same
  principle he applies to components and to knowledge.
- [[wiki/ring-2-encoding-the-craft]] — turning this hypothesis into verified
  skill content.
- [[wiki/transcript-mining]] — where the descriptive claims get checked.
- [[wiki/how-i-want-to-think]] — the thinking-level counterpart; principle 1
  ("thinking over tools") is its craft-level statement.
- [[wiki/shepherd-review-gates]] — reversibility as a first-class property.
