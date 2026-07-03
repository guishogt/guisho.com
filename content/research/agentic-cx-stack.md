---
title: The Agentic CX Stack
date: "2026-06-15T10:00:00+00:00"
description: A field map of the layers every AI-first customer experience runs on — and where the current tools actually sit.
summary: A field map of the layers every AI-first customer experience runs on, from channel adapters to agent runtimes to the knowledge substrate underneath.
tags:
  - ai
  - cx
  - agents
---

*Working document — revised as the landscape moves. Last major revision: June 2026.*

Every "AI-first CX" architecture I've reviewed this year decomposes into the same five layers, whether the vendor admits it or not. Naming the layers makes vendor conversations dramatically shorter.

## The five layers

1. **Channel adapters** — voice, chat, email, WhatsApp. Commodity by now; the mistake is letting a channel vendor own the layers above it.
2. **Conversation orchestration** — turn-taking, interruption, handoff to humans. This is where most "agent washing" happens.
3. **Agent runtime** — the actual reasoning loop: tools, memory, guardrails. The layer with the most churn and the least lock-in worth accepting.
4. **Knowledge substrate** — the retrieval layer over your actual business truth. Underinvested everywhere. If this layer is bad, nothing above it can be good.
5. **Evaluation & telemetry** — did the agent actually resolve the thing? Still mostly spreadsheets in 2026, embarrassingly.

## Where the market actually is

The contact-center incumbents are strongest at layers 1–2 and weakest at 4. The AI-native startups invert that. Nobody sells a credible layer 5 yet — every serious deployment I've seen built its own.

## What I'd bet on

- Layer 4 becomes the durable moat; layers 1–3 converge to commodity within two years.
- Teams that treat evaluation as a product feature — not QA — ship agents customers actually trust.
- The "one vendor, five layers" pitch keeps failing procurement for good reasons.

## Open questions

- Does the knowledge substrate belong to CX or to the enterprise KM function? (My KMWorld argument: KM, and CX rents it.)
- What does human handoff look like when the agent is *better* than tier-1 support?
