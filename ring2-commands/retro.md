---
description: Post-task retro — propose a skill-file patch from what just happened
---

Run a retro on the task we just finished and propose durable knowledge to
write back. Scope: $ARGUMENTS (default: this session's work).

## When this should run

Trigger on any of: the task took **5+ tool calls**, a **tricky error got
fixed**, a **non-obvious workflow** was discovered, or **I corrected you**.
If none of those happened, say "nothing worth encoding" and stop — a forced
entry is worse than no entry.

## What to look for — evidence, not self-assessment

Never ask yourself "did I do well?" — the answer is always yes, and that is
precisely the failure mode this command exists to route around. Instead scan
the session transcript for **signals**:

- Did I correct your **style, format, or verbosity**? Frustration phrases
  ("stop doing X", "too verbose", "just give me the answer") are first-class
  signals — encode the preference so the next session starts knowing it.
- Did I correct your **workflow or sequence of steps**? Encode the correction
  as an explicit step or a pitfall.
- Was there a **non-trivial fix, workaround, or debugging path** a future
  session would benefit from?
- Did a skill you loaded turn out **wrong, incomplete, or outdated**? Patch
  that one first.

## Preference order — take the earliest that fits

1. Patch the skill that was **actually loaded** this session.
2. Patch an existing broader skill it belongs under.
3. Add a supporting file under an existing skill.
4. Create a new skill only when nothing covers this class of work.

A long flat list of one-session-one-skill entries is the failure mode. Prefer
growing what exists.

## How to write it

- **Patch, never rewrite.** Small targeted diff; a rewrite risks breaking what
  already works and costs more tokens.
- Keep frontmatter valid; verify the file still parses after the edit.
- **Propose the diff and stop.** I accept or reject. Never self-merge into a
  hand-written skill — those are mine; you may only suggest.

## Finally

Update `STATE.md`: what was tried, what's verified, what failed and is still
open, and where the next session should pick up.
