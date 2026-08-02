---
title: Korea 2026 Margin Call Crisis
type: entity
created: 2026-08-02
updated: 2026-08-02
sources: [sources/2026-08-02-margin-call-doc-cham.md]
---

# Korea 2026 Margin Call Crisis

Retail-scale case of [[wiki/margin-and-leverage-risk]]'s "stacked leverage"
failure mode, surfaced by the July 2026 AI/semiconductor market rout.

## What happened

`{fact ✓2026-08-02, web search — Vietstock/Investing.com, Nguoi Quan Sat,
CafeBiz, multiple outlets citing Korea's Financial Supervisory Service (FSS),
method: cross-referenced search snippets, not primary-source fetch (blocked
403)}`

- South Korea's individual investors leaned heavily into **single-stock
  leveraged ETFs** (2x/3x) on AI/semiconductor names through H1 2026 — the
  25 largest leveraged ETFs' share of the market roughly doubled, from ~15%
  at the start of 2026 to ~30% by June.
- When the AI/semiconductor sell-off hit in July 2026, a leveraged ETF
  tracked in reporting (KORU) lost **~70% of its value** from its June 1
  peak, falling back to late-January 2026 price levels.
- The FSS reported **over 1.2 million margin trading accounts** hit the
  margin-call threshold.
- Securities firms force-liquidated an estimated **320,000–360,000
  accounts**.
- Total leverage-related losses: **~2.15 trillion KRW (~$1.45B)**.
- Government response: suspended new licenses for single-stock leveraged
  ETFs, and tripled the minimum deposit requirement for these products.

## Why this is the "đòn bẩy kép" (double leverage) case

The mechanism the source article names as rule 1 of [[wiki/margin-and-leverage-risk]]
— borrowing margin to buy an already-leveraged instrument — is exactly what
played out here at market scale: retail investors used margin accounts to
buy leveraged ETFs that were themselves 2x/3x exposed to volatile AI/chip
stocks. Two multipliers compounding meant a ~28.6% index-level drawdown
produced a ~70% loss in the leveraged product, tripping margin thresholds
for over a million accounts simultaneously.

## Related

- [[wiki/margin-and-leverage-risk]] — the concept this case instantiates.
- [[wiki/situational-awareness-margin-call-2026]] — the institutional-scale
  case from the same triggering event (July 2026 AI/semiconductor rout).
