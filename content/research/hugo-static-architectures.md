---
title: "Static Architectures in 2026: Why This Site Still Runs on Hugo"
date: "2026-05-20T10:00:00+00:00"
description: An architecture note on the S3 + CloudFront + Hugo pipeline behind guisho.com, and what the JS-framework resurgence gets wrong about content sites.
summary: An architecture note on the S3 + CloudFront + Hugo pipeline behind this site — costs, tradeoffs, and what the JS-framework resurgence gets wrong about content sites.
tags:
  - architecture
  - hugo
  - aws
---

*Working document — the running architecture notes for this very site.*

This site is 789 markdown files, one Go binary, an S3 bucket, and a CDN. Total monthly cost: under $3. This note records why that stack keeps winning my annual "should I migrate?" review.

## The pipeline

Push to `main` → GitHub Actions → Hugo build (~2s for ~800 pages) → `aws s3 sync` → CloudFront invalidation. No servers, no runtime, no database. The CMS is a git repo that happens to also be an Obsidian vault.

## The annual challenge, and this year's verdict

Each year I evaluate a migration target. This year's candidates and why they lost:

- **Astro** — genuinely good, but its win is islands of interactivity. This site has none. I'd be adopting a JS toolchain to render markdown.
- **Next.js SSG** — build times an order of magnitude worse, for features (ISR, server components) a personal site never exercises.
- **Eleventy** — the honest competitor. Loses only on build speed and single-binary distribution.

## What the resurgence gets wrong

The framework pitch assumes content sites need an application platform underneath. They need the opposite: the fewest moving parts between a markdown file and a CDN edge. Every dependency is a future migration.

## Costs of staying

Honesty section: Go templates are the worst part of Hugo, image processing workflows are clumsy, and the theme ecosystem is stagnant. I pay those costs once a year in maintenance. The alternative stacks charge monthly.
