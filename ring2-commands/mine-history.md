---
description: Mine this repo's history for craft knowledge that should become skill content
---

Extract the engineering judgment already buried in this repo's history, so it
can become skill-file content. Target: $ARGUMENTS (a package, a path, or a
time window — if empty, cover the last 6 months across the repo).

**Rule zero: no invention.** Every candidate must trace to a specific commit,
PR, or review comment. Cite the SHA or PR number. If you can't cite it, drop it.

## Step 1 — Mine three seams

1. **My repeated review comments.** Read my PR review comments. Anything I've
   said 3+ times is a rule I hold but never encoded. Group by theme.
2. **`fix:` commits that immediately follow agent-authored commits.** Each diff
   is a recorded gap between the agent's output and my standard — the single
   richest source, and usually ignored.
3. **Incident / hotfix / revert commits.** Highest value: the cost was already
   paid in production damage.

## Step 2 — Classify before extracting

For each candidate ask **why it recurs**, then label it:

- **root cause** — one underlying truth wearing different costumes → encode it
- **surface coincidence** — looks similar, isn't → drop it (a wrong
  abstraction costs more than duplication)
- **my preference** — legitimate, but encode it as *preference*, not as law

## Step 3 — Report, don't write

Output a table: theme · evidence (SHA/PR) · classification · which skill file
it belongs in · which section (`Known failure modes` / `Anti-patterns` /
`Escalate to human`).

**Stop there and wait for me.** Do not modify any skill file in this command.
Say plainly which candidates you are least confident about.
