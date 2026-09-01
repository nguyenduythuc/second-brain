---
title: Self-Improving Agent Systems (Codez article)
type: concept
created: 2026-07-16
updated: 2026-07-16
sources: [sources/2026-07-16-codez-self-improving-agent-system.md]
---

# Self-Improving Agent Systems

First of three architecture documents ingested under Question 3 of the
[[wiki/thinking-roadmap]]. It patches **seam 4** of
[[wiki/human-org-ai-mapping]]: loops have no stopping instinct, so
stop-conditions must be built.

Ingested with the [[wiki/fact-vs-opinion]] kit — each claim labeled rather
than swallowed, which is exactly the failure Thức feared when queueing these
docs — *"biết đâu ta đóng khung opinion thành fact"* (what if we frame an
opinion as a fact).

## Source trust

A content creator's article (Codez, ~2.9M views), self-described as sourced
from Anthropic engineering posts but **not independently cross-checked**
{reported}. The author flags his own uncertain claims — a good sign, and the
document's own ⚠️ markers are preserved. Treat architecture claims and tooling
claims differently; they have different epistemic status (below).

## The load-bearing claim

> **Self-improvement is a property of the SYSTEM, not the MODEL.**

{inference — follows from a verified premise} The premise is solid: production
models are stateless, weights don't update between sessions {fact ✓2026-07-16
slow; direct knowledge of how deployed LLMs work}. What compounds is the
*environment*: state files, skills, eval loops, memory. Each run leaves a
trace; the next run inherits it.

This is the same claim as [[wiki/llm-wiki-pattern]]'s "compile, don't
retrieve" and this brain's own existence — arrived at from a different
direction. **Third independent appearance of the pattern "the artifact
outside the model is what accumulates"** → per rule 7, the why: it recurs
because statelessness is a *structural* property of current LLMs, not a
temporary gap. Root cause, not coincidence. Worth the concept page.

Critical distinction the article draws {fact ✓2026-07-16 medium; definitional,
matches common usage}:

| | Definition | Status |
|---|---|---|
| **Self-learning** | Agent updates its own weights | Doesn't exist in any production model today |
| **Self-improving** | The scaffolding around the agent compounds | Buildable now with existing tooling |

## The compound stack (4 layers)

{inference — a useful organizing frame, not a measured architecture}

1. **Primitives** — model, sub-agents, worktrees, tools. *"Most people stop
   here."*
2. **Orchestration** — goal-driven self-correcting loops, dynamic workflows,
   scheduled runs.
3. **Memory** — state files, skills, lessons → tomorrow's session *resumes*
   instead of *restarts*.
4. **Self-improvement** — the agent grades its own output, refines skills,
   writes lessons back down to layer 3.

The value of the frame: it says **where you are** and **what's next**, which
is why the article's closing advice is "add one layer you don't have yet."

## Mechanisms worth keeping

### Verifier sub-agent > self-critique

{hypothesis — reported as an empirical finding by the Claude Code team; we
have one direct supporting run of our own}

The mechanism is structural, not effort-based: a model grading its own output
sees its own reasoning trail and is biased toward conclusions consistent with
what it already wrote. A separate verifier sees only **artifact + rubric** —
"no skin in the maker's game."

We tested this ourselves (2026-07-16): a cold verifier attacking the v0.2
framework found 4 holes the self-pass had missed — while *aimed by* the
self-pass's attack directions. So our own conclusion is the **composed** form,
recorded as rule 6 in [[wiki/fact-vs-opinion]]: self-critique generates
direction, the cold verifier executes. The article's absolute framing
("verifier > self-critique") is {too strong}; the conditional form survives.

Supporting evidence offered — the "Parameter Golf" experiment, ~6× more
improvement with an independent verifier {reported ⚠️ — no primary source
located; numbers not verified}.

### The 5-stage memory progression

{inference — a rubric, useful whether or not the benchmark behind it is real}

```
FAIL → INVESTIGATE → VERIFY → DISTILL → CONSULT
```

Recorded a failure with enough detail to be useful later → found out *why* →
turned the diagnosis into a **verified fact** → turned it into a **general
rule** → the next task **reads the rule instead of re-deriving it**.

Two things make this valuable beyond the benchmark claims:

- **It is a rubric for grading your own memory system.** If a state file is
  all uninvestigated failure notes, the system is stuck at stage 1 no matter
  which model runs it.
