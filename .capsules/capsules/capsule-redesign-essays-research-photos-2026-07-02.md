---
type: capsule
date: 2026.07.02
realm: Market Value
mission: Have a strong online presence
quest: Keep a meaningful guisho.com
move: Redesign guisho.com into Essays / Research / Photos
capsule: Redesign guisho.com — 5 design directions
session_type: build
status: new
tool: Claude Code
location: quest-keep-a-meaningful-guisho-com
tags:
  - capsule
---

# Redesign guisho.com — 5 design directions

## Intent
Reshape guisho.com from a blog-centric site into a three-section identity — **Essays** (the existing ~700 posts), **Research** (knowledge-base style, categorical, modeled on rywalker.com/research), **Photos** (Instagram-like grid from real site images) — while keeping Speaking/About/talk-materials as first-class citizens. Produce 5 distinct live Hugo prototypes on a non-live branch, built on real content, so the winner can be judged against actual data.

## Done
Final paths/artifacts created or changed. Terse — one or two lines.

- Branch `redesign/three-sections`: 5 complete theme prototypes in `themes/rd{1-5}-*` (sketchbook, monograph, darkroom, triptych, index), all builds verified green with real content.
- Shared scaffolding: `content/research/` (5 collections fed by `collection_categories` taxonomy), `content/pages/{essays,photos}/index.md` (layouts `essays`/`photos`), 6-item menu in `hugo.yaml`, `scripts/preview-designs.sh` runner.

## Decisions / Findings
- Deliverable form: live Hugo prototypes (not static mockups) — what you see is what ships.
- Old sections (Speaking, About, /c/ materials): may fold into the three, but remain first-class citizens.
- Photos section uses actual images already on the site (guisho-media / assets/uploads mirror), no placeholders.
- All work on a new branch; deploys only trigger on push to `main`.
- Content was NOT moved: Essays/Photos are template-driven filters over `content/posts/` (`Type not in / in (image, gallery)`); Research collections pull posts via category taxonomy union. Fully reversible.
- ROUND 2 content-model change (Luis): Photos = `travel` category (561 posts, 484 with usable covers); Essays = every other category (~226); Research = native documents, seeded with 3 dummy docs (agentic-cx-stack, hugo-static-architectures, km-for-agents) — the 5 category-driven collection stubs were deleted. All 5 themes updated via resumed agents; verified green, photo grids identical at 484 imgs, 0 ZgotmplZ.
- Data fixes found during round 2: broken covers repaired in chiloe.md/curanto.md (`/guisho.com` prefix), the-offspring.md (local path → S3, plus category typo `tavel`→`travel`), atitlan-2.md (dead `blob:` cover removed).
- Round 3 (rd2-monograph finalist iterations): Photos renamed **Postcards** (/postcards/, alias /photos/ → needs CloudFront 301 at deploy); single-column plate feed mirroring single pages; gated family album /viajes/fam (password panajachel, SHA-256 client-side gate, robots.txt+noindex+list:never; dia-museo-israel gated individually, dia-regreso-a-tel-aviv published); Tags in menu + dense chip index at /tag/; category index + excerpts + tags on essays TOC; hamburger mobile nav; LF pressmark in colophon; type scale now 1.35rem/88ch body, 78ch content.
- Content recategorizations (all URL-stable, no redirects needed): 3 viaje-usa posts `p`→travel; monterrico tech→travel; 10 picture-only posts (feliz-navidad ×2, sancho, pinos, el-buki, duolingo, ready-set-go, linux-my-good-boy, de-regreso, no-se-por-que) +travel keeping original cats. Postcards 498 · Essays 211. The `p` category (8 left) and 43 draft posts remain to triage.
- The "43 missing posts" mystery SOLVED: they're `draft: "true"` (string) from WP migration — intentional drafts, not a bug.
- Round 4: per-post categories on indexes (ink) + tags (crimson) via shared terms-line partial; term pages get full monograph TOC treatment; collection-aware prev/next nav on posts; format cleanup fleet reflowed 82 post bodies (litanies → line-per-sentence e.g. grande-es-el-hombre 16 paras, Desiderata, Cabral monologues; prose blobs → 2-4-sentence paragraphs; 2 posts un-code-blocked from 4-space indents). Global audit: 107 posts modified, ZERO body-token changes, zero unexpected frontmatter changes, build green.
- Known content debt for later: fused sentences with no space ("Belen.Temprano"), flattened comparison table in estrategia-de-oceano-azul, SEO-spam tails in singleton-pattern + espanol-espanol, mid-word break in el-viejo-de-los-proyectos ("e / l alma") — all need character-level edits, deliberately out of scope for the whitespace-only pass.
- Photo grids use remote S3 `cover.image` URLs directly — no Hugo image processing, no dependence on the gitignored 3.5 GB `assets/uploads/` mirror.
- Preview: `./scripts/preview-designs.sh` serves all 5 on ports 1314–1318 (rd1→1314 … rd5→1318); `preview-designs.sh rd3` serves one on 1313; `stop` kills all.

## Next
- FINALISTS (Luis, 2026-07-02): rd2-monograph (1315) and rd4-triptych (1317). rd2's Photos being reworked into Instagram-story cards (9:16, text attached over gradient — the current guisho.com card feel, monograph-ified).
- Luis compares the two finalists after the rd2 photos rework; then pick or hybridize.
- Decide whether Speaking folds into Research or stays standalone in the winning design.
- Backfill `cover.image` on the ~77 travel posts missing one, if Photos becomes a hero section.
- Data-integrity mystery: ~43 of 789 post files never reach Hugo's RegularPages (checked: not drafts, not future-dated, only 1 duplicate url). Pre-existing on main; worth a dedicated debug session.
- Category cleanup: `Tech` vs `tech`, `Lo que opino sobre` vs slug variant; decide whether `travel` gets renamed for display.
- Winning theme: accessibility + mobile pass, then decide migration path (replace guisho-blog vs. evolve it).
- Nothing committed yet — branch has all work as untracked/modified files; commit when direction chosen (or immediately to preserve).

