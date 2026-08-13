---
title: "Fact vs. Opinion — Claim Classification v0.2"
type: concept
domain: thinking
summary: "claim classification v0.2 (ACTIVE): 3 types × 5 statuses, decay classes/TTL, weakest-link & quantifier & rule-of-three rules, epistemic tags + lint mechanism."
created: 2026-07-16
updated: 2026-07-16
schema_version: 2
sources: [sources/2026-07-08-three-big-questions.md, sources/2026-07-16-spacex-ipo-correction.md, sources/2026-07-16-metacognition-own-words.md]
---

# Fact vs. Opinion — Claim Classification v0.2

Deliverable of Question 2 on the [[wiki/thinking-roadmap]]. **STATUS: v0.2
ACTIVE** — Thức delegated the open review decisions to the agent as an
applied-reasoning challenge (2026-07-16); decisions and their justifying
rules are recorded below. v0.1 (a naive fact/opinion binary, then a two-axis
model) died under adversarial review; this version absorbs the five holes the
independent verifier found plus the rules learned from live incidents (SpaceX
IPO, the sun example).

## Why not two bins

Thức's original worry (2026-07-08): without the right frame, we may freeze
architecture *opinions* (Hermes, Shepherd, …) into the brain as if they were
facts, shrinking its growth space. Correct worry — but the fix is not two
storage bins. A claim needs **two independent labels** (what kind of claim it
is; where its verification stands) because the two classic failure modes are
axis-conflations:

