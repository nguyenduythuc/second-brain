---
title: Framework Generator — the network, and the steps that turn it into a domain framework
type: synthesis
created: 2026-09-08
updated: 2026-09-08
sources: [sources/2026-09-05-ng-using-coding-agents.md, sources/2026-07-27-lfvn-coding-convention.md, sources/2026-07-27-craft-philosophy-self-report.md]
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
- **Not yet run on: learning.** Next iteration. Until then this page claims
  transfer to one non-code domain, not to all.

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
