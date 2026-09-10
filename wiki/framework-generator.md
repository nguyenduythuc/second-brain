---
title: Framework Generator — the network, and the steps that turn it into a domain framework
type: synthesis
created: 2026-09-08
updated: 2026-09-10
sources: [sources/2026-09-05-ng-using-coding-agents.md, sources/2026-07-27-lfvn-coding-convention.md, sources/2026-07-27-craft-philosophy-self-report.md, sources/2026-09-10-ng-reading-research-papers.md]
---

# Framework Generator

[[wiki/four-roots]] found what everything reduces to. This page does the next
thing Thức asked for: turn those roots into **a network** (how they depend on
each other) and **a procedure** that generates a working framework for any
domain — code, investing, learning.

---

## The network

The four roots are not a list. They have a shape.

```
                    R1  the standard comes from outside
                    │   (what makes anything checkable at all)
                    │
        ┌───────────┴───────────┐
        │                       │
   R2 triggers             R3 affordable
   will it fire?           will it survive?
        │                       │
        └───────────┬───────────┘
                    │
              a live check
                    │
              ...but only where a standard exists in advance
                    │
                    ▼
        R4  where it does not: choose the cheaper undo
```

Read it as: **R1 is the goal. R2 and R3 are the conditions under which R1
survives contact with real life. R4 is the branch you take when R1 is
unavailable.**

- **R1 alone is a wish.** A verification nobody runs is not a verification.
- **R2 without R3** builds a check that fires reliably and gets bypassed —
  worse than nothing, because it looks like coverage.
- **R3 without R2** builds a cheap check that never runs.
- **R4 is not a weaker R1.** It is the correct move when no outside standard
  exists *yet* — early research, a new market, an unfamiliar library. You
  cannot verify in advance, so you buy the right to be wrong instead.

*R1 là đích, R2 và R3 là điều kiện sống, R4 là nhánh rẽ khi chưa thể biết đúng sai.*

**The one test that tells you which branch you are on:** *can I state, before
starting, what would show me I am wrong?* Yes → R1 branch, build the check.
No → R4 branch, buy reversibility instead.

---

## The steps

Seven steps. This generalises gate 7 of `reasoning-gates`, which was derived
from one case (his clean-clear code) and is therefore code-shaped. This is the
domain-independent form.

**1. Name the observer, not the adjective.**
Never "good code", "good investment", "really understanding it". Name the
person or event that must succeed, outside you. This is R1, and it is the step
everything else depends on.

**2. Write the failing test.**
What does that observer do, and how would you see them fail? If you cannot
describe the failure, the observer is still too abstract — go back to 1.

**3. List the failure modes.**
Concretely, what makes the observer fail? Each one is a candidate rule.

**4. Turn each failure mode into its negation — a rule.**
Rules, not principles. "Utils must be pure", not "keep things clean".

**5. Give every rule a trigger.** *(R2)*
What event fires this rule? Commit, merge, a price move, a calendar date, a
sentence you catch yourself saying. **A rule with no trigger is decoration —
delete it or give it one.**

**6. Push each rule to the cheapest checker that can catch it.** *(R3)*
Mechanical → script → AI → human, cheapest first. Then ask the survival
question: *would I bypass this when busy?* If yes, it is too expensive; make it
cheaper or drop it. Old violations get a ratchet — block new drift, never block
work for existing debt.

**7. For anything you cannot check in advance, buy the undo instead.** *(R4)*
Name the irreversible parts. Make them reversible, or write the recovery
procedure at the moment of the change, while you still remember the details.

---

## Stress test: investing

Deliberately the furthest domain from code. If the method only works on code,
it should break here. *(Method only — nothing here is advice about what to
buy.)*

| Step | Applied |
|---|---|
| **1. Observer** | **Your future self at exit**, reading what you wrote at entry. |
| **2. Failing test** | They cannot tell whether the reason you bought is still true. |
| **3. Failure modes** | No written thesis · thesis unfalsifiable ("good company") · goalposts move after the price moves · price movement read as the thesis being confirmed · position so large that exiting is forced rather than chosen. |
| **4. Rules** | Write the thesis before entering. State one condition that would make it false. Date it. Define the exit condition in advance. |
| **5. Triggers** | A price move past a stated threshold · the scheduled review date · news touching the specific variable the thesis names. |
| **6. Cheapest checker** | A dated text file, one entry per position: thesis, invalidation condition, review date. Mechanical: the calendar. Human: only the judgment call at review. |
| **7. Undo** | **Position size *is* the undo path.** Small enough to exit without being forced is the reversibility purchase. |