- *unchecked → "opinion"* (downgrading checkable claims you haven't checked),
- *familiar → "verified"* (upgrading remembered claims you never re-checked —
  the agent's own SpaceX failure).

## Axis 1 — TYPE (what kind of claim is this?)

| Type | Settled by | Can it expire? | Examples |
|---|---|---|---|
| **Analytic** (khái niệm/logic) | Derivation, definition, consistency — *not* search | Only by redefinition | Math; "the median resists outliers"; this framework's own rules |
| **Descriptive** (mô tả) | Observation/search; truth is **time-indexed** | Yes — facts have TTLs | "SpaceX is private" (true until 2026-06-11) |
| **Normative** (chuẩn tắc) | Argument grounded in values | **Yes** — values and circumstances drift | "I should prioritize salary over learning" |

Notes:
- **Mixed ("thick") claims are the norm, not the edge case** ("this manager is
  manipulative", "unmaintained skills become liabilities"). Don't force one
  label: extract the checkable descriptive core, label it, and label the
  evaluative remainder separately.
- **Phrasing must not decide the label.** "Evidence matters" (sounds
  normative) and "verifier beats self-critique" (sounds empirical) are the
  same claim-shape: *practice X improves outcomes* — both carry a testable
  core plus a value layer. Classify by content, not surface grammar.

## Axis 2 — STATUS (where does its verification stand?)

For descriptive claims (analytic: proven/unproven; normative: argued/contested
+ last-revisited date):

| Status | Meaning |
|---|---|
| **verified** *(date, method, source-trust)* | Checked against sources at a point in time. **Verification itself has a TTL** — see decay classes |
| **unverified — unchecked** | Checkable now, nobody looked yet |
| **unverified — not yet checkable** | Future/predictive; singles can't verify a probability — only a **calibration track record** over many predictions can |
| **disputed** | Trusted sources conflict. This is *information*, not an error — surface it, don't average it |
| **expired** | Verification older than its decay class → auto-demotes to unchecked |

**Decay classes** (the TTL of a verification):

- `slow` (~years): settled science, geography, math-adjacent. Chemosynthetic
  life at hydrothermal vents — safe to assert from memory.
- `medium` (~months): people's roles, tech versions, org structures.
- `fast` (~weeks or less): company status, prices, records, "current best X".
  "SpaceX is private" was fast-decay asserted as if slow-decay — that's the
  whole failure.
- Rule of thumb: **memory is a cache with no TTL warning** — any fast-decay
  claim recalled from memory must be re-searched before use.

## The rules (how claims combine into arguments)

1. **Weakest link:** argument strength = min(status of premises, validity of
   the inference step). Verified premises + overreaching inference = weak
   conclusion. (From the sun example.)
2. **Quantifier match:** the conclusion's quantifier must not exceed the
   premises' — <!-- lint-ok: quantifier -->
   "cho tới giờ" (so far) cannot silently become "luôn" (always).
   Widening is an *inference step*; name it out loud or shrink the claim.
3. **Evidence-terrain claims are claims:** "support for X is rare" is itself a
   descriptive claim — check it before building on it. (Hydrothermal vents
   falsified "life-without-sun support is rare" in one lookup.)
4. **Being accidentally right doesn't upgrade the move** — one outcome can't
   validate a process. But **accumulated outcomes can**: a heuristic that
   keeps winning earns trust (calibration). Process dogma without an update
   rule is as broken as outcome-worship.
5. **Inference requires verified premises.** Reasoning over unverified inputs
   is a guess wearing inference's clothes — label it `guess` until the inputs
   are checked.
6. **Verify by composition:** self-critique first (cheap, context-rich,
   generates attack directions) → cold independent verifier (immune to the
   reasoning chain's anchoring) → merge. Proven in our own run: the cold
   agent found 4 holes the self-pass missed, *while aimed by* the self-pass's
   directions.
7. **Rule of Three for knowledge** (Thức, 2026-07-16 — from React components /
   custom hooks): a pattern appearing for the **3rd time** in
   sources/discussions triggers a **"why does it recur?"** analysis before
   extraction. Classify: *root cause* (one essence in many costumes → extract
   a concept page or a practice-card Move) / *surface coincidence* (note,
   don't extract — wrong abstraction costs more than duplication) /
   *observer bias* (the repetition lives in the observer, not the world →
   record as a person variable). Guards against Hermes's documented failure:
   a flat library of one-off entries extracted without a why.

## Review decisions (2026-07-16, made by the agent on delegation)

Each decision cites the learned rule that justifies it. Epistemic status of
all five: {normative-pragmatic, revisit when evidence accumulates}.

1. **Tag density → load-bearing claims only.** Justification: the cost of
   observation must stay below its value (the rumination lesson, and Hermes's
   progressive disclosure). Tag noise kills the habit; sparse tags survive.
2. **TTL defaults → fast: 30 days · medium: 6 months · slow: 3 years.**
   Concrete numbers so lint can *compute* expiry instead of vibing it. Round
   defaults now, tuned later by track record — process validated by
   accumulated outcomes (rule 4), not designed perfectly upfront (start
   small, LLM-wiki rule IX).
3. **Calibration ledger → deferred to v0.3, accumulation starts now.** The
   ledger is an abstraction over entries we barely have; extracting it today
   is premature abstraction (rule 7's own warning). The log's thinking-move
   lines are the raw table; build the ledger when ~10+ entries exist — the
   Rule of Three applied to the ledger itself.
4. **Thick claims → split-and-label, but only when load-bearing.** Consistent
   with decision 1; in casual flow the default remains the cheap trigger
   ("fact hay đoán?"), not taxonomy paperwork. Weakest link says the split
   matters exactly where an argument stands on the claim.
5. **Rule of Three → adopted as rule 7** and wired into ingest/lint (see
   mechanism). It formalizes the process that already produced Move 3 by
   hand.

## Mechanism for this brain (ACTIVE — CLAUDE.md amended 2026-07-16)

1. **Inline epistemic tags on load-bearing claims only** (not every sentence —
   tag noise kills the habit):
   `{fact ✓2026-07-16 fast}` · `{fact-from-memory slow}` · `{inference}` ·
   `{guess}` · `{hypothesis}` · `{normative, revisited 2026-07}` ·
   `{disputed: A vs B}` · `{reported: source claims, unchecked}`
2. **New lint rules:**
   - *Stale scan:* every `{fact ✓date decay}` older than its decay TTL →
     flag for re-verification, auto-treat as unchecked until then.
   - *Quantifier scan:* absolute quantifiers (always/never/all/luôn/mọi/không
     bao giờ) in wiki claims whose cited support is hedged → flag as illicit
     widening.
   - *Disputed ledger:* list all `{disputed}` tags with both sources — they
     are the brain's most information-dense entries.
3. **Method note on verification:** a `✓` must say how — "3 independent
   outlets" ≠ "one blog" ≠ "from memory". Memory assertions always get
   `{fact-from-memory <decay>}` — never a bare `✓`.

## The original exercise, relabeled under v0.2

| Claim | v0.2 label |
|---|---|
| "SpaceX is private, unlisted" | descriptive, **expired** (was fact until 2026-06-11; fast decay) |
| "Unmaintained skills become liabilities" | thick: descriptive core (testable across projects) + evaluative framing; `{hypothesis}` with anecdotal support |
| "SpaceX stock is doomed" (Thức, instantly) | `{guess}` — inference-shaped, premises unchecked at utterance time |
| "Supporting evidence is very important" | thick: testable core ("evidenced conclusions win more often" — `{hypothesis}`, strong support) + normative layer ("therefore demand it") |
| "Independent verifier beats self-critique" | descriptive, `{reported}` → upgraded to `{hypothesis}` with direct support (our own run), conditional form: *for bias-sensitive hole-finding; compose with self-critique for direction* |

## Related

- [[wiki/metacognition]] — Q1; the monitoring that makes these labels fire in
  real time. Case study 2 is this framework's origin story.
- [[wiki/how-i-want-to-think]] — Moves 1–3 are the human-side runtime of
  these rules.
- [[wiki/llm-wiki-pattern]] — rule VIII (lint the knowledge): the two new
  lint rules extend it.
- [[wiki/thinking-roadmap]] — Q2 status board.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/andrej-karpathy]] · [[wiki/brain-as-data-system]] · [[wiki/domain-map]] · [[wiki/hermes-self-improvement-loop]] · [[wiki/human-org-ai-mapping]] · [[wiki/self-improving-agent-systems]] · [[wiki/shepherd-review-gates]] · [[wiki/thinking-roadmap]] · [[wiki/what-ai-structures-still-need]]
<!-- backlinks:end -->
