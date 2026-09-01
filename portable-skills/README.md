# portable-skills — the brain's compiled output

`wiki/` is where thinking is stored. **This folder is what an agent executes.**
Same knowledge, different target: pages are for reasoning, these are directives
that fire at the point of decision.

Nothing here is written by hand from imagination. Every rule traces to a wiki
page, and through it to a source or a real incident.

## What is here

| File | Load | Purpose |
|---|---|---|
| `CORE.md` | always | Paste into the target repo's `CLAUDE.md`. Six rules + the escalation boundary. Short on purpose — it costs context every turn. |
| `reasoning-gates/SKILL.md` | on demand | The full discipline: 9 gates, recorded failure modes, escalation list. Copy to `.claude/skills/reasoning-gates/SKILL.md`. |

Two layers because the cost of a check must stay below its value. A rule that
must never be unloaded goes in `CORE.md`; everything else waits until the task
is judgment-heavy.

## Install

```bash
# in the target repo
mkdir -p .claude/skills/reasoning-gates
cp <brain>/portable-skills/reasoning-gates/SKILL.md .claude/skills/reasoning-gates/
# then paste CORE.md's rule block into that repo's CLAUDE.md
```

## How this differs from `ring2-commands/`

- `ring2-commands/` — **domain craft**: React Native / monorepo judgment, mined
  from that repo's own history. Only valid there.
- `portable-skills/` — **reasoning discipline**: domain-independent. Valid in
  any repo, on any subject.

Ring 2 makes the agent code like him. This makes it *think* like him.

## Keeping it honest

- **Recompile, don't hand-edit.** These files are build output. To change a
  rule, change the wiki page it came from and rebuild — otherwise the two
  drift and the wiki stops being the source of truth.
- **Every rule must trace to something that really happened.** A plausible
  library nobody's work depends on is the documented failure mode of skill
  libraries. If a rule cannot be traced, delete it.
- **The escalation list is the whole safety story.** "No intervention" is not
  the goal; intervening only where judgment is irreducible is the goal. If
  that list is empty, there is no gate.
