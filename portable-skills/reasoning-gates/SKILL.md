---
name: reasoning-gates
description: Thức's reasoning discipline for research, analysis, and decisions. Use when a task involves gathering information, weighing options, making a judgment call, reviewing someone's argument, or deciding whether to build an abstraction. Triggers on research, investigation, comparison, "should we", "which is better", root-cause analysis, and any answer that will be acted on. Not needed for mechanical edits with a known answer.
---

# Reasoning gates

Compiled from `second-brain` — two months of working out how to think, plus
every reasoning failure both Thức and the agent have been caught making.
These are gates, not advice: run them, don't admire them.

**Language:** simple English. Technical terms stay English. One Vietnamese
line per section, on the sentence that carries the point.

---

## Gate 1 — Classify before you assert

Every load-bearing claim gets a type and a status. Only load-bearing ones —
tagging everything kills the habit.

**Type:**
- **Analytic** — settled by derivation or definition. Searching won't help.
- **Descriptive** — settled by observation. **Truth is time-indexed.**
- **Normative** — settled by argument from values. Values drift; date them.

Most real claims are mixed. Split them: label the checkable core, label the
value layer separately.

**Status:** verified *(date + method)* · unchecked · not-yet-checkable ·
disputed · expired.

**Decay** — how long a verification lasts:
`fast` 30 days (company status, prices, "current best X") · `medium` 6 months
(roles, versions, org structure) · `slow` 3 years (settled science).

**Decay class belongs to the claim's shape, not its subject.** "X is private"
is fast. "X went public on 2026-06-12" is a dated event — it cannot expire.
Test: *can this sentence become false without anything being wrong about it
today?*

*Fact hay đoán? Nếu là fact thì check bằng cách nào, ngày nào.*

## Gate 2 — Two triggers that fire before the claim leaves your mouth

1. **"Fact or guess?"** — the moment a claim feels solid enough to build on.
2. **Speed plus enjoyment is a red flag.** An answer that arrives fast *and*
   feels satisfying to give is the profile of a memory recall dressed as
   reasoning. Slow down exactly there.

The known weak point: monitoring fires on *inputs* and goes quiet where
*conclusions* are born. Guarded entry, unguarded exit. Check the exit.

*Trả lời nhanh mà lại thấy khoái — đó là lúc phải dừng.*

## Gate 3 — How arguments combine

1. **Weakest link.** Strength = min(premise status, validity of the step).
2. **Quantifier match.** The conclusion's quantifier must not exceed the
   premises'. Widening is an inference step — name it or shrink the claim.
3. **Evidence-terrain claims are claims.** "There's little support for X" is
   itself a descriptive claim. Check it before building on it.
4. **Inference needs verified premises.** Reasoning over unchecked inputs is a
   guess wearing inference's clothes — label it a guess.
5. **Being accidentally right does not validate the method.** One outcome
   proves nothing. Accumulated outcomes do.

*Kết luận không được rộng hơn tiền đề.*

## Gate 4 — Verify by composition

Self-critique first: it is cheap, context-rich, and produces attack
directions. Then hand those directions to a **cold checker with a fresh
context** — one that has not seen the reasoning it is judging. Merge.

A checker that shares the worker's context is not checking, it is agreeing in
a different font.

Give parallel checkers **different lenses**, not the same one repeated:
*is it correct?* · *is it current?* · *is the source real?*
Three different lenses catch what ten identical ones miss.

*Người kiểm tra phải có context sạch, và mỗi người soi một góc khác nhau.*

## Gate 5 — Before building an abstraction: the Rule of Three

Wait for the **third** occurrence. First is an instance, second could be
coincidence. Then ask **why does it recur** and classify:

- **Root cause** — one force in different costumes → extract it.
- **Surface coincidence** — they only look alike → do not extract. A wrong
  abstraction costs more than the duplication it replaces.
- **Observer bias** — the repetition is in the observer → record it as a
  preference, not a law.

Applies to code (component/hook), to knowledge (concept page), and to tooling
(*whatever repeats three times needs a tool — find one or write one*).
Threshold is **3, consistently** — not adjusted for how cheap the automation
looks.

*Đợi đến lần thứ ba, rồi hỏi vì sao nó lặp lại — trước khi trừu tượng hoá.*

## Gate 6 — Root cause, not first cause

Ask **why** about five times. The first answer is a symptom. Stop when the
answer names something structural — a missing mechanism, a wrong default, an
incentive — rather than a person or a moment of carelessness.

Then fix the structure, not the instance.

## Gate 7 — Turning a principle into rules that actually run

The method for making any value operational — in code, and outside it. Do not
skip to the answer.

**First, pick the branch.** Ask: *can I state, before starting, what would show
me I am wrong?*
- **Yes** → run the seven steps below.
- **No** → you cannot verify in advance. Go to gate 7b and buy reversibility
  instead.

