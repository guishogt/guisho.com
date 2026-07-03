# quest-keep-a-meaningful-guisho-com

Hugo source for [guisho.com](https://guisho.com). Edited via Obsidian (this folder is also the vault).

This project uses the **capsules** system for session logging. Before doing anything in this directory:

1. Read `.capsules/context.md` for the project's place in the Realm → Mission → Quest → Move hierarchy.
2. Read `.capsules/stack.md` — it has server location, credentials, runtime, and known errors.
3. Read the **most recent** file in `.capsules/capsules/` for where the last session left off. Pay attention to its **Resume Note**, **Next**, and **Rejected** sections.

Each session should produce a new capsule under `.capsules/capsules/` named `capsule-<slug>-YYYY-MM-DD.md`. Never edit a closed capsule — open a new one.

## Capsule lifecycle

- `new` capsules are created at session start (or end, depending on your style).
- Frontmatter dates use `YYYY.MM.DD` (dots); filenames use `YYYY-MM-DD` (dashes). Both must be correct.
- The Realm, Mission, Quest, and Move come from `.capsules/context.md` by default. Move can change between sibling capsules.

The `capsules` Claude Code skill handles all of this — invoke it with "create a capsule" or "/capsules".

## Site-specific docs

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — full system overview (Hugo, S3, CloudFront, Lambda, Decap CMS)
- [`DEPLOYMENT.md`](DEPLOYMENT.md) — deploy specifics
- [`OBSIDIAN-SETUP.md`](OBSIDIAN-SETUP.md), [`OBSIDIAN-WORKFLOW.md`](OBSIDIAN-WORKFLOW.md) — vault editing workflow