## Rejected
Ideas considered and not adopted, with a one-line reason each. Future-self reads this to avoid re-litigating settled trade-offs.

- Static HTML mockups for the 5 directions — user wants full-blown Hugo, viewable via `hugo server`.
- Placeholder photos for the Photos section — real site images exist and should drive the design.

## References
- https://rywalker.com/research — reference for the Research section (categorical clustering, profiles + reading time, tag navigation, no chronological stream)

## Deploy (2026-07-02)
DEPLOYED TO PRODUCTION. Commits ca3fec0 (content) + 5435383 (redesign) + 9e513e5 (go-live) merged to main, GitHub Actions run succeeded, verified live: all new sections 200, /photos/→/postcards/ redirect live, /category/tavel/ redirect live, legacy pagination URLs alive (no-op paginators, size 5), gated album live with robots.txt Disallow /viajes/, dia-museo-israel gated. Zero-404 method: full URL-inventory diff between a build of old main and the new build → 0 missing files before push.

## Search (2026-07-03)
Pagefind front-end search added (NOT yet deployed — local test at :1313). How it works: post-build indexer crawls the built HTML, only elements with `data-pagefind-body` (single.html non-gated articles + research singles = 759 docs); writes chunked compressed index under /pagefind/ (4.2MB total, queries lazy-fetch ~10-50KB via WASM ranking). Gated family content verified absent by decompressing fragments. /search/ page rebuilt (monograph-skinned PagefindUI, crimson highlights); inline search-box partial embedded on home + essays + postcards + research + term pages + tag index. Deploy workflow gained `npx -y pagefind --site public` step. Local test build/serve: hugo build → npx pagefind → python http.server (hugo server alone lacks the index).

## Search deployed (2026-07-03)
Search + Mermaid SHIPPED (commits d4fcae7, f7838ad; both runs green; verified live). Live index: 760 docs. Research doc "search-without-a-server" live, expanded per Luis's [] directives (Fuse.js history, drawbacks/when-not-to-use, 1450+ words), listed in BOTH Research and Essays via `show_in_essays: true` frontmatter flag (essays.html + home union it in — reusable for future crossovers). Mermaid: codeblock render hook (at BOTH layouts/_default/_markup/ and layouts/_markup/ — local Hugo 0.153 vs CI 0.163 resolve differently), conditional jsdelivr ESM loader only on diagram pages, monograph-themed.
Debug lessons: (1) Luis's live nvim buffer overwrote an agent edit — check for .swp / ask for :e! when a shared file reverts; (2) CloudFront invalidation lags ~1-3 min — don't trust immediate post-deploy curls; (3) rtk grep -c gave false zeros — verify with python when a count looks wrong.
CI warnings for later: `languageCode`→`locale` deprecation (removal pending in future Hugo), missing home JSON template (index.json — old PaperMod search artifact, decide to add or drop the JSON output).

## Related posts + image slimming (2026-07-03)
SHIPPED (commit 3208477): Hugo built-in Related (tags 100/categories 40/same-year date 10, threshold 20); "See Also" block with plate thumbnails on all post + research singles; template tops up from same collection to guarantee >=5 (verified 749/750; gated post excluded by design). Postcards "no photo" root cause: 85 covers were 2-13MB originals -> resized to 1600px/~300KB from local assets/uploads mirror, uploaded to guisho-media as -1600w variants (originals kept), cover.image frontmatter rewritten. Lesson repeated: CloudFront edge lag ~100s post-invalidation before verification curls tell the truth.

## Nav fix + full image slimming (2026-07-03, later)
SHIPPED: (1) prev/next was reversed — Hugo Pages.Next walks toward the FRONT of a date-desc collection (newer); swapped + commented in single.html. (2) Image slimming complete in 3 passes: 85 feed covers + 105 sitewide covers + 544 inline body images (120 posts), all >1MB resized to 1600px/q82 -1600w variants on guisho-media (originals kept; plain link targets untouched for click-to-original). Zero displayed images >1MB site-wide, verified in built HTML. Resize source: local assets/uploads mirror; upload needs `aws login` (root creds, session expires). Watch content-type on non-JPEG uploads when using s3 sync --content-type.

## Analytics restored (2026-07-08)
SHIPPED (commit 0da5208): the rd2-monograph theme switch silently dropped Google Analytics — hugo.yaml still had `googleAnalytics: G-BP9H7RES8M` but the new baseof.html never rendered it (old guisho-blog theme emitted it via a `google-analytics.html` partial in its head). Copied the partial into rd2-monograph, wired into baseof head. Verified in build: all 1842 rendered pages tagged; the 498 without are alias redirect stubs + the static Decap /admin/ page (expected). Verified live on home/essays/post. Lesson: when swapping themes, diff the old head partials for third-party integrations (analytics, verification metas, comments) — config params do nothing unless the theme renders them.

## Resume Note
2026-07-02: All 5 prototypes built and verified on branch `redesign/three-sections` (uncommitted at session end — check `git status`). Run `./scripts/preview-designs.sh` and open localhost:1314–1318 to compare: rd1-sketchbook (hand-drawn magazine, closest to current identity), rd2-monograph (literary print/book TOC), rd3-darkroom (photo-first dark), rd4-triptych (three color-coded expanding panels), rd5-index (rywalker-style research-lab dashboard). Content untouched — sections are template filters, so killing a design = deleting its theme dir. Waiting on Luis's pick; see Next for the follow-through list.
