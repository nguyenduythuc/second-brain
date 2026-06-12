# 🧠 Second Brain

A personal knowledge base built on the [Karpathy LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f):
plain markdown files, maintained by an AI agent (Claude Code). No vector DB, no
RAG — just text files and a long context window.

The agent is the product. You think out loud; it files, links, and compounds.

## Quick start

1. Open this folder with **Claude Code** (`claude` in the terminal here).
   `CLAUDE.md` turns Claude into the wiki maintainer automatically.
2. Capture something — paste an AI chat, a thought, an article — then run:

   ```
   /ingest
   ```

   The agent discusses the takeaways with you, then writes it into the wiki.
3. Ask your brain anything:

   ```
   /query what did I conclude about X?
   ```
4. Once a week, keep it healthy:

   ```
   /lint
   ```

## Layout

```
second-brain/
├── CLAUDE.md        # the agent's rules (the "schema") — read this
├── index.md         # catalog of every wiki page
├── log.md           # append-only history of ingests/queries/lints
├── sources/         # raw, immutable inputs (you own)
├── inbox/           # quick captures waiting to be ingested
├── wiki/            # the living wiki — the agent owns this
└── .claude/commands # /ingest, /query, /lint slash commands
```

## The workflow in one line

**Paste → `/ingest` → discuss → the brain grows.** Every good chat with an AI,
every idea worth keeping, lands here and gets wired into everything related.

## Make it your own repo

This was scaffolded inside another repo. To lift it out:

```bash
cp -r second-brain ~/my-second-brain
cd ~/my-second-brain
git init && git add -A && git commit -m "init second brain"
# create a private repo on GitHub, then:
# git remote add origin <your-repo-url> && git push -u origin main
```
