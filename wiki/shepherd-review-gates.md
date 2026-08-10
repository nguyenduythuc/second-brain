---
title: "Shepherd — Review Gates as System Invariants"
type: concept
summary: "turning review gates into system invariants: authority in the type signature, syscall jail with fail-closed probe, retained output (propose don't apply), reversibility weakest-link, typed effect boundary."
created: 2026-07-16
updated: 2026-07-16
schema_version: 2
sources: [sources/2026-07-16-shepherd-architecture.md]
---

# Shepherd — Review Gates as System Invariants

Third and last architecture document under Question 3 of the
[[wiki/thinking-roadmap]]. Where [[wiki/hermes-self-improvement-loop]] shows
how an agent *learns*, Shepherd shows how to *contain* what it does — patching
the trust half of **seam 2** in [[wiki/human-org-ai-mapping]].

Its one-line philosophy, from the README: **nothing touches your files until
you accept it.**

## Source trust

Open-source repo (MIT) plus a published paper (arXiv 2605.10913) {reported —
code and paper attributed, not independently pulled by the agent}. Same rule
as Hermes: claims about *what the system does* are high-trust; claims about
*whether this is the right way* remain design opinions, however well argued.

## The central move: enforce, don't ask

Thức's `plan-creator` skill already *asks* the right three questions before
acting — reversibility? verifiability? blast radius? Shepherd's contribution is
turning each into a **runtime invariant the system enforces**, not a discipline
the human must remember. Four layers, ordered from declaration to enforcement:

### 1. Authority lives in the type signature

{fact ✓2026-07-16 medium; source code} A task is a *bodyless function*: its
signature plus docstring is the contract, and write authority is declared **in
the parameter types** — `docs: May[GitRepo, ReadOnly]`, `backend:
May[GitRepo, ReadWrite]`. Reading the signature shows the entire permission
surface; nothing hides in config. And a caller **may never widen** what the
task declared — attempting it raises.

Frontend parallel: `Readonly<T>` props. You can't launder a readonly value
into a mutable one from outside.

### 2. Fail loud on mixed authority

{fact ✓2026-07-16 medium; source code} If one run binds a read-only repo and a
writable one, the system **refuses to collapse them into a single scalar**,
because collapsing either silently *amplifies* the restricted binding or
*downgrades* the granted one. Any consumer still reading a scalar fails
immediately rather than mis-enforcing quietly.

Generalizable: **never average heterogeneous permissions into one value.**
An error at the boundary beats a silent wrong grant.

### 3. Enforcement at the syscall, with a fail-closed probe

{fact ✓2026-07-16 medium; source code} Grants compile into kernel rulesets
(Landlock on Linux, Seatbelt on macOS): an unauthorized write is **denied by
the OS at the moment it happens**, not caught later at a merge gate.

The subtlest and best idea in the document: **a broken jail must never be
mistaken for a strict jail.** Before running the task body, a probe *proves*
the sandbox is (a) live — a write outside the workspace is denied; (b) not
over-tight — every writable root actually accepts writes; (c) deny-closed — a
path inside the workspace but outside every writable root is denied. A
confinement *failure* is distinguished by exit code from a write *denial*.

Stated as a rule: **don't assume your safety mechanism is running — prove it
is running and correct, before you rely on it.** This is the machinery
equivalent of Move 2 ("nguồn đâu, search đã") applied to one's own
infrastructure — verify, don't trust the label.

### 4. Retained output — the agent proposes, never applies

{fact ✓2026-07-16 medium; source code} The agent's work does not land in your
directory. It becomes a **retained output**: readable, runnable, testable —
but not applied. You settle it **exactly once**: `select` (apply), `release`
(consume without applying), or `discard`. The trace records the outcome either
way, including the discards.

Vercel preview deployments, but for every side effect — and mandatory.

Plus the **any-writable rule**: if *every* binding in a run was ReadOnly, then
selecting the whole delta is **refused**. You cannot launder a read-only run
into an applied change. Authority *at run time* determines what may be applied
*at settle time*.

## Reversibility as a first-class, computed property

{fact ✓2026-07-16 medium; source code} Every effect declares its own level:

