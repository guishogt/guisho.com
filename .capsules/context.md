---
type: capsule-context
realm: Market Value
mission: Have a strong online presence
quest: Keep a meaningful guisho.com
move: Clean current guisho.com implementation
tags:
  - capsule-context
---

# Project context

- **Realm**: Market Value
- **Mission**: Have a strong online presence
- **Quest**: Keep a meaningful guisho.com
- **Move**: Clean current guisho.com implementation

## Notes

guisho.com is the personal site (Hugo, S3, CloudFront, Decap CMS). It carries Luis's writing, speaking talks/materials, and professional bio. Edited primarily through this Obsidian vault clone of the GitHub repo.

Boundary with adjacent work:
- guisho-media S3 bucket holds image media (3.5 GB). This repo holds code + markdown only. A local mirror lives at `assets/uploads/` and is gitignored.
- Conference proposal drafting and Obsidian note-taking are upstream of what lands here.
- Anything client/employer-related (VML, BMC, etc.) belongs in their own projects, not this one.

Success looks like:
- Consistent, current speaking page with materials handouts
- Posts continue to flow without friction (CMS edits or direct vault edits)
- Theme stays maintainable (small, custom, hand-drawn aesthetic on Tailwind)
- Deploy stays simple: push → GitHub Actions → S3 sync → CloudFront invalidation
