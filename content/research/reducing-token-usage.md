---
title: Reducing Token Usage in Agentic Coding
date: "2026-06-01T10:00:00+00:00"
description: Field notes on the tooling layer that keeps Claude Code from burning tokens — what I installed, what worked, and the candidates still on the bench.
summary: Field notes on the tooling layer that keeps Claude Code from burning tokens — proxies that filter I/O, knowledge graphs that spare the agent from reading the whole repo, and the candidates still on the bench.
tags:
  - ai
  - claude-code
  - tooling
---

*Working document — updated as tools earn or lose their place in the stack.*

Agentic coding has a silent cost curve: the agent reads everything, and you pay for everything it reads. Most of what flows through the context window is noise — full command output, entire files for a one-line answer, repo exploration that repeats every session. This document tracks the tools I use to cut that waste, and how they've held up.

## Installed and proven

On 2025-05-26 I installed **rtk** and **code-review-graph**, and they work well.

- **[rtk](https://www.rtk-ai.app/)** — sits in the middle between the agent and the shell, filtering command I/O so only the important part reaches the model instead of the full dump. The hook-based setup rewrites commands transparently; the agent doesn't need to know it's there. Claimed 60–90% savings on dev operations, and my usage analytics are consistent with that.
- **[code-review-graph](https://code-review-graph.com/install)** — builds a knowledge graph of the codebase so the agent can answer structural questions without re-reading the whole repo every session. The pitch that sold me: [stop your agent reading the whole repo](https://dev.to/stevengonsalvez/code-review-graph-stop-your-agent-reading-the-whole-repo-4272), which is the article I based my install on. Background reading: [reduce LLM token consumption with code-review-graph](https://medium.com/@https.azure/reduce-llm-token-consumption-with-code-review-graph-a5266657b213).

## On the bench

Candidates I've collected but not yet adopted:

- **[context-mode](https://context-mode.com/)** — plugin to improve context windows. Next in line to trial.
- **[graphify](https://github.com/safishamsi/graphify)** — the open-source alternative to code-review-graph: a [self-updating knowledge graph for Claude Code](https://dev.to/mir_mursalin_ankur/graphify-code-review-graph-build-a-self-updating-knowledge-graph-for-claude-code-and-other-ai-j1m). Worth watching if the hosted option ever becomes a constraint.
- **[Understand-Anything](https://github.com/Lum1104/Understand-Anything)** — broader comprehension tooling; unclear yet where it fits relative to the graph tools.

## The autonomous angle

Token efficiency compounds with autonomy: commands that let the agent [finish work while you sleep](https://medium.com/@richardhightower/claude-code-the-autonomous-commands-that-finish-work-while-you-sleep-goal-loop-batch-etc-7acb82bf46b1) (goal, loop, batch) only make economic sense if each iteration is cheap. The filtering layer is what makes the loop affordable.

## Open questions

- Where is the crossover point where a knowledge graph goes stale faster than it saves tokens?
- Does I/O filtering ever hide the detail that would have prevented a wrong turn? Haven't caught it doing so yet — but I also wouldn't have seen it.