**It transfers, and it produces something non-obvious.** The strongest rule it
generates is not about picking — it is *"state in advance what would prove you
wrong"*, which is R1 with a date attached. And step 7 reframes position sizing
as a reversibility decision rather than a return decision.

Note what happened at step 3: **"price movement read as thesis confirmation"**
is the same failure as an agent grading its own work — using the system's own
output as the outside standard. R1 caught it in a domain it was not derived
from. That is the falsification test passing.

*Nguồn kiểm chứng phải nằm ngoài — trong đầu tư cũng vậy, giá lên không có nghĩa là luận điểm đúng.*

---

## Second run: learning

The domain where the brain already had half the answer
([[wiki/understanding-vs-doing]]).

**Step 1 forces a split the other domains did not.** Learning has *two*
observers, because it has two goals:

| Goal | Observer | Failing test |
|---|---|---|
| **Understand** (declarative) | someone who does not know the subject | you stall when they ask "why?" one level down |
| **Do** (procedural) | the task itself, unaided, under real conditions | you cannot start without the tutorial open |

**Choosing the wrong observer is the classic failure.** You test by re-reading
— which measures recognition — when the goal was to do.

| Step | Applied |
|---|---|
| **3. Failure modes** | re-reading feels like learning · recognition mistaken for recall · consuming input, never producing output · learning the tool instead of the transferable idea · no spacing · never being wrong in front of anyone · picking material by comfort instead of by gap |
| **4. Rules** | retrieval before re-reading · one produced output per session · explain it to someone who does not know · separate the concept from the tool and label which is which · schedule the second look before leaving the first · pick next material from what you failed |
| **5. Triggers** | **"I just read that and felt I understood it"** → immediate retrieval test · end of session → write one line: *what can I now do that I could not before?* · a real task at work touching the topic — the natural test firing on its own · the scheduled review date |
| **6. Cheapest checker** | can I write it from memory in five lines (retrieval, not recognition) → does the thing actually run → a person who does not know it reads my explanation and can act on it |
| **7. Undo** | when you cannot tell whether a field will matter, **learn the transferable layer before the tool layer** — the concept survives the tool dying |

Two things fell out that were not put in.

**The trigger is already on his practice card.** *"I just read that and felt I
understood"* is Trigger 2 — speed plus satisfaction is a red flag — in a
different domain. Derived independently here, which is what a real generator
should do.

**Step 7 reproduces his oldest principle.** *Thinking over tools* is not an
assertion in this run; it is what R4 outputs when you cannot know in advance
whether a technology will last. His principle 1 falls out as a **consequence**.

*Nguyên tắc đầu tiên của anh — tư duy hơn công cụ — không phải tiên đề, nó là kết quả của R4.*

## The network gains one thing from the third domain

Running all three exposed something two domains could not: **R1 and R3 pull
against each other, and how hard depends on the domain.**

| Domain | External check | Cost | Tension |
|---|---|---|---|
| **Code** | a test that ran | near zero | **none** — cheap *and* external |
| **Investing** | realised outcome | high (time) | real |
| **Learning** | a person who does not know it | high (needs a person) | **severe** |

In code, R1 and R3 are aligned, which is why the discipline feels natural
there. In learning they conflict directly: the outside standard is expensive,
so R3 pushes toward cheap substitutes — and every cheap substitute
(re-reading, nodding along, "I get it") is **inside** the system and therefore
fails R1.

**That is the mechanism behind self-deception in slow-feedback domains.** Not
weak character; a structural conflict between two roots.

**The resolution:** when external checks are expensive, buy the cheapest *real*
external check — never a cheap fake one. Teach one person. Ship one small thing
publicly. Make one decision with something at stake. One real check beats ten
comfortable ones.

*Chỗ nào kiểm chứng từ bên ngoài đắt, chỗ đó người ta tự lừa mình — vì cái rẻ thì nằm bên trong.*

## Second use: auditing someone else's method

The generator turns out to do a second job — not only *producing* a framework
but **grading one that already exists**. First test: Ng's paper-reading method
(`sources/2026-09-10-ng-reading-research-papers.md`, a third-party summary —
treat the wording as unverified).

