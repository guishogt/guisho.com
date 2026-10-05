---
author: guisho
date: "2026-09-24T00:00:00+00:00"
title: "Strategic Design at Scale: DDD Patterns for Integration-Heavy Domains"
url: /speaking/explore-ddd-2026/
description: "Explore DDD 2026, Denver. How Domain-Driven Design strategic thinking survives in marketing technology ecosystems where vendors, procurement, and org charts draw your bounded contexts for you."
cover:
  image: speaker-badge.jpg
  alt: "Luis Fernandez with his speaker badge at Explore DDD 2026"
---

**Explore DDD 2026 — Denver, September 2026** ([slides](strategic-design-at-scale-slides.pdf))

Explore DDD was a bucket-list conference for me. I got my copy of the blue book almost two decades ago, and it shaped how I think about systems ever since. Spending three days at CSU Spur with the people who wrote the books I learned from, and getting to present my own take on strategic design, was a real treat.

![Luis Fernandez holding his speaker badge in front of the Explore DDD 2026 banner](speaker-badge.jpg)

## The Talk

**"Strategic Design at Scale: DDD Patterns for Integration-Heavy Domains"** — presented at [Explore DDD](https://exploreddd.com/), Denver, September 23–25, 2026.

> "How do I model a domain that has already been modeled fifteen different times?"

[**Download the slides (PDF)**](strategic-design-at-scale-slides.pdf)

![Title slide: Strategic Design at Scale, DDD Patterns for Integration-Heavy Domains](title-slide.png)

### Synopsis

I still remember getting my copy of Evans' book almost two decades ago. It resonated immediately. This was, and is, the way to build systems. Then, through different iterations, I ended up in a world where the domain is even more complex, usually multi-layered, but where I don't get to choose the standards, the integrations, or many other aspects of the architecture. A variety of pre-packaged domains and systems: CRMs, CMS, CDPs, ERPs, Commerce Engines, DAMs, API Gateways, custom solutions, PIMs. Sometimes the integrations are clunky. Sometimes we get to change them. But many of the core principles of DDD still apply, just through a different lens.

After building hundreds of marketing technology ecosystems, I've learned that DDD strategic thinking becomes more valuable in integration-heavy domains, not less. But the challenges shift. How do you establish bounded contexts when vendor platforms define your boundaries? How do you speak a ubiquitous language across business stakeholders, compliance officers, vendor support teams, and distributed engineering groups? How do you lead architectural decisions when authority is fragmented across platform owners, security teams, and business units? And how do you make decisions today that won't become technical debt tomorrow?

### What we covered

- **Complicated vs. complex.** Why that humble website turned out to be both, and how accidental complexity plus time hardens into constraint.
- **Six anti-patterns** of integration-heavy domains: procurement-driven design (the RFP priced the boxes), the org chart becoming the domain map, "product = bounded context", "integration is plumbing", architecture wallpaper, and "the platform will solve it".
- **The modeler as strategist.** Architecture work is about systems, components, and interfaces. Strategic modeling is about meaning, boundaries, relationships, constraints, and choices.
- **Four patterns that work:** capability first, product second; own the boundary; not all squares are the same size; and Strategic Decision Records (SDRs) that keep the *why* next to the ADRs that keep the *how*.
- **Five questions for any boundary:** What does this mean here? Who owns the model? What happens at the boundary? What constraint created this? Is this boundary intentional?

DDD does not remove complexity. It gives us ways to reason about it. Do our platforms implement our domains, or define them? Where does meaning live?

### From the conference

![Getting my copy of the blue book signed by Eric Evans at Explore DDD 2026](blue-book-signing.jpg)

That book made me look good for twenty years. Getting it signed by Eric Evans was a moment.

![With Joseph Yoder and Kyle Brown, holding their book Cloud Application Architecture Patterns](book-signing-group.jpg)

With Joseph Yoder and Kyle Brown and my copy of *Cloud Application Architecture Patterns*.
