---
type: capsule
date: 2026.05.04
realm: Market Value
mission: Have a strong online presence
quest: Keep a meaningful guisho.com
move: Clean current guisho.com implementation
capsule: KCDC materials and repo consolidation
session_type: build
status: new
tool: Claude Code
location: quest-keep-a-meaningful-guisho-com
tags:
  - capsule
---

# KCDC materials and repo consolidation

## Intent
Three threads:
1. Convert a downloaded HTML resource page (`Downloads/.../c/kcdc25.html`) into a Hugo materials page at `/c/kcdc25/`.
2. Add KMWorld and Gartner conference images that landed in `~/Downloads/conf_images/`.
3. Consolidate two redundant local clones of the repo (`guisho.com/` vs. `guisho.com-vault/`) into one source of truth.

## Done
- New leaf bundle `content/pages/c-kcdc25/` with `index.md` (markdown conversion of the HTML), `Dont-let-your-org-write-bad-code.pdf` colocated. URL: `/c/kcdc25/`. "(materials)" link added from `/speaking/` index and the `kcdc-2025` talk page (commit `4c59813`).
- KMWorld page: `kmworld_2.jpg` inline near top, `kmworld.png` at bottom under "As featured in the conference program." Gartner page: `gartner_executive.png` at bottom under "As featured in the program" (commit `171e9a0`).
- `themes/guisho-blog/layouts/partials/header.html` — added `(ne .Params.feature_image false)` guard to hero render so the opt-out flag is honored consistently with `get-cover-image.html` (commit `370d120`).
- Repo consolidated: salvaged `ARCHITECTURE.md`, `lambda/` (oauth + s3-upload Lambda source), `replace_urls.py` from stale `guisho.com/` clone into the vault (commit `bc3b39a`). Moved 3.5 GB `assets/uploads/` local image mirror into vault — already gitignored at line 35. Old `guisho.com/` clone moved to trash via `gio trash`.
- Updated `~/.claude/projects/-home-luis-projects-guisho-com-vault/memory/speaking.md` with the materials-page pattern, `feature_image: false` opt-out, conference-image workflow, AI-First CX talk in current talks, and gotchas from the prior week.
- Initialized capsules system: `~/projects/quest-keep-a-meaningful-guisho-com/` symlink, `.capsules/context.md`, `.capsules/stack.md`, project `README.md`.

## Decisions / Findings
- **Materials/handout pages live at `/c/<slug>/`.** Cleaner than nesting under `/speaking/<slug>/materials/`. Implemented via `content/pages/c-<slug>/index.md` with `url: /c/<slug>/`; assets colocated in the bundle so they publish at the same URL prefix.
- **Markdown conversion over preserving the original HTML look.** The downloaded page was custom dark Tailwind. Markdown + default theme styling fits the rest of guisho.com better and is maintainable.
- **`feature_image: false` opt-out must be checked in BOTH partials.** `get-cover-image.html` honored it but `header.html` was reading `.Params.cover.image` directly, so heroes still rendered. Fixed by mirroring the guard.
- **For KMWorld duplicate-image:** simpler to drop the `cover.image` than fight the flag — but fixed the flag anyway so future pages can keep a cover for OG metadata while suppressing the hero render.
- **Repo consolidation:** `guisho.com/` was significantly behind `guisho.com-vault/` (no speaking pages at all in its tracked history). Only valuable items were unstaged/untracked: an architecture doc, the actual Lambda source, and a one-off migration script. All salvaged. The 3.5 GB `assets/uploads/` is just a local mirror of the `guisho-media` S3 bucket — kept locally as a cache, gitignored, never to be committed.

## Next
- **Optional**: Write real content for the AI-First CX page (currently has "* Link here" placeholder).
- **Optional**: Decide whether `replace_urls.py` should stay in the repo as a historical artifact or be removed (already ran).
- Capsule for the next session.

## Rejected
- **Embedding the original dark Tailwind layout for `/c/kcdc25/`.** Inconsistent with the rest of guisho.com; markdown chosen instead.
- **Putting kcdc25 materials at `content/pages/speaking/kcdc25-materials/`.** Same leaf-bundle-resource trap as the AI-First CX bug from the previous week.
- **Committing `assets/uploads/`** (3.5 GB). Per ARCHITECTURE.md, S3 is canonical for media; git is for code + markdown only.
- **Renaming `guisho.com-vault/` to `quest-keep-a-meaningful-guisho-com/`** to match the capsules naming convention. Would break Obsidian workspace settings and any tools/scripts referencing the old path. A symlink at the project-anchor location achieves the same reachability without disruption.
- **Deleting old `guisho.com/` outright with `rm -rf`.** User asked for `gio trash` instead — recoverable from the desktop trash if anything turns out missing. The 2 GB `guisho.com_both_drives.zip` is also a fallback.

## References
- Commits: `4c59813` (kcdc materials), `171e9a0` (conference images), `370d120` (header.html flag fix), `bc3b39a` (repo consolidation salvage)
- Live URLs: `/c/kcdc25/`, `/speaking/kmworld-2025/`, `/speaking/gartner-2025/`
- `ARCHITECTURE.md` (now in repo) — system overview
- Memory: `~/.claude/projects/-home-luis-projects-guisho-com-vault/memory/speaking.md`
- Conference image drop folder: `~/Downloads/conf_images/`

## Resume Note
Vault is now the single source of truth for guisho.com. Old `guisho.com/` clone trashed; all unique files (ARCHITECTURE.md, Lambda source, migration script) salvaged into the repo. `assets/uploads/` (3.5 GB local mirror of `guisho-media` S3 bucket) lives in the vault but is gitignored — keep it as a local image cache; never commit. Theme `feature_image: false` opt-out now works in both partials. Conference handouts use `/c/<slug>/`; talks use `/speaking/<slug>/`. Capsules system initialized — `.capsules/context.md` + `.capsules/stack.md` are the operational brief, this is the second of two retrofit capsules covering the conversation.
