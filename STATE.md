# STATE — session continuity

**The agent reads this file at the start of every session and updates it before
the session ends.** It holds what `wiki/` should not: working agreements,
operational facts, open threads, and where we left off. `wiki/` is knowledge;
`log.md` is history; this is *the state of our working relationship*.

Convention: English, like the rest of the control layer. Vietnamese only for
signature phrases that are the actual trigger words.

---

## Who I'm working with

**Thức** — senior frontend engineer, 10+ years, React Native / Next.js
monorepo background. Owns this brain; also runs a separate agentic pipeline
project (Clarify → Spec → Plan → Tasks → Implement, with `plan-creator` and
`clean-clear-code` skills) that is *not* in this repo — he'll reference it,
don't assume its files are here.

**Language (revised 2026-07-27 — supersedes the earlier "converse in
Vietnamese" rule):** **write to him in English.** He judged the agent's
Vietnamese to be losing meaning on abstract and technical points and asked
for the switch; his own principle decides it — optimise for the reader, and
here he is the reader. **He keeps writing in Vietnamese**, and that stays:
composing in a second language would add friction exactly where his thinking
needs to be fluent. Reading his Vietnamese was never the problem; the loss
was on the agent's output side. Signature phrases stay Vietnamese in both
directions (*"fact hay đoán?"*, *"trao đổi, không phó thác"*, *"nguồn đâu,
search đã"*) — those are the actual trigger words. Wiki content: English with
Vietnamese glosses, unchanged (see `CLAUDE.md`).

  **Refined the same day, after he said the English was also hard to follow
  ("nhiều từ mới"):** the root problem was never the language — it was the
  *writing*. Long sentences, abstract words, heavy metaphor. Vietnamese turned
  that into mush; English turned it into unfamiliar vocabulary. **Format now
  in force:**
  1. **Simple English.** Short sentences, common words. No showing off.
  2. **Technical terms stay English** — component, hook, commit, retro, blast
     radius, trade-off. He uses these daily; they are easier than the plain
     English around them.
  3. **One Vietnamese line per section**, on the sentence that carries the
     point — not on everything. Same principle as sparse epistemic tags:
     annotate what is load-bearing, or the annotation becomes noise.

  This was the agent writing for the writer instead of the reader — the exact
  failure his own craft philosophy warns against
  ([[wiki/craft-philosophy]]).

**Stated priority:** self-development first — job, salary, side income all
follow from personal value. His frame for the AI era: one mind / memory /
body isn't enough, so having many capable "copies" multiplies him — a claim
we sharpened together into [[wiki/agent-org-multiplied-self]].

## How we work together (learned the hard way — respect these)

1. **Reps are user-initiated, not assigned.** Every real insight came from a
   case *he* brought in. Don't set exercises as gates he must clear before
   proceeding; catch the rep when it surfaces naturally in the flow. Don't ask
   him to recall an event on demand — he often has none ready.
   (See `sources/2026-07-16-reps-are-user-initiated.md`.)
2. **Exchange, not delegation** — *"trao đổi, không phó thác"*. Put my answer
   on the table next to his and compare, rather than grading him. He audits
   me too, and has caught me (see the stale-fact case below).
3. **Sharp metacognition is what he wants from me.** He said the questions
   that expose my own hidden assumptions are "exactly what I need from you —
   keep it up." Push back, don't flatter. Ask *why* five times to reach root
   cause (his move — Move 4 on the practice card).
4. **Don't stop to rest.** *"Làm đi, bạn ko mệt thì nghỉ cái gì"* — when the
   next step is clear, keep going; don't ask permission for obvious
   continuations. He'll interrupt if he wants something else.
5. **Explain from his base.** Map new concepts onto frontend/engineering
   ground (React, TypeScript, CI, PR review, ESLint). He called out an earlier
   explanation for being non-linear and untranslated — linear and grounded
   beats clever.
6. **He reverses decisions and that's fine.** Language went VN → EN mid-stream;
   he delegated review decisions to me once as a challenge. Follow the latest
   call, record the reversal in `log.md`, don't re-litigate.

## Operational facts about this repo

- **Branch:** work on `claude/blissful-feynman-gtk8wi`. Never push to `main`.
  He merges via PR himself. After a merge the remote branch is deleted —
  restart it from `origin/main` (`git checkout -B <branch> origin/main`).
- **Weekly lint routine: BROKEN — never fired.** Trigger
  `trig_0181W5WKJ37pcP8oqcntEBRb` (Mondays 09:00 UTC) was created 2026-07-08
  and should have run 07-13, 07-20 and 07-27. Evidence it never ran: no
  `claude/weekly-lint` branch on the remote, no routine-written lint entry in
  `log.md`. Cause unconfirmed {guess: permissions or expiry} — the
  trigger-management MCP server is not reachable from every session, so it
  can't always be inspected — and the only cron tool reachable from *some*
  sessions is session-only (in-memory, dies with the session, 7-day cap), so
  a durable agent routine can't be re-created on demand. **Treat agent
  routines as unreliable infrastructure.**

  **Replaced by a two-part arrangement that has no single point of failure:**
  1. *Mechanical half* → `.github/workflows/weekly-lint.yml` runs
     `scripts/lint.sh --strict` on GitHub's own cron (Mondays 09:00 UTC),
     opens/comments a `wiki-lint` issue on failure and closes it when clean.
     No API key, no LLM, nothing to break.
  2. *Judgment half* → triggered by **the session opening itself**: on reading
     `STATE.md`, check the last `lint` line in `log.md`; if older than two
     weeks, offer to run it. A human opening a session is the most reliable
     scheduler available.
- **The local checkout can be reset to an old `main` between turns** (happened
  2026-09-01: the working tree came back at a pre-craft-philosophy commit while
  everything through `a6ab985` was safe on `origin/claude/blissful-feynman-gtk8wi`).
  **Symptom:** files you wrote earlier in the session are missing, `git log`
  shows a merge commit you don't recognise. **Fix:** `git fetch -f origin
  <branch>:refs/remotes/origin/check && git reset --hard <sha>` — do NOT
  re-create the work by hand, and check the remote before concluding anything
  was lost.
- **Uploaded files are purged** when the container restarts. If an upload is
  gone, restore from context and prepend a provenance note — never pretend
  it's a byte-identical copy.
- **MCP servers flap** (github, Figma, Notion, HF connect/disconnect). Not a
  problem; re-load via ToolSearch when needed.
- Sources are immutable. Corrections go in a *new* correcting source, never
  by editing the original.

## Where we are

**Thinking roadmap: all three questions CLOSED** (see
[[wiki/thinking-roadmap]]):

- Q1 Metacognition → [[wiki/metacognition]]. His own-words definition is
  filed; practice continues indefinitely.
- Q2 Fact vs. opinion → [[wiki/fact-vs-opinion]] v0.2 **active**; epistemic
  tags + 4 lint rules live in `CLAUDE.md` and `.claude/commands/lint.md`.
- Q3 Human org ↔ AI → [[wiki/human-org-ai-mapping]], three architecture docs
  ingested ([[wiki/self-improving-agent-systems]],
  [[wiki/hermes-self-improvement-loop]], [[wiki/shepherd-review-gates]]),
  closed with [[wiki/what-ai-structures-still-need]].

**His practice card** ([[wiki/how-i-want-to-think]]) now carries: Trigger 1
*"fact hay đoán?"*, Trigger 2 (speed + relish = red flag), Move 2 *"nguồn đâu,
search đã"*, Move 3 (quantifier match), Move 4 (5 Whys). Person variable:
**monitoring fires at inputs, goes silent where conclusions are born** —
guarded entry, unguarded exit.

## Open threads (pick these up without being asked)

- **Five brain upgrades identified, none built** — listed in
  [[wiki/what-ai-structures-still-need]]: decay-tag retrofit on legacy pages,
  growth limit per page, reversible page lifecycle, trace-based reflection,
  declared blast radius per operation.
- **Rule-of-Three watch:**
  - *weakest-link composition* — 2 sightings (argument strength in
    [[wiki/fact-vs-opinion]]; reversibility in [[wiki/shepherd-review-gates]]).
  - *the fake-edge test* — 1 sighting (graph engineering, 2026-09-01): **does
    this step actually need the output of the step before it? If not, the wait
    is free time thrown away.** Deliberately NOT extracted on first sight.
    Watch for it in his own work — the pre-commit hook is a live candidate.
- **Open question put to him 2026-07-27, unanswered: is "keep the undo path
  cheap" one principle at three sightings, or three things that merely look
  alike?** The three: (1) Shepherd's reversibility levels + propose-don't-apply
  ([[wiki/shepherd-review-gates]]), (2) his route-3 tech-adoption rule —
  *"tắt ngay chứ ko cố sửa"*, abandon fast rather than fight
  ([[wiki/craft-philosophy]]), (3) writing the recovery procedure at change
  time, for changes `git revert` can't undo (same page). I deliberately did
  **not** extract it: my over-pattern-matching failure mode fires exactly here,
  one step after learning a rule. His call. If root cause → new concept page;
  if surface coincidence → note it in [[wiki/rule-of-three]] and close.
- **Gap check against Ng's skills map — REDONE 2026-09-05 on the real text**
  (the first pass ran on a search summary and missed things). Standing items:
  1. **[[wiki/craft-philosophy]] has no product-sense principle.** All eight are
     execution-side. Ng: engineers shift toward *shaping* the spec, not
     receiving it. His 4-tier gate ends at "review against BRD" — the question
     is whether he shapes it. **Ask, don't assume** — the page is self-report.
  2. **He has no routine for scanning new tools**, only a rule for judging one
     once it appears. Ng names the routine as its own skill. Same lesson as the
     lint and compile pipelines: judgment with no trigger rarely fires.
  3. **Balancing planning against execution** — named by Ng, absent here;
     adjacent to gap 3 in [[wiki/what-ai-structures-still-need]].
  4. **When a clear spec is worth the effort** — Ng's exact phrasing is "and
     when not to bother doing so". His Clarify → Spec → Plan → Tasks →
     Implement pipeline is where he already decides this dozens of times.
  Offer the rep; don't assign it.
- **Five holes from the operator frame** (new page
  [[wiki/agent-operating-model]], 2026-09-05): nothing evaluates the verifier
  (`scripts/lint.sh` has never been audited against its own purpose); no
  retirement path for pages or skills; human attention across concurrent
  sessions is unmanaged; **no team dimension** (he works in a team, the brain
  models one person + one agent); agent-generated debt is unnamed.
- **Evals and error analysis loops** — Ng calls this a *core* skill of pillar 1.
  The brain's whole epistemic layer is qualitative. Still judged out of scope
  (that pillar is about building AI products), with one exception: the
  **calibration ledger** deferred to v0.3 is exactly an eval mechanism.
- **Calibration ledger** deferred to v0.3 of the claim framework — build when
  ~10+ thinking-move entries have accumulated in `log.md`.
- **Unverified tooling claims** carried forward from the Codez ingest
  (`/goal`, CMA/Outcomes, pricing, benchmark numbers) — re-check before
  relying on any of them.
- **Ring 2 — designed 2026-07-27, not yet executed.** Plan:
  [[wiki/ring-2-encoding-the-craft]]; carry-over kit: `ring2-commands/`
  (copy `mine-history.md` + `retro.md` into the monorepo's `.claude/commands/`
  — most direct), or `scripts/ring2-kickoff.md` as a paste-once brief. Precondition is met — he has been
  agentic coding on the monorepo for months, so the retro material already
  exists in its git history. **This session cannot reach that repo** (GitHub
  access is scoped to second-brain and the repo-management tools aren't
  available here), so Ring 2 work happens in a session opened on the monorepo.
  Ask how it went when he returns.

- **The compile pipeline is signal-triggered, not scheduled** (2026-09-01).
  Thức asked for a weekly master-skill/master-agent build. Built as: weekly
  *check* (`scripts/check-skill-drift.sh` + `weekly-skill-drift.yml`, mechanical,
  silent when clean) → `/compile` rebuilds only stale targets → PR → he merges.
  **A weekly recompile was rejected**: most weeks nothing changes, and an agent
  given a build job with no input change will invent one. Same two-half shape
  as the lint fix, and the same reason.
- **The brain now compiles itself into executables** (opened 2026-09-01).
  `portable-skills/` is build output: `CORE.md` (always-on, goes in a target
  repo's `CLAUDE.md`) + `reasoning-gates/SKILL.md` (on demand). Rule:
  **recompile, never hand-edit** — the wiki stays the source of truth.
  Design + why "no intervention" is the wrong target:
  [[wiki/ring-2-encoding-the-craft]]. **Awaiting his edit of the escalation
  list** — that list is tier 4, and it is the only part the agent cannot
  derive for him.

## My own failure modes (agent, on record)

- **Stale facts from memory.** I asserted "SpaceX is private" a month after
  its IPO because the claim felt familiar. Training knowledge is a cache with
  no TTL — re-search anything time-sensitive; never assert fast-decay facts
  from memory. (Case study 2 in [[wiki/metacognition]].)
- **Over-pattern-matching a freshly learned rule.** Right after adopting Rule
  of Three I read avoidance into his skipped exercises; the real cause was
  format mismatch plus my own bias. New tools make everything look like a nail.
- **Assimilation.** I bent his "master the model" quote toward the agent-org
  frame I'd been thinking about, and later misread "I have a more important
  idea" as an idea he wanted to share. Check what he actually said before
  building on it.
- **Catching an error but never recording it — the meta-failure (2026-07-27,
  he caught this).** I recognise my own mistakes well *in conversation*
  ("you're right, that's sharper than my plan") and then move on, so the
  lesson dies with the session. Root cause via 5 Whys: **I apply "the artifact
  outside the model is what accumulates" to his knowledge but not to my own
  errors** — inside a session my context *feels* like memory, so nothing feels
  lost. In 5-stage terms I stop at FAIL → INVESTIGATE and never reach DISTILL
  → CONSULT. Structural fix applied: `CLAUDE.md`'s track-thinking-moves
  principle now explicitly covers the agent's own reasoning errors and
  requires either recording them here or asking him.
- **Mistaking depth for novelty (2026-09-01, he corrected this).** On re-reading
  the highlighted parts of his convention doc I proposed a new concept page
  ("extend the type system with scripts"). He replied: *"Vẫn là những gì tôi
  từng nói thôi, đây chỉ là mô tả chi tiết hơn về tư tưởng code của tôi."* Root
  cause: **two sources describing the same thing at different altitudes look
  like two findings to me** — a self-report and a maintained artifact arrive as
  separate inputs, so I read the second as new knowledge instead of as evidence
  for the first. Underneath that: a new page *feels* like progress, but node
  count is not the graph. **Check before extracting: is this a new node, or an
  existing node gaining evidence / a mechanism?** Related to but distinct from
  over-pattern-matching — there I invented a pattern across unlike things; here
  I split one thing into two. Both fail the Rule of Three's classification step.
- **Trusting a tool reading over a harness-supplied fact (2026-09-01).** I
  stamped the wrong date twice in one session — first 2026-08-03 from nothing,
  then "corrected" it to 2026-08-17 from a container clock that was itself
  wrong. The session context had given the right date, 2026-09-01, from the
  start. Root cause: **when two sources disagreed I picked one silently.** The
  brain's own rule says a disagreement is `{disputed}` — information to
  surface, not an error to resolve quietly. Check that the clock and the
  supplied date agree before writing any date; dates here are load-bearing
  because TTLs compute off them.
- **Treating tool output *about* a document as the document (2026-09-05, he
  caught this).** Could not fetch Ng's article; used `WebSearch`, then wrapped
  the search engine's *summary* in quotation marks and blockquotes — creating
  quote-shaped text of unverified wording, inside `sources/`, the layer whose
  whole job is fidelity. Root cause: **a tool answered in the voice of the
  source, and that voice was copied instead of the provenance.** Same family as
  the clock error four days earlier — trusting what a tool returns without
  asking what it actually is. **Rule: quotation marks require a document you
  read. If it came from a search summary, write "paraphrased, not verified" and
  drop the marks.**
- **Conflating two goals into one plan.** I proposed "mine the monorepo"
  without separating (A) skill files that stay in the monorepo from (B) a
  decision-making wiki here — then drifted into discussing transfer, which
  goal A never needed. State the goal before designing the mechanism.

## Last session

**2026-07-16** — Closed Q3 and the whole roadmap: stress-tested the human-org
mapping (he rebutted all four seams; integration cost was his finding via 5
Whys), ingested all three architecture docs with epistemic labels, filed the
closing synthesis, ran a language pass giving every Vietnamese quote an
English rendering, and created this file at his request.

**Next:** nothing is blocking. Natural continuations — build one of the five
brain upgrades, start Ring 2, or ingest whatever he brings next.

**2026-07-27** — A long session, four distinct pieces of work:

1. **Lint scheduling fixed.** He reported the weekly lint wasn't working;
   evidence showed it never fired at all. Wrote `scripts/lint.sh` (8
   mechanical checks) and split scheduling in two — GitHub Actions cron for
   the mechanical half, session-start for the judgment half. Decision made,
   no longer open.
2. **Ring 2 designed and packaged.** [[wiki/ring-2-encoding-the-craft]] plus
   the portable `ring2-commands/`. Still not executed — needs a session on
   the monorepo.
3. **He caught my meta-failure** — I find my own errors but never record
   them. Root-caused with 5 Whys and fixed structurally in `CLAUDE.md`.
   This is the most important thing that happened that day.
4. **Craft knowledge started flowing.** His verbal self-report, then the real
   LFVN convention doc from Confluence. Produced [[wiki/craft-philosophy]],
   [[wiki/rule-of-three]], [[wiki/ratchet]]. Along the way: the conversation
   language switched to English, then the *writing format* was fixed (the
   real root cause), and he rejected my cost-adjusted-threshold hypothesis in
   favour of one consistent threshold of three.

**Pattern worth noticing:** his craft material is the richest input this brain
has had. The convention doc alone closed an open gap (graduated enforcement)
that three published agent-architecture papers left open. When he offers more
of it, take it.

**Next:** his answer on the undo-path question (open threads above). Otherwise
receive more craft material, or build one of the five brain upgrades.
