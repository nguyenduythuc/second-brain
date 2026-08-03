---
title: Craft Philosophy — how Thức engineers
type: synthesis
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-27-craft-philosophy-self-report.md, sources/2026-07-27-lfvn-coding-convention.md]
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

## Two practices visible in the real convention doc

These come from his maintained LFVN convention page, not from memory — so they
are {fact ✓2026-07-27 medium; method: read the artifact} rather than
self-report.

### The 4-tier review gate

| Tier | Who | Cost | Catches |
|---|---|---|---|
| 1 | ESLint | seconds, pre-commit | banned imports, platform-specific globals |
| 2 | CI scripts | seconds, pre-merge | i18n key drift, persist blacklist mismatch, route/enum mismatch, leftover mocks |
| 3 | AI review | minutes | wrong layer, impure util, missing co-located test |
| 4 | **Human** | expensive | **business logic / BRD only** |

His stated reason: *cost of a bug rises the further it travels from where it
was created*, and independent layers beat one layer (defence in depth). Each
tier is cheaper than the next, so it goes first.

**This is the same conclusion Hermes and Shepherd reached** — automated gates
exist to protect scarce human attention, so the human reviews judgment and
nothing else. He built it independently, from cost pressure rather than
architecture. It is "be the bottleneck" implemented correctly: the human is
the *last* gate, not the *only* gate.

### Document a change so it can be undone

> *"Khi gặp một sự thay đổi, tôi luôn document lại, làm sao để sau này dễ
> recover, truy vết lịch sử."*

The convention doc's temporarily-disabled-security section is the example of
the shape (the security content itself is out of scope): what changed, why,
when, a step-by-step restore checklist, and a gate that blocks release until
the checklist is done.

The important part: that change is **not** mechanically reversible — `git
revert` cannot undo edits spread across six files, `Info.plist` and
`package.json`. So he **manufactures** reversibility by writing the recovery
procedure at the moment of the change, while the details are still in his
head. In [[wiki/shepherd-review-gates]] terms, he converts a hard-to-undo
change into a `COMPENSABLE` one by writing the compensation action down.

*Anh tạo ra khả năng quay đầu cho những thay đổi vốn không tự quay đầu được.*

## Related

- [[wiki/ratchet]] — how old debt is handled without blocking new work.
- [[wiki/rule-of-three]] — his "three repetitions justify a tool" is the same
  principle he applies to components and to knowledge.
- [[wiki/ring-2-encoding-the-craft]] — turning this hypothesis into verified
  skill content.
- [[wiki/transcript-mining]] — where the descriptive claims get checked.
- [[wiki/how-i-want-to-think]] — the thinking-level counterpart; principle 1
  ("thinking over tools") is its craft-level statement.
- [[wiki/shepherd-review-gates]] — reversibility as a first-class property.