### What it gets right, and which root each piece is

| Ng's move | Root | Why it works |
|---|---|---|
| Four passes over one paper: title/abstract/figures → conclusion → text without math → math | **R3** | Escalating cost with a bail-out after each pass. Identical in shape to his own 4-tier review gate — cheapest filter first, expensive attention spent only on survivors |
| Scan 10% of all papers before reading any | **R3** | A cheap survey to *allocate* expensive attention across candidates |
| 15–20 papers for understanding, 50–100 for mastery | **R2** | A countable target is a trigger; "read the literature" is not. The numbers themselves are unevidenced — their function is to be countable |
| The four questions (what was attempted / key elements / what can I use / which references next) | **R1 + step 2** | They are a *failing test*: if you cannot answer them, the pass failed. "What can you use yourself?" judges the paper against your work — a standard outside the paper |

### What the generator says is missing

Running the seven steps on "learn a field by reading" exposes three holes.

1. **No external check anywhere.** Every check in the method is answered in your
   own head. By the R1–R3 tension below, that is exactly what you would predict
   of a cheap method in a slow-feedback domain — and exactly where
   self-deception enters.
2. **No required output.** The method is entirely input-side. The learning run
   above says *one produced output per session*, because the observer for "can
   do" is the task performed unaided.
3. **No spacing trigger.** It has a count but no re-visit event. Step 5 says a
   rule with no trigger does not fire; "read 50 papers" does not say when to
   come back to paper 3.

**The diagnosis is sharper than the list.** Ng's method builds the *understand*
observer and not the *do* observer — it is a **declarative**-learning method.
For reading papers that is the right choice. Applied to React Native internals
or to investing, it would produce understanding without capability, which is
[[wiki/understanding-vs-doing]]'s whole subject.

Minimum additions to make it procedural: one artifact per paper that runs or
gets used · explain one paper to someone who does not know it · schedule the
second look before closing the first.

*Phương pháp của Ng xây người quan sát "hiểu", không xây người quan sát "làm được".*

### What Ng's method gives back to the network

Two refinements it earned:

- **R3 applies inside a single task, not only across a pipeline.** The brain had
  R3 as staged gates (lint → CI → AI → human). Ng applies the same escalation to
  *one artifact*, four times, with a bail-out between passes. Third independent
  sighting of escalating-cost filtering, so R3 holds by its own Rule of Three.
- **Scan-before-spend is a partial answer to an open hole.**
  [[wiki/agent-operating-model]] hole 3 says human attention across concurrent
  work is unmanaged. Ng's "scan 10% of everything first, then go deep on few" is
  the same problem — finite attention, many candidates — with a cheap survey as
  the allocator.

## Where the method strains

Honest limits, found while running it:

- **R4 is weakest in slow-feedback domains.** In code, reversal cost is
  visible and immediate. In investing and in learning, "cheap to undo" needs a
  time horizon attached before it means anything — a position is reversible in
  a liquid market and not in an illiquid one, and that is a property of the
  market, not of the decision.
- **Step 1 is the hard step and the method does not help you do it.** Naming
  the right observer is judgment. Everything after it is mechanical. So the
  generator does not remove the need for taste — it concentrates it into one
  place, which is arguably its main value.
- **Run on three domains: code, investing, learning.** That is the scope of
  the claim — three domains, not "any domain". A fourth could still break it.
- **The R1–R3 tension has no clean fix**, only a rule of thumb (one real check
  beats ten comfortable ones). How to price "real enough" is unresolved.

## Consequence for this brain

Gate 7 of `portable-skills/reasoning-gates/SKILL.md` is the old code-shaped
version of the steps above. It should be recompiled to the general seven-step
form — the drift check will flag it when this page is committed. **That is a
real rule change, not a citation update**, so it goes through `/compile` and a
PR rather than a manifest bump.

## Related

- [[wiki/four-roots]] — the roots this network is made of.
- [[wiki/craft-philosophy]] — the original case the method was reverse-engineered from.
- [[wiki/ratchet]] — step 6's legacy clause.
- [[wiki/rule-of-three]] — R4's clearest instance, and the rule governing when to build a framework at all.
- [[wiki/understanding-vs-doing]] — the observer for the learning domain is already half-written here.
- [[wiki/fact-vs-opinion]] — "state what would prove you wrong" is the falsifiability core of the claim framework.
