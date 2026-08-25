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

**Language:** he thinks and talks in Vietnamese — **converse with him in
Vietnamese**. Wiki content is written in English with Vietnamese glosses
(see `CLAUDE.md`). Don't confuse the two: the conversation and the artifact
have different language rules.

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
7. **The brain now covers his personal life, not just work** (2026-08-22). He
   brought in his marriage and self-assessment and said *"cứ ghi thoải mái"*
   (write freely) when I asked before filing. Treat that as scope, not as a
   standing licence: **ask before filing anything about his family**, keep
   third parties (wife, child) described factually from what he reported —
   no speculation about their motives or character — and write these pages as
   thinking artifacts, not as a record of someone's distress.
8. **NEVER use the epistemic moves to dissolve a verified event.** Added
   2026-08-22 after the trust-breach disclosure. The moves (fact-hay-đoán,
   quantifier check, arrow direction) exist to stop him concluding past his
   evidence — pointed the other way they become a rationalisation engine for
   real harm he caused. Target the **inference** ("therefore I am tệ bạc"),
   never the **event** ("on that day I did Y"). Tell: if applying a move makes
   a specific thing that happened get smaller or vaguer, it is being used
   backwards. Equally: don't swing to moralising — he came for help, not a
   verdict. See the Boundary section of [[wiki/trust-repair]].
9. **On life problems, the practice card applies, but the care comes first.**
   The sharp-metacognition mandate (#3) still holds — he explicitly wanted the
   chain taken apart — but acknowledge the weight before doing the analysis,
   and never let a clean catch substitute for the practical answer he asked
   for. Where the real move is "go get facts the brain doesn't have"
   (a doctor, a counsellor), say so plainly.

## Operational facts about this repo

- **Branch:** work on `claude/wiki-family-story-file-eh94m9` (current, 2026-08-22;
  previous was `claude/blissful-feynman-gtk8wi`). Never push to `main`.
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
- **LIVE — his family situation (opened 2026-08-22).** Question 1 answered the
  same day: a trust breach ~8 months ago (Zalo chats with ~100 women; then,
  asked directly whether anything else was hidden, he said no — she later found
  hidden porn apps). **[[wiki/trust-repair]] is the operative page**;
  [[wiki/five-guess-chain]] is the reasoning-error record.
  Still open: (2) did the absence of drive *start* at some point — candidate
  date ≈ Dec 2025, testable against his memory. Proposed and awaiting news:
  full one-pass disclosure if anything remains, a medical check-up, couples
  counselling, one week of concrete error logging.
  **When he returns, the highest-value question is whether anything else is
  still unsaid** — a third discovery-by-her would most likely end the marriage.
  Ask gently; do not interrogate. Per agreement #7, ask before filing more.
- **Rule-of-Three watch:** "weakest-link composition" has appeared twice
  (argument strength; reversibility). A third sighting earns its own concept
  page. — *"Guarded entry, unguarded exit" FIRED at three on 2026-08-22
  (SpaceX → sun example → five-guess chain); classified root cause,
  countermeasures now Moves 4b and 5 on the practice card.*
- **Lint is overdue.** Last `lint` line in `log.md` is 2026-07-27 (26 days at
  time of writing) — past the two-week trigger. Flagged to him 2026-08-22; the
  judgment half was not run because the session was about something else.
  Offer it again at the next session start.
- **Calibration ledger** deferred to v0.3 of the claim framework — build when
  ~10+ thinking-move entries have accumulated in `log.md`.
- **Unverified tooling claims** carried forward from the Codez ingest
  (`/goal`, CMA/Outcomes, pricing, benchmark numbers) — re-check before
  relying on any of them.
- **Ring 2 of the three-ring plan** (encode his frontend craft into skill
  files in the *other* repo) hasn't started; Ring 1 (feeding this brain) is
  what we've been doing.

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

## Last session

**2026-07-16** — Closed Q3 and the whole roadmap: stress-tested the human-org
mapping (he rebutted all four seams; integration cost was his finding via 5
Whys), ingested all three architecture docs with epistemic labels, filed the
closing synthesis, ran a language pass giving every Vietnamese quote an
English rendering, and created this file at his request.

**Next:** nothing is blocking. Natural continuations — build one of the five
brain upgrades, start Ring 2, or ingest whatever he brings next.

**2026-08-22** — First personal-life ingest. Asked for a file to write his
family story into; got `sources/2026-08-22-family-story.md` (template, still
empty — the boundary rule sends hand-written material to `sources/`, not
`wiki/`). He then brought the real thing: 10-year marriage, daily arguments,
drifting toward divorce, young child, and a five-layer chain of unverified
guesses concluding *"tôi trẻ con"*. Took the chain apart with his own moves
(Move 4 run on character without verifying layers; Move 3 quantifier
violation), flipped the causal arrow, raised the medical hypothesis, answered
the question about the child with an honest {reported, unsearched} tag.
Rule of Three fired on his core person variable. Filed with his explicit
*"cứ ghi thoải mái"*.

Then, hours later, he disclosed the actual event (see the LIVE thread above)
and said *"hãy lưu vào wiki nếu cần"*. Filed as `trust-breach-disclosure` +
[[wiki/trust-repair]]; revised the morning's page rather than leaving it
standing as if still current. Told him plainly that the second event — the lie
told when she offered the repair path — is the load-bearing one, that "how do
I prove it" is a continuation of the same pattern, and that the one instrument
he still has is being askable indefinitely without resentment.

**Next:** whether anything else is still unsaid, and his answer to open
question 2. Do not push — reps are user-initiated (#1), and this is his life,
not an exercise. He is carrying shame plus the demoralisation cluster; keep
the medical check-up on the table without nagging.

**2026-07-27** — Thức reported the weekly lint wasn't working. Confirmed by
evidence that it never fired at all (see the routine entry above). Wrote
`scripts/lint.sh` (mechanical checks: links, index coverage, frontmatter,
orphans, fact-tag TTL, quantifier widening, log parseability, disputed
ledger) with a `<!-- lint-ok: quantifier -->` escape hatch, ran it — wiki is
clean. **Open decision for him:** how to schedule it (re-create the routine,
or a GitHub Action running the script on a cron).
