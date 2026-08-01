# Ring 2 commands — drop these into the monorepo

Portable slash commands that turn [[wiki/ring-2-encoding-the-craft]] from a
document you re-read into commands you type. Copy once, use forever.

## Install (one time)

```bash
cd <your-monorepo>
mkdir -p .claude/commands
cp <this-folder>/mine-history.md .claude/commands/
cp <this-folder>/retro.md       .claude/commands/
```

Commit them — they're team-visible knowledge, not personal config.

## Use

| Command | When | What it does |
|---|---|---|
| `/mine-history [scope]` | Once, at the start of Ring 2 | Extracts craft knowledge already buried in review comments, `fix:` commits after agent commits, and incident commits. Reports candidates; writes nothing. |
| `/retro [scope]` | After any substantial agent task | Scans the session for correction signals and proposes a skill-file patch. Proposes only; you accept. |

`/mine-history` is the one-off that bootstraps the skills. `/retro` is the
loop that keeps them growing — that loop is what makes this Ring 2 rather
than documentation.

## Two invariants both commands respect

1. **Evidence or nothing.** Every entry traces to a real commit, PR, or
   correction. No content written from imagination.
2. **Propose, don't apply.** The agent suggests a diff; you decide. Skills you
   wrote by hand may only receive proposals, never overwrites.

Full rationale and the 4-week success criteria: `wiki/ring-2-encoding-the-craft.md`
in the second-brain repo.