- `AUTO` — mechanically reversible (git reset, db rollback)
- `COMPENSABLE` — needs a compensating action (send a correction email)
- `NONE` — irreversible (a published tweet, a sent SMS, a query that leaked
  sensitive data)

Composition is **weakest-link**: `AUTO + NONE = NONE`. A ten-step plan
containing one irreversible step *is* an irreversible plan, and the system
computes this rather than asking a human to notice it. The level is surfaced
**in the prompt**, so the agent itself knows when it is touching something
that cannot be undone.

This is the same shape as [[wiki/fact-vs-opinion]] rule 1 (argument strength =
weakest link across premises and inference). **Second independent appearance of
weakest-link composition as a safety principle** — noted for rule 7; one more
and it earns extraction as a general concept.

## Typed effect boundary → auditability and testability at once

{inference from documented design} The task body is a black box (you can't see
the model's reasoning), but **everything crossing the boundary is a typed,
recorded effect** — including the model call itself: request, response, and
validated return value are all inspectable evidence when a run misbehaves.

The payoff nobody expects: **tests run without a real model.** The test
environment answers the model-delivery effect with a canned response; task code
is unchanged. *"Substitution happens at the boundary, not by monkey-patching
the task."*

This is the missing piece under Hermes's admitted weakness: Hermes needed
*execution traces* for honest reflection; Shepherd's design makes such traces
a structural property rather than extra logging.

## The synthesis: the two systems are complements

| Axis | Hermes | Shepherd |
|---|---|---|
| Focus | Self-improvement (skills grow) | Supervision (contain and review) |
| Unit | Skill file | Task = contract + typed effects |
| Automatic safety | Curator: reversible archive, provenance | Syscall jail, fail-closed probe |
| Human in the loop | Offline PR gate (GEPA) | Retained output, settle-once, every run |

Together they answer the two halves of the agent-org problem: **how an agent
learns** and **how you stay safe while it does.** Neither alone is enough —
Hermes without gates self-congratulates; Shepherd without a learning loop never
improves.

## The claim to argue with

The agent's stated position, offered for Thức's rebuttal: **a wiki guideline
loses to a CI check** — human discipline (remember to review, remember to ask
about reversibility) depletes, while a system invariant (sandbox, automatic
gate) never tires and never forgets. Hence Shepherd is the heaviest of the
three documents.

{normative-pragmatic, revisited 2026-07} The counter-case worth holding: hard
enforcement has a cost — it constrains exploration, adds friction to work that
is exploratory by nature, and mis-specified invariants block legitimate work
loudly. The mature position is probably **graduated**: enforce hard where the
blast radius is large and irreversible (`NONE`), rely on guidelines where it is
small and `AUTO`. Which is, note, exactly what the ReversibilityLevel
mechanism enables — the system tells you which regime you are in.

## What this means for this brain

Already present, in weak form: the ingest/review discussion is a settle gate;
`sources/` immutability is a provenance boundary; git history makes most of
this brain's changes `AUTO`-reversible.

Genuinely missing, and worth considering later:

- **Declared blast radius per operation.** Nothing states which files an
  operation may touch before it runs.
- **Proof, not assumption, that a safeguard ran.** Lint asserts checks; nothing
  proves the check actually executed correctly.
- **Reversibility levels on brain operations.** Publishing anything outward
  would be `NONE`; wiki edits are `AUTO`. Currently undifferentiated.

## Related

- [[wiki/hermes-self-improvement-loop]] — the complement; its trace-based
  reflection is what Shepherd's effect boundary would provide structurally.
- [[wiki/self-improving-agent-systems]] — layer 1–2 primitives (worktrees,
  isolation) are the coarse version of this containment.
- [[wiki/human-org-ai-mapping]] — seam 2: agents have no accountability, so
  trust must be structural.
- [[wiki/fact-vs-opinion]] — weakest-link composition appears in both, in
  reasoning and in safety.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/brain-as-data-system]] · [[wiki/human-org-ai-mapping]] · [[wiki/thinking-roadmap]] · [[wiki/what-ai-structures-still-need]]
<!-- backlinks:end -->
