---
type: capsule
date: 2026.10.05
realm: Market Value
mission: Have a strong online presence
quest: Keep a meaningful guisho.com
move: Keep the speaking page current
capsule: Explore DDD 2026 speaking entry — publish, photos, newest-first list
session_type: build
status: new
tool: Claude Code
location: quest-keep-a-meaningful-guisho-com
tags:
  - capsule
---

# Explore DDD 2026 speaking entry — publish, photos, newest-first list

## Intent
Publish the Explore DDD 2026 talk page ("Strategic Design at Scale: DDD Patterns for Integration-Heavy Domains", Denver, Sep 23–25) that was drafted locally, tidy its photos, and make the Speaking list read newest first.

## Done
- `content/pages/explore-ddd-2026/` committed: page, slides PDF, four images.
- Photos: cover lightly cropped (ceiling clutter), book-signing cropped tighter on Luis + Eric Evans with a small lift, group photo trimmed of floor; all stripped of EXIF, q88. Title slide re-rendered from the PDF as a crisp 1600px PNG (was a soft 40 KB JPEG). Untouched originals kept at `~/Downloads/explore-ddd-2026-originals/`.
- `content/pages/speaking/index.md`: entries ordered most recent → oldest.

## Decisions / Findings
- Tried painting the EXIT sign out of the cover selfie; the patch read as a smudge over the banner. Reverted to an honest crop — no retouching of photos on the site.
- Auto-gamma + unsharp on backlit conference photos lifts blotchy artifacts in the blown projection screens; keep adjustments to a few points of brightness/contrast only.
- Same day: guisho.com's certificate had expired (Oct 4) because the old ACM cert also covered the lapsed plan91.com; new cert for guisho.com + *.guisho.com, plan91 aliases removed from the CloudFront distribution.

## Next
- Speaking page stays a hand-written list; a date-sorted section would remove the manual ordering.
