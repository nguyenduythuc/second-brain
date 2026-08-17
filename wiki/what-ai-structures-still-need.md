---
title: What AI Structures Still Need
type: synthesis
created: 2026-07-16
updated: 2026-07-16
sources: [sources/2026-07-16-q3-org-mapping-stress-test.md, sources/2026-07-16-codez-self-improving-agent-system.md, sources/2026-07-16-hermes-self-improvement.md, sources/2026-07-16-shepherd-architecture.md]
---

# What AI Structures Still Need

Closing synthesis of Question 3 on the [[wiki/thinking-roadmap]], drawn from
four seams in [[wiki/human-org-ai-mapping]] and the three architecture
documents ingested against them.

## Where the field stands

The three documents are not competitors — they are three organs of one body,
and each was built by people who hit a specific wall:

| Document | The wall it hit | Its answer |
|---|---|---|
| [[wiki/self-improving-agent-systems]] | Sessions produce nothing that lasts | Compound the scaffolding, not the model |
| [[wiki/hermes-self-improvement-loop]] | The agent forgets, then flatters itself | Signal-based retro, patches, provenance — plus a human gate because the automatic tier self-congratulates |
| [[wiki/shepherd-review-gates]] | You cannot trust what you cannot contain | Authority in the signature, syscall jail, propose-don't-apply, computed reversibility |

Composed: **an agent that learns from each session, inside a cage that makes
its mistakes cheap, with a human deciding what gets kept.** That is the state
of the art as of mid-2026 {inference from three sources, not a survey}.

## Five things still missing

Derived by asking what the four seams demand that none of the three documents
supplies.

### 1. Integration cost has no engineering answer yet

The deepest finding of Q3 — Thức's, via 5 Whys — is that **leadership exists
to bridge gaps between specializations**, not to manage people, so
**integration cost survives the switch from humans to agents**. Specialized
agents still leave gaps: the backend agent doesn't know the mobile agent's
constraints; A emits an artifact B misreads.

All three documents optimize the *individual* agent (its memory, its skills,
its containment). None addresses **the interface between agents**. There is no
equivalent of a shared spec, a contract test, or a design review *between two
agents* — the orchestrator is expected to absorb it all, which is exactly the
bottleneck human orgs invented middle management to relieve.

Prediction, restated from [[wiki/human-org-ai-mapping]] {hypothesis, 2026-07}:
**the next real advance is inter-agent contracts** — typed interfaces between
specialized agents, so an artifact's meaning is enforced rather than hoped for.
Shepherd already has the primitive (typed effect boundary); nobody has pointed
it *between two agents* yet.

**Sighting 2026-08-17 — the prediction half-landed, and half-confirmed the gap
instead.** The graph-engineering write-up
(`sources/2026-08-17-graph-engineering-kopadze.md`) carries a **node contract**:
one bounded job, defined input, defined output, *schema enforced — free text is
rejected and retried*. That is the typed interface this gap asked for, one
month after the prediction was written {reported: one practitioner article, not
a survey; the brain did not verify its tooling claims}.

But look at *where* the contract is enforced: by the **orchestrating script**,
not negotiated between the two agents — the reduce step is plain code. So the
orchestrator still absorbs the integration cost, which is exactly what this gap
identifies as the bottleneck. **The graph pattern hardens the orchestrator role
rather than removing it** {inference}. Gap 1 stands; what changed is that the
*primitive* now exists in practice, so the open question is narrower: who holds
the contract.

### 2. Honest self-assessment is unsolved, only routed around

Hermes admits it: the agent almost always believes it did well. The fixes on
offer are all *external* — a cold verifier, execution traces, constraint gates,
a human at the end. Useful, but every one of them costs an extra pass.

In [[wiki/metacognition]] terms: the field has built **Component A**
(metacognitive knowledge — state files, skills) and the **evaluating** phase
of Component B, but **in-flight monitoring (B2) remains absent in machines
exactly as it is hardest in humans.** An agent cannot yet notice mid-task that
its own reasoning has gone wrong; it can only be told afterward by something
else. Whether B2 is even achievable inside one model, or is structurally an
outside job, is open — and it is the same question Thức is training on
himself.

