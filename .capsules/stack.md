---
type: capsule-stack
project: quest-keep-a-meaningful-guisho-com
tags:
  - capsule-stack
---

# Stack — quest-keep-a-meaningful-guisho-com

Operational brief. Read this before changing anything that runs.

## Where it lives

- **Source**: `/home/luis/projects/guisho.com-vault/` (also reachable via `~/projects/quest-keep-a-meaningful-guisho-com/` symlink)
- **Git remote**: `git@github.com:guishogt/guisho.com.git` (branch `main`)
- **Server / hosting**: AWS — S3 (`guisho.com` website bucket, `guisho-media` image bucket), CloudFront distribution `E1E71K2HUK1HID`, two Lambda functions (`guisho-cms-oauth`, `guisho-cms-s3-upload`)
- **Domains / URLs**: production `https://guisho.com`, CMS at `https://guisho.com/admin/`

## Runtime

- **Site generator**: Hugo (extended) — config at `hugo.yaml`
- **Theme**: `themes/guisho-blog/` (custom, Tailwind via CDN, hand-drawn aesthetic)
- **Lambda runtime**: Node.js — sources under `lambda/oauth/` and `lambda/s3-upload/`
- **Build / start commands**: `hugo --quiet` (build), `hugo server` (local dev on port 1313)

## Credentials

Never paste secrets here. Just point to where they live.

- **AWS deploy creds**: GitHub repository secrets (used by `.github/workflows/deploy.yml`)
- **GitHub OAuth (CMS)**: stored as Lambda env vars on `guisho-cms-oauth` (`GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`)
- **CMS allowlist**: hardcoded in `lambda/oauth/index.js` `ALLOWED_USERS` array

## External services

- **S3 (`guisho.com`)**: served as static website, public read via CloudFront
- **S3 (`guisho-media`)**: image storage, `/uploads/YYYY/MM/` layout
- **GitHub Actions**: builds Hugo, syncs `public/` to `s3://guisho.com/` (excluding `/uploads/`), invalidates CloudFront
- **Decap CMS** (at `/admin/`): GitHub-backed, posts commits via OAuth, image uploads via presigned-URL Lambda

## Known errors and resolutions

- **Symptom**: A standalone page returns 404 even though the markdown file exists.
  - **Cause**: The `.md` file is placed inside another leaf bundle (e.g. `content/pages/speaking/<page>.md`). Hugo treats it as a page resource of the bundle, not as its own renderable page.
  - **Fix**: Move it to its own leaf bundle: `content/pages/<slug>/index.md` with `url: /speaking/<slug>/` (or wherever).

- **Symptom**: Hugo logs no error but a page's frontmatter doesn't seem to take effect (URL not honored, etc.).
  - **Cause**: Invisible U+FFFC ("object replacement") characters in YAML — typically from copy-paste in Obsidian.
  - **Detection**: `hexdump -C file.md | head` and look for `ef bf bc` bytes.
  - **Fix**: `sed -i 's/\xef\xbf\xbc//g' file.md`.

- **Symptom**: Hero image renders twice (cover + inline).
  - **Cause**: Page sets `cover.image` AND embeds the same image in body.
  - **Fix**: Either drop `cover.image` (rely on inline only) OR set top-level `feature_image: false` to suppress just the hero. Both `get-cover-image.html` and `header.html` honor the flag.

## Deploy / rollback

- **Deploy**: `git push origin main` → GitHub Actions runs `hugo --minify` → `aws s3 sync` → CloudFront invalidation. Watch with `gh run list --limit 1`.
- **Rollback**: revert the offending commit on `main` and push; the same workflow re-syncs S3.
- **Lambda redeploys**: `cd lambda && ./deploy.sh` (requires `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` in env).

## Local development

- **Setup**: clone, install Hugo extended, run `hugo server`. No Node deps required for the site itself (Lambdas have their own `package.json`).
- **Dev URL**: http://localhost:1313/
- **Common gotchas**:
  - Do NOT place `.md` files inside `content/pages/speaking/` — they get treated as page resources. Use sibling leaf bundles under `content/pages/`.
  - Materials/handout pages use the `/c/<slug>/` URL pattern via `content/pages/c-<slug>/index.md`.
  - Hugo build output `public/` is gitignored. CloudFront cache may take ~1 min to propagate.