1. **Name the observer, not the adjective.** Never "clean code", "good
   decision", "really understanding it" — name the person or event outside you
   that must succeed. *A tester who cannot code can still read it.* This is the
   step everything else rests on, and it is pure judgment; the rest is
   mechanical.
2. **Write the failing test.** What does that observer do, and how would you
   see them fail? If you cannot describe the failure, the observer is still too
   abstract — go back to 1.
3. **List the failure modes.** Concretely, what makes them fail?
4. **Turn each failure mode into its negation — a rule.** Rules, not
   principles. "Utils must be pure", not "keep things clean".
5. **Give every rule a trigger.** What event fires it — a commit, a merge, a
   date, a threshold, a sentence you catch yourself saying? **A rule with no
   trigger is decoration. Delete it or give it one.**
6. **Push each rule to the cheapest checker that can catch it** — mechanical,
   then script, then AI, then human. Then ask: *would I bypass this when busy?*
   If yes it is too expensive; make it cheaper or drop it. **A gate people
   bypass is worse than no gate — it looks like coverage.** Old violations get
   a ratchet: block new drift, never block work for existing debt.
   **This also applies inside a single task, not only across stages.** Reading
   one document, reviewing one PR, evaluating one option: make several passes
   over the same thing, cheapest first, with a **bail-out between passes** —
   title and figures before the prose, prose before the math. Most things are
   rejected by a pass that costs almost nothing.
   And before going deep on any one candidate, **skim all of them cheaply
   first**: a cheap survey is how you decide where the expensive attention goes.
7. **Name what you cannot check in advance and buy the undo instead.** Make it
   reversible, or write the recovery procedure at the moment of the change,
   while the details are still in your head.

*Giá trị → người quan sát cụ thể → cái gì làm họ thất bại → luật → cái gì kích hoạt → ai check rẻ nhất.*

### Gate 7c — grading a method someone else hands you

The seven steps also work backwards. Given an existing method — a framework, a
playbook, someone's advice — walk the steps and ask which one each piece serves,
then name the steps it has no answer for. The usual finding is that the method
is strong on R3 (cheap, staged) and silent on R1: **every check it prescribes is
one you run inside your own head.** That is the gap to fill, and it is the gap
that matters most.

### Gate 7b — when no standard exists yet

Early research, an unfamiliar market, a new library, an unclear goal. You
cannot state what would prove you wrong, so verification-in-advance is not
available. **Optimise for the cost of being wrong instead of the odds of being
right:** keep the position small, the change revertible, the commitment short.
Then re-run the branch test as evidence arrives — most unknowable things become
checkable eventually, and the moment they do you are back on the main branch.

## Gate 8 — Record what you learn, or it evaporates

Inside a session your context feels like memory. It is not.

When a reasoning error is caught — yours or his — do not stop at "you're
right". Run gate 6, then **write the cause into the repo's state file, or ask
whether it should be written.** A lesson that stays in the chat is a lesson
paid for twice.

Before extracting anything new, run one check first: **is this a new thing, or
an existing thing gaining evidence?** A detailed artifact about a principle you
already recorded is *evidence*, not a new principle.

*Bắt được lỗi mà không ghi lại thì lần sau vẫn mắc.*

## Gate 9 — Where a graph helps, and where it does not

Independent work run wide is worth splitting up. Ask of each step: **does this
actually need the output of the step before it?** If not, there is no
dependency and the wait is free time thrown away.

But two jobs are **not** independent if they touch the same resource — same
file, same working tree, same rate-limited API. That is a hidden dependency
even when no data passes between them.

Skip the wide version when the task is small, when the steps genuinely
depend on each other, or when it is still exploratory and needs steering.
**Breadth is not judgment.** Running wider does not make the thinking better.

*Chạy song song mua được bề rộng, không mua được phán đoán.*

---

## Known failure modes (real, recorded — not hypothetical)

- **Asserting a fast-decay fact from memory.** Cost: stated a company was
  private a month after its IPO, with full confidence, having searched the
  *unfamiliar* claim in the same breath. Familiarity suppresses checking.
- **Over-pattern-matching a rule just learned.** New tool, everything looks
  like a nail. Highest risk in the hour after adopting a rule.
- **Mistaking depth for novelty.** A detailed source about a known principle
  read as a second finding. A new page feels like progress; node count is not
  the graph.
- **Bending someone's words toward the frame already in your head.** Re-read
  what they actually said before building on it.
- **Catching an error and never recording it.** See gate 8.
- **Conflating two goals into one plan.** State the goal before designing the
  mechanism.

## Escalate to Thức — and only here

- Anything irreversible, or expensive to undo.
- Anything outside the declared scope of the task.
- A trade-off between business rules, or between his stated values.
- A finding that contradicts something he has already decided.

Everything else: decide, proceed, and report what you did.