### 3. Decomposition depth has no stopping rule

Thức's correction to seam 4 stands: closed goals decompose into sub-goals, each
a sprint with an explicit stop-condition, so tirelessness is not the problem it
first appears. But **the decomposition itself needs a stopping rule** — humans
stop splitting when it starts to feel absurd, and that signal is exactly what
a tireless agent lacks. No document addresses when a plan is decomposed
*enough*. Recursion without a base case is a known failure mode in every other
field of engineering; here it is unnamed.

### 4. Memory is timeless, and therefore rots

Every memory design ingested treats a stored fact as durable. None carries a
**decay class or a re-verification rule** — the exact failure this brain hit
when the agent asserted "SpaceX is private" a month after the IPO
([[wiki/metacognition]], case study 2). Hermes ages *skills* by usage
(active → stale → archived), which is a proxy for relevance, not for truth.

What is missing is [[wiki/fact-vs-opinion]]'s status axis applied to machine
memory: **a fact needs a timestamp, a method, and a TTL, or it silently
becomes a lie.** A memory system that cannot expire an entry will confidently
serve stale facts forever — and the more familiar the fact, the less likely
anything re-checks it.

### 5. Graduated enforcement, not a single regime

Shepherd enforces hard at the syscall; Hermes gates offline via PR; Codez
relies on prompts and loops. Each picks one regime and applies it broadly.
The mature design is **graduated by blast radius**: hard invariants where an
effect is irreversible (`NONE`), lightweight guidelines where it is `AUTO`.
Shepherd's own ReversibilityLevel is the mechanism that would make this
possible — the system knows which regime each operation belongs in — but no
one has wired it to *variable* enforcement strength.

**Partial answer found 2026-07-27:** Thức's monorepo runs a **ratchet** —
old debt is listed in baseline files and does not block the build, new drift
does; some checks run only at the release gate, not on the development branch.
See [[wiki/ratchet]]. It grades strictness by *origin and timing* rather than
by blast radius, so the two axes compose. The gap now reads: nobody has
applied either axis to an agent system.

## The through-line

Human organizations solved these five with soft, expensive machinery: middle
managers for integration, culture and psychological safety for honest
self-report, judgment for when to stop planning, gossip and re-verification for
stale facts, and graduated trust earned over a career. **Agent systems are
re-deriving each one in hard, cheap form — and they are further along on
containment than on coordination.**

Which suggests the general prediction {hypothesis, 2026-07}: **the bottleneck
moves from "can the agent do the task" to "can two agents agree on what was
done."** Verification, then coordination.

## What this brain should upgrade (recorded, not yet built)

Collected from the three ingests, ordered by leverage:

1. **Decay classes are declared but not yet applied** to existing pages —
   `{fact ✓date decay}` tags exist in the schema; most legacy claims are
   untagged. Lint has the rule; the retrofit hasn't run.
2. **Growth limit** (from Hermes): nothing stops a page bloating each ingest.
   A `max_growth vs. baseline` check is the cheapest missing gate.
3. **Reversible lifecycle for pages** (from Hermes): lint reports orphans but
   no page ever ages to stale/archived; nothing is ever recoverably retired.
4. **Trace-based reflection** (from Hermes + Shepherd): `log.md` records *what
   was decided*, not the reasoning that produced it. Honest retro needs the
   trail, not the verdict.
5. **Declared blast radius per operation** (from Shepherd): no operation
   states which files it may touch before running, and nothing *proves* a
   safeguard ran — lint asserts, it doesn't demonstrate.

## Related

- [[wiki/human-org-ai-mapping]] — the four seams this answers.
- [[wiki/self-improving-agent-systems]], [[wiki/hermes-self-improvement-loop]],
  [[wiki/shepherd-review-gates]] — the three organs.
- [[wiki/agent-org-multiplied-self]] — encode/verify/retro; gap 2 is why the
  verify half stays human.
- [[wiki/metacognition]] — gap 2 restated: B2 is missing in machines too.
- [[wiki/fact-vs-opinion]] — gap 4 is this brain's status axis, absent
  elsewhere.
