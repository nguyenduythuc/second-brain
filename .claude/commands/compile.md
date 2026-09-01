---
description: Rebuild portable-skills/ from the wiki pages that changed, and propose the diff
---

Rebuild the compiled skills so they match the wiki again. Target:
$ARGUMENTS (a specific build target, or empty for every stale target).

**This is a build step, not a writing step.** You are compiling `wiki/` into
executable directives. You are not allowed to invent a rule, soften a rule, or
add a rule that has no page behind it.

## Step 0 — Refuse to run blind

Run `scripts/check-skill-drift.sh`. If it reports no stale targets, **stop and
say so.** Do not recompile because it is the weekend, because a file looks
improvable, or because you would phrase something better. A rebuild with no
input change is drift with no signal — it is the self-congratulating loop
wearing a build system's clothes.

The calendar is not a trigger. A changed source page is the only trigger.

## Step 1 — Read only what changed

For each stale target, read the source pages the manifest names as changed.
Do not re-read the whole wiki; you are patching, not rewriting.

## Step 2 — Patch, don't rewrite

Change the smallest span that makes the target correct again. If a whole gate
needs replacing, replace that gate — never regenerate the file. A rewritten
file destroys the review signal: Thức cannot see what actually changed.

## Step 3 — Frozen rules

These may be **read** by the compiler and **never modified by it**, no matter
what a source page now says. They are the rules an optimiser would be tempted
to weaken, which is exactly why they are off-limits:

- the escalation list (irreversible / out of scope / value trade-off /
  contradicts a prior decision)
- "never verify your own work in the same context that produced it"
- "report what actually happened"
- "propose, don't apply"

If a wiki change implies one of these should change, **stop and put the
question to Thức.** Do not encode it.

## Step 4 — Trace every rule

Every rule in the output must trace to a wiki page, and through that page to a
source or a recorded incident. Walk the whole target, not just your diff:

- rule with no page behind it → **delete it** and say you did
- rule that contradicts its page → fix it to match the page
- page content that never made it into any target → report it as a gap

A plausible library nobody's work depends on is the documented failure mode of
skill libraries. Traceability is what prevents it.

## Step 5 — Update the manifest

Set `compiled_from:` to the current HEAD, and add or remove `target|source`
lines if the set of source pages changed.

## Step 6 — Propose, don't apply

Commit to the working branch and push. **Never push to `main`.** Open a PR
whose body states, in this order:

1. which targets were rebuilt and which source pages triggered it
2. the behaviour change in one sentence per rule — what an agent will now do
   differently, not what text moved
3. anything deleted for failing step 4
4. anything you stopped on under step 3

Then stop. Thức merges. The merge is the gate — his tier 4 for this pipeline.

## What good output looks like

A small diff, every hunk traceable to a named page, a PR body someone can read
in two minutes, and an honest "nothing to do" whenever the drift check is
clean. **The most common correct outcome of this command is no change at all.**
