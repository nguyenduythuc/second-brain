# Ring 2 kickoff — paste this into a session opened on the monorepo

Self-contained on purpose: a session on the monorepo cannot read this brain,
so everything needed is restated here.

---

## Context for the agent

I'm a senior frontend engineer (10+ yrs, React Native + Next.js monorepo). I've
been doing agentic coding on this repo for months, with a pipeline of
Clarify → Spec → Plan → Tasks → Implement and two skill files (`plan-creator`,
`clean-clear-code`).

Those skills are **static** — written once, never updated. My goal is to make
them *compound*: every task the agent completes should be able to leave one
line of durable knowledge behind, gated by my review.

Do not write skill content from imagination. **Every entry must trace to
something that actually happened in this repo.**

## Task 1 — Mine the history (do this first, it's the highest-yield step)

The knowledge is already in the repo; it just isn't in a file an agent reads.

1. **Read my PR review comments.** Find anything I've said 3 or more times.
   Each recurring comment is a rule I hold but never encoded.
2. **Find `fix:` commits that immediately follow agent-authored commits.**
   Each of those diffs is a recorded gap between the agent's output and my
   standard.
3. **Find commits referencing incidents/hotfixes/rollbacks.** These carry the
   highest value because the cost was paid in real damage.

For each candidate, before extracting, ask **why it recurs** and classify:
- *root cause* → encode it
- *surface coincidence* → skip (a wrong abstraction costs more than duplication)
- *my personal preference* → encode, but label it as preference, not law

Report the candidates to me grouped by theme **before** writing anything.

## Task 2 — Grow the existing skills

For each existing skill, propose additions in these sections:

```markdown
## Known failure modes      # from mined history — what actually broke, and the fix
## Anti-patterns (do NOT)   # from incidents — with the reason, not just the ban
## Escalate to human        # the boundary where the agent must stop and ask
```

Use **small patches, not rewrites**: a rewrite risks breaking what already
works. Validate the file's frontmatter after each patch and keep an undo path.

## Task 3 — Install the compounding loop

Add a post-task retro with these properties:

- **Quantified trigger** — run it after a task with 5+ tool calls, a fixed
  tricky error, or any correction from me. Not "sometimes consider it."
- **Signal-based prompt** — never ask "did I do well?" (the answer is always
  yes). Ask for evidence: *Did he correct my style? my workflow? my sequence?
  Did a loaded skill turn out to be wrong or incomplete?* Treat frustration
  phrases ("stop doing X", "too verbose", "just give me the answer") as
  first-class signals.
- **Propose, don't apply** — output a **diff proposal** for the skill file. I
  review and accept. Never self-merge.
- **Provenance** — skills I wrote by hand may only receive *proposals*, never
  automatic overwrites.

## Task 4 — Blast radius + continuity

- **Blast radius per task:** every task declares which packages it may write
  to; everything else is read-only. This is the mechanical fix for "the task
  on the new app accidentally touched the legacy app."
- **`STATE.md` at the repo root:** verified facts about this codebase, general
  rules distilled from failures, open failures still being investigated, and a
  "last session" pointer. Read it at session start, update it before the
  session ends. Without both halves, every session restarts from zero.

## How I want you to work with me

- Push back. If a proposal is weak, say so — don't flatter.
- Separate what you **verified in the code** from what you're **inferring**.
- Ask *why* several layers down before accepting a first plausible cause.
- Don't stop for permission on obvious next steps.

## Definition of done (4 weeks)

- ≥3 skills carry sections that did not exist at the start, each traceable to
  a real incident or review comment.
- The agent stops repeating at least one class of mistake it used to make.
- My review time per task trends down while acceptance rate holds.
