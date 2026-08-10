---
title: "The Brain as a Data System"
type: synthesis
summary: "reading this repo through DDD and data-intensive lenses: it is already event-sourcing + a read model; the binding constraint is ingest cost O(n), not storage."
created: 2026-08-10
updated: 2026-08-10
schema_version: 2
sources: []
---

# The Brain as a Data System

From the 2026-08-10 discussion: *"is the design system for this brain good yet
— in DDD terms, or data-intensive terms?"* The question was asked while the
wiki was still small, which is the only time the answer is cheap to act on.

This page is the brain looking at its own architecture. [[wiki/about-this-brain]]
says what the brain is *for*; this says what it *is*, structurally, and where it
breaks.

## First: the question contained a wrong premise

The question was framed as *"before the data grows too big."* Measured at
2026-08-10: 17 wiki pages ≈ 1,955 lines, sources ≈ 1,805 lines, whole repo
≈ 25–30k tokens {fact ✓2026-08-10 fast; method: `wc -l` + ~12 tokens/line
estimate}. That is well inside a single context window, growing at ~8–9
pages/month, so storage volume is roughly a year away from mattering
{inference, from the two measurements above}.

**The constraint that actually binds is the cost of one ingest**, and it is
already binding. `CLAUDE.md` requires touching every page a new fact changes,
and links were maintained by hand in both directions — so at n=17, a single
ingest already rewrote 8–10 files {fact ✓2026-08-10 fast; method: counted
outbound links per page}. That cost is **O(n)**: it grows with the wiki, and
the failure mode is not a crash but an agent (and a human) who quietly stops
wanting to ingest.

This is worth generalizing beyond this repo: *ask what the write costs, not
what the store holds.*

## The architecture that was already there

Read against a data-intensive vocabulary, the layers map cleanly — the design
was coherent before anyone described it this way:

| Layer | Role |
|---|---|
| `sources/` (immutable) | **event store** — raw, append-only, never rewritten |
| `log.md` (append-only) | **write-ahead log** |
| `wiki/` (compiled, denormalized) | **materialized read model** |
| `index.md` | **secondary index** / routing layer |
| `STATE.md` | **checkpoint** for session recovery |

That is event sourcing with a read model, and the `CLAUDE.md` principle
*"compile, don't retrieve"* is exactly the instruction to serve from the
materialized view rather than re-deriving from raw events {inference — the
correspondence is tight, but nobody designed it from the textbook}.

The **ownership split** is the other half, and in domain-driven terms it is an
aggregate boundary drawn around *who may write* rather than around a topic: the
human owns `sources/` and judgment, the agent owns `wiki/` and bookkeeping. A
conclusion changes only by adding a correcting source. That constraint is what
makes the wiki trustworthy, and it is the part most worth defending.

## Where the lenses mislead

Both DDD and the data-intensive literature assume **many concurrent writers, a
machine query engine, and hard costs for inconsistency**. This brain has one
writer, one reader, is read-mostly, and its query engine is an LLM that
tolerates ambiguity, fuzzy joins and duplication.

So **normalization discipline is nearly worthless here.** Two pages restating
the same idea is not a defect; for a reader that arrives with partial context it
is useful redundancy. Importing consistency machinery from a database would cost
effort and buy nothing {inference}.

What actually decides whether this brain survives is not in either lens:

- **Routing** — can `index.md` take a question to the right three pages? This is
  what "index" means here, and it is a *content* problem, not a data-structure
  one.
- **Trust labels** — the epistemic tags of [[wiki/fact-vs-opinion]]. They solve
  the problem no database has: *data that was true when written and is false
  when read*. This is worth more than any schema normalization.

Closest honest description: the brain is **a compiler with a TTL cache**, not a
database.

## Three structural defects, and what was done

**1. Derived data was hand-written.** `index.md` and cross-links were typed by
the agent though both are computable. Fixed by `scripts/derive.py`: pages own
their frontmatter and outbound links, and the script generates the index and
every page's backlink block. Ingest drops from ~8–10 writes to 1–2, so the cost
is no longer a function of wiki size. `scripts/lint.sh` fails when the derived
layer is stale, which makes drift impossible rather than merely unlikely.

A side effect worth recording: the old orphan check was **dead code**. It
counted `index.md` as an inbound link, and every page is in the index, so it
could never fire. A check that cannot fail is not a check — see
[[wiki/shepherd-review-gates]] on invariants that live in prose.

**2. The ownership boundary was enforced by nothing.** The rule sat in
`CLAUDE.md` as a paragraph while [[wiki/shepherd-review-gates]] — a page this
brain wrote — argues that authority belongs in the type signature, failing
closed. Fixed by `.github/workflows/wiki-boundary.yml`: commits touching the
agent-owned layer must be agent-authored, with an explicit `Wiki-Override:`
trailer as the escape hatch, so a bypass is permitted but permanently visible.

**3. Facts had no expiry, so staleness was invisible.** Retrofitting decay
classes onto pre-v0.2 pages immediately found a real one: [[wiki/andrej-karpathy]]
had described its subject by roles he had already left, untagged and undated
since June. Same failure as the SpaceX incident in [[wiki/metacognition]], one
layer down — there the *agent* asserted a stale fact, here the *wiki stored*
one. The retrofit also found the "willpower runs out" premise in
[[wiki/understanding-vs-doing]] resting on ego depletion, which failed a 23-lab
preregistered replication; the page's conclusion was rebuilt on premises that
survive.

Three defects, one shape: **a rule with no mechanism decays into a wish** — the
same lesson the weekly-lint routine taught on 2026-07-27 when it silently never
fired.

That looks like a rule-of-three trigger, and the honest count says wait. Two of
the three sightings came out of *this one investigation*, so they are one
observation seen three times, not three independent ones — and the agent's
recorded failure mode is precisely over-pattern-matching a freshly learned rule
(see `STATE.md`). Held as a watch item at **two independent sightings**
(07-27 routine, 08-10 boundary/checks). A third from an unrelated context earns
it a concept page {inference — deliberately the conservative reading}.

## What is deliberately not done

**Splitting the wiki into bounded contexts by domain.** Everything here is one
domain (thinking / AI architecture), so separating contexts now would be an
abstraction built for traffic that does not exist. The trigger to revisit is
concrete: **the first time a term means two different things in two pages**
(e.g. "review gate" for agents vs. for frontend pull requests), or the first
domain that shares no vocabulary with this one. Migrating 17 pages is cheap;
migrating 60 is not — so this is worth watching, just not worth building.

Related open items live in [[wiki/what-ai-structures-still-need]]: page
lifecycle and compaction (now trigger-checked at 320/400 lines by the lint,
though nothing archives yet), and trace-based reflection.

## Related

- [[wiki/llm-wiki-pattern]] — the pattern this brain implements; this page is
  the engineering read of it.
- [[wiki/shepherd-review-gates]] — where "put the invariant in the mechanism"
  comes from.
- [[wiki/what-ai-structures-still-need]] — the remaining upgrades.
- [[wiki/fact-vs-opinion]] — the trust-label system that does the work a
  database schema cannot.

<!-- backlinks:start (generated by scripts/derive.py — do not edit by hand) -->

---

**Linked from:** [[wiki/about-this-brain]] · [[wiki/what-ai-structures-still-need]]
<!-- backlinks:end -->
