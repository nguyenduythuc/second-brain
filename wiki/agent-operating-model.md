---
title: Agent Operating Model — running agents, not just building them
type: synthesis
created: 2026-09-05
updated: 2026-09-05
sources: [sources/2026-09-05-ng-using-coding-agents.md, sources/2026-09-01-graph-engineering-kopadze.md, sources/2026-07-16-hermes-self-improvement.md, sources/2026-07-16-shepherd-architecture.md]
---

# Agent Operating Model

This brain has depth on how agent *systems* are built
([[wiki/self-improving-agent-systems]], [[wiki/hermes-self-improvement-loop]],
[[wiki/shepherd-review-gates]]) and on how *he* engineers
([[wiki/craft-philosophy]]). It had no page on the layer in between: **the
operator's day-to-day workflow.**

Ng's *Using Coding Agents* (2026-09-04) supplies a frame from dozens of
practitioner interviews {fact ✓2026-09-05 medium; method: read the full text}.
This page is a **coverage map** onto it — what the brain already answers, and
where it is empty. It is not a restatement of the article; read the source for
that.

## The workflow

**Plan → Execute → Deploy & monitor**, highly iterative, with steps sometimes
omitted. Ng's own framing: the workflow is *the same as before coding agents*;
what changed is where the effort goes — *"much less on code and instead …
deciding what to build, designing the architecture, writing the spec, and
verifying outputs."*

The step's weight scales with the codebase: a greenfield prototype's spec can
be a quick prompt; a **brownfield project with many users needs much more
effort to write and verify.** His LFVN monorepo is the second kind.

*Quy trình không đổi, chỗ tốn công mới đổi.*

## Coverage map — five skills against what this brain holds

| Ng's skill | Brain coverage | Verdict |
|---|---|---|
| **Directing the workflow** | escalation list; gap 3 (decomposition) | **partial** |
| **Enabling agent autonomy** | Shepherd gating, graph fan-out, `CORE.md` | **partial** |
| **Reviewing the work** | rule 6 cold verifier + 3 lenses; his 4-tier gate | **strong** |
| **Customizing the agent + environment** | `CLAUDE.md`, `STATE.md`, retro loop, compile pipeline | **strongest** |
| **Coding agent foundations** | harness/loop mapping, three architecture pages | **strong** |

Two convergences worth naming. **`STATE.md` is exactly the artifact Ng
describes** — *"preserve state across multiple sessions … accumulate agent
learnings over time, perhaps by running post-run retrospectives."* Built here
in July from Hermes; independently prescribed in September. And **the compile
pipeline** answers *"updating the standing context … with key architectural
assumptions."*

## Five holes this frame exposes

1. **Nothing evaluates the verifier.** *"You have to evaluate the tests to
   ensure they correspond to your aims, and you will evolve them if not."* The
   brain has strong rules for verifying a *claim* and none for checking that a
   *check* still measures what it should. Same problem as the graph article's
   anchors: a system whose checkers are graded by the system is consistent, not
   verified. `scripts/lint.sh` has never been audited against its own purpose.
2. **No retirement path.** *"Occasionally you will prune them when they are no
   longer necessary (such as when a new model obviates an old skill)."* Recorded
   as upgrade 3 in [[wiki/what-ai-structures-still-need]] and never built —
   nothing here ages to stale or archived. Now independently named as a
   required operator skill, which raises its priority.
3. **Human attention across concurrent sessions is unmanaged.** The graph
   ingest covered fanning work out; nobody covered the operator's own attention
   as the scarce resource once it is fanned out.
4. **No team dimension.** *"When you work in a team, you consider how to
   coordinate context across different developers' agents."* This brain models
   one person and one agent. He works in a team on a shared monorepo, so the
   question is live and entirely unaddressed here.
5. **Agent-generated debt is unnamed.** [[wiki/ratchet]] handles debt from the
   past; nothing handles debt an agent creates this week, at volume.

## A candidate answer to an open gap

Gap 3 in [[wiki/what-ai-structures-still-need]] says decomposition has no
stopping rule. Ng's phrasing points at one: *"how to decompose the work into
**verifiable** steps."*

**Stop splitting when each piece can be checked.** {inference — the article
names verifiable steps as the target, it does not state this as a stopping
rule.} That is a real criterion, and it composes with the brain's existing
rules: a step you cannot verify is a step whose output has to be trusted, and
rule 6 says never trust an agent's account of its own work.

## What Ng says about autonomy — and why it matters here

> "the practical utility of very long-horizon tasks — especially relative to
> their cost — has been amplified beyond reality. Instead, most effective
> coding agent use is a complex, highly iterative process, and being able to
> intervene with high-skill judgement gives much better results."

Thức asked (2026-09-01) for a setup where he does not have to intervene. The
agent argued back from four of this brain's own findings; this is a fifth,
external, from practitioner interviews {reported — interviews, not
measurement}. **The target is not less intervention. It is intervention moved
to where judgment is irreducible** — which is what his own 4-tier gate already
does ([[wiki/craft-philosophy]]).

*Không phải bớt can thiệp, mà là can thiệp đúng chỗ.*

## Agent failure modes Ng names

Overengineering a simple solution · losing rigor when there is no explicit
verification step · stopping short of the goal · actions risking destruction of
files or production data.

The first is on this agent's own record in `STATE.md` (over-extraction, twice
in one month, caught by Thức both times) — external confirmation of a
self-recorded failure. The third is not in the brain's list and should be
watched: *stopping short* is invisible from inside the run.

## Related

- [[wiki/what-ai-structures-still-need]] — gap 3 gets a candidate answer; upgrade 3 gets outside support.
- [[wiki/craft-philosophy]] — his 4-tier gate is the "reviewing the work" skill, already built.
- [[wiki/ring-2-encoding-the-craft]] — the compile pipeline is the "customizing the environment" skill.
- [[wiki/hermes-self-improvement-loop]] — post-run retrospectives, provenance, lifecycle.
- [[wiki/shepherd-review-gates]] — permissions and gating for safe autonomy.
- [[wiki/agent-org-multiplied-self]] — why breadth is not judgment.