- **Thức derived stages 1–4 independently** during the Q3 stress test:
  *"agent không thể chỉ nhớ, nó còn phải tự học, tự rút kinh nghiệm, tự
  retro… lặp đi lặp lại rồi đưa ra được action"* (an agent cannot merely
  remember — it must self-learn, draw lessons, run its own retro, repeatedly,
  until it produces an action) — before reading the doc.
  {Second independent derivation of the same structure — one more and rule 7
  fires.}
- It is [[wiki/metacognition]]'s regulation cycle installed in a machine:
  investigate = monitoring, distill = evaluating, consult = planning.

The measured stage-by-model table {reported ⚠️ — "Continual Learning Bench
1.0" unverified; treat the numbers as illustration, the stages as the idea}.

### Two operating rules that decide whether memory compounds

{normative-pragmatic, revisited 2026-07} — and the most portable part of the
document:

1. **Write before walking away** — every session ends by updating state.
2. **Read at session start** — every session begins by reading it.

Without both, you get "stage-1 memory behavior regardless of model." This
brain already implements both structurally: `/ingest` writes, `index.md` +
`CLAUDE.md` are read at session start.

### Skills as procedural memory, with their own eval suite

{inference} Scope split: **state file = project memory** (dies with the
project); **skills = procedural memory** ("how to do this kind of work",
travels with the person across projects). The contract: after any non-trivial
failure, write the lesson **into the skill**, not just into chat.

The sharp bit: **a skill has its own eval suite** — the loop verifies not just
the code but *the skill itself*, and a new lesson is only added after a
verifier confirms it. That is a review gate against writing garbage into
memory — the same instinct as this brain's lint.

### Cost routing

{normative-pragmatic} Route by task complexity — orchestrator model for
planning and distillation, cheap models for volume work and grading. "Using
the most expensive model on tasks a cheap one handles" is listed as a common
mistake. Note the cheap-grader point interacts with the verifier claim: an
independent verifier can be a *cheaper* model, because independence — not
capability — is what it contributes.

## Tooling claims — verification status

The article's architecture survives independently of its tooling claims. The
tooling claims split cleanly:

**Confirmed from this environment** {fact ✓2026-09-01 fast; method: direct
observation of the tools available in this session — not documentation.
Re-verified 2026-09-01 after the stale-scan expired the 2026-07-16 check; all
three still present}:

- Dynamic Workflows with `agent()`, `parallel()`, `pipeline()` primitives —
  exists.
- `isolation: worktree` for subagents — exists.
- Scheduled cloud runs ("Routines") — exists; this brain's weekly lint was
  scheduled that way on 2026-07-08.

**Not verified** {reported ⚠️ — carried forward as open}: the `/goal` command
and its syntax; Claude Managed Agents / "Outcomes"; Fable 5 pricing and launch
details; Parameter Golf and Continual Learning Bench numbers; classifier
domains and auto-fallback behavior; data-retention terms.

**The rule that makes this separation matter**, stated by the article itself
and endorsed here: *the architecture (independent verifier, staged memory,
state file, compounding skills, worktree isolation) can be built today with
plain files and git; the branded tooling needs checking before you depend on
it.* Architecture claims decay `slow`; product claims decay `fast`.

## What this changes for Thức's pipeline

The article maps its stack onto Thức's existing Clarify → Spec → Plan → Tasks
→ Implement pipeline and identifies the same gap he had already named: a
**post-task feedback loop** where the agent proposes skill-file updates,
gated by his review. Its proposed build order (state file first, then feedback
loop, then a separate verifier for Implement, then skill eval suites) is
{normative-pragmatic} but sequenced by leverage, and consistent with Ring 2 of
[[wiki/agent-org-multiplied-self]].

The queue holds: Hermes next (how the feedback loop is actually implemented),
then Shepherd (how to gate it safely).

## Related

- [[wiki/human-org-ai-mapping]] — the seam this patches; also the prediction
  that agent orgs re-invent coordination structure.
- [[wiki/fact-vs-opinion]] — the labeling kit used here; rule 6 (compose
  verifiers) came from testing this document's central claim on ourselves.
- [[wiki/metacognition]] — the 5-stage progression is machine-installed
  regulation.
- [[wiki/llm-wiki-pattern]] — same core claim, different route: the artifact
  outside the model is what compounds.
- [[wiki/agent-org-multiplied-self]] — encode/verify/retro; this is the
  engineering of retro.
