---
type: capsule
date: 2026.04.27
realm: Market Value
mission: Have a strong online presence
quest: Keep a meaningful guisho.com
move: Clean current guisho.com implementation
capsule: Fix AI-First CX speaking link
session_type: fix
status: new
tool: Claude Code
location: quest-keep-a-meaningful-guisho-com
tags:
  - capsule
---

# Fix AI-First CX speaking link

## Intent
The speaking page link to "AI-First CX World Tour program" was returning 404 at `/speaking/ai-first-cx-world-tour`. Find the cause and ship a fix.

## Done
- Stripped invisible U+FFFC characters from `content/pages/speaking/AI-First CX World Tour program.md` frontmatter (broken YAML).
- Moved file out of the `speaking/` leaf bundle into its own leaf bundle: `content/pages/ai-first-cx-world-tour/index.md` with `url: /speaking/ai-first-cx-world-tour/`. Updated link target in `content/pages/speaking/index.md`.
- Pushed (commit `088f3fb`).

## Decisions / Findings
- **Two stacked bugs.** The U+FFFC fix alone wasn't enough — the file lived inside the `speaking/` leaf bundle (which already has its own `index.md`), so Hugo treated it as a page resource of that bundle, not a renderable page. Moving it to a sibling bundle is the actual fix.
- **U+FFFC detection.** Pasted-from-Obsidian frontmatter can carry invisible `￼` (U+FFFC, "object replacement") characters that silently break YAML. Detect with `hexdump -C file.md | head` and look for `ef bf bc` bytes. Fix with `sed -i 's/\xef\xbf\xbc//g' file.md`.
- **Leaf bundle hierarchy is load-bearing.** Sibling talk pages (kcdc-2025, kmworld-2025, gartner-2025) all live as their own leaf bundles under `content/pages/` and use `url:` to map into `/speaking/<slug>/`. The `speaking/` bundle is just the curated list page.

## Next
- (None outstanding — fix deployed and verified live.)

## Rejected
- **Fix the YAML and leave the file in `speaking/`.** Wouldn't have rendered anyway because of the leaf-bundle-resource trap.
- **Use a `_index.md` branch bundle for `speaking/`.** Hugo would render the list template instead of the curated content; not what we want.

## References
- Commit `088f3fb` — "Move AI-First CX World Tour to its own leaf bundle"
- Project memory: `~/.claude/projects/-home-luis-projects-guisho-com-vault/memory/speaking.md`

## Resume Note
The broken `/speaking/ai-first-cx-world-tour` link was caused by two stacked issues: invisible U+FFFC chars in YAML frontmatter, and the .md file living inside the `speaking/` leaf bundle (page-resource trap). Both gotchas are documented in the speaking memory. Page now lives at `content/pages/ai-first-cx-world-tour/index.md` and renders cleanly.
