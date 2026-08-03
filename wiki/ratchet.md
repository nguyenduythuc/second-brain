---
title: Ratchet — graduated enforcement for legacy debt
type: concept
created: 2026-07-27
updated: 2026-07-27
sources: [sources/2026-07-27-lfvn-coding-convention.md]
---

# Ratchet

**Block new debt, allow old debt to stay — and shrink.** A ratchet turns one
way only: the count can go down, never up.

Thức uses this in the LFVN monorepo {fact ✓2026-07-27 medium; method: read his
maintained convention doc}. It is the practical middle path between two bad
options in an old codebase: *ignore the debt* or *stop everything and rewrite*.

## How it works in his repo

| Mechanism | What it holds |
|---|---|
| `scripts/checks/baselines/*.json` | Known violations, listed by name. CI compares against this file, not against zero |
| ESLint grandfathered list | 14 files that broke a rule added later — named in `eslint.config.js`, no new file may join |
| Coverage floor | Existing coverage cannot drop; new/changed lines need ≥90% |
| `report-debt.mjs` + `debt-tracker.yml` | Prints total debt in every CI run, updates one GitHub issue weekly |

Old debt is **visible but not blocking**. New drift **is** blocking. And a
weekly report keeps the number in sight, so it does not quietly grow.

*Nợ cũ hiện rõ nhưng không chặn build; nợ mới thì chặn.*

## Why it works — the reasoning

Debt in a brownfield codebase cannot be paid off at once: not enough time, and
large refactors carry their own risk. But letting it spread is also wrong. The
ratchet accepts both facts at the same time.

The second reason is fairness to the PR author. **The old debt is not in the
scope of their change.** Blocking their PR for someone else's old violation
teaches people to disable the check. A ratchet only asks: *did you make it
worse?*

## Same pattern, different place: release-gated checks

`check-no-mock-flags.mjs` runs **only at the release gate** (uat/main), not on
develop. So `MOCK_*` constants are allowed while a feature waits for the
backend, and blocked before it ships. The constants must be greppable so the
check can find them.

Same idea as the ratchet: **strictness depends on where you are in the
pipeline**, not one global setting.

## Why this matters beyond his repo

[[wiki/what-ai-structures-still-need]] listed five gaps that current agent
systems have not solved. Gap 5 was **graduated enforcement** — every system we
read picks one strictness level and applies it everywhere. Shepherd enforces
hard at the syscall; Hermes gates offline; Codez relies on prompts.

**The ratchet is a working answer to that gap** {inference — his repo runs it;
no one has applied it to agent systems yet}. It grades strictness by *origin
and timing*: old vs new, develop vs release. That is a different axis from the
one we proposed (blast radius), and both can be used together.

Applied to a skill library: old skill entries stay even if they no longer meet
the current standard; **new** entries must meet it. That prevents a cleanup
project from blocking everyday work.

## Related

- [[wiki/what-ai-structures-still-need]] — gap 5, graduated enforcement.
- [[wiki/craft-philosophy]] — the 4-tier review gate this sits inside.
- [[wiki/shepherd-review-gates]] — enforcement as a system invariant; the
  ratchet shows the invariant can be time-scoped, not only scope-scoped.
