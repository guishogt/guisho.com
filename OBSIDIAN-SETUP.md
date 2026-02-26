# Obsidian Setup Guide for guisho.com

This guide explains how to set up Obsidian to write and publish posts to guisho.com.

---

## Prerequisites

- Git installed and configured with GitHub access
- AWS CLI configured (for S3 image uploads)
- Obsidian installed

---

## 1. Clone the Repository

```bash
git clone git@github.com:guishogt/guisho.com.git guisho.com-vault
cd guisho.com-vault
```

---

## 2. Open as Obsidian Vault

1. Open Obsidian
2. Click "Open folder as vault"
3. Select the `guisho.com-vault` folder
4. Trust the vault when prompted

---

## 3. Install Community Plugins

Go to **Settings → Community plugins → Turn on community plugins**

Then click **Browse** and install these plugins:

### Required Plugins:

| Plugin | Purpose |
|--------|---------|
| **Templater** | Auto-fill frontmatter in new posts |
| **S3 Image Uploader** | Upload images directly to S3 |
| **Obsidian Git** | Commit and push from Obsidian |

Enable each plugin after installing.

---

## 4. Configure Templater

**Settings → Templater:**

| Setting | Value |
|---------|-------|
| Template folder location | `_templates` |
| Trigger Templater on new file creation | OFF (optional) |

---

## 5. Configure S3 Image Uploader

**Settings → S3 Image Uploader:**

| Setting | Value |
|---------|-------|
| Access Key ID | `AKIA6B7AHVMAK53UKCEX` |
| Secret Access Key | *(see AWS credentials or ask admin)* |
| Region | `us-east-1` |
| Bucket | `guisho-media` |
| Folder | `uploads/2026/02` *(update monthly)* |
| Use custom image url | ON |
| Custom image url | `https://guisho-media.s3.amazonaws.com/` |
| Upload on drag | ON |
| Enable image compression | Your preference |

**Note:** Update the `Folder` value each month (e.g., `uploads/2026/03` for March).

### Getting AWS Credentials

If you need new credentials:
```bash
# Create IAM user (if not exists)
aws iam create-user --user-name obsidian-s3-uploader

# Create access key
aws iam create-access-key --user-name obsidian-s3-uploader
```

Or use existing credentials from the IAM user `obsidian-s3-uploader`.

---

## 6. Configure Obsidian Git

**Settings → Obsidian Git:**

| Setting | Recommended Value |
|---------|-------------------|
| Auto backup interval | 0 (manual only) |
| Auto pull interval | 0 (manual only) |
| Commit message | `{{hostname}}: {{numFiles}} files` |

### Usage:
- `Cmd+P` → "Obsidian Git: Commit all changes" → Enter message
- `Cmd+P` → "Obsidian Git: Push"

---

## 7. Configure Core Settings

**Settings → Editor:**
- Use markdown links: ON (not wikilinks)

**Settings → Files & Links:**
- Default location for new attachments: "In subfolder under current folder" or leave default

---

## How It Works

### Auto-Cover Image (Hugo)

The Hugo theme automatically uses the **first image in your post** as the cover image. No need to manually set `cover.image` in frontmatter.

**How it was implemented:**

Created `themes/guisho-blog/layouts/partials/get-cover-image.html`:
```go
{{- $cover := .Params.cover.image -}}
{{- if not $cover -}}
  {{- $match := findRE `https://guisho-media\.s3\.amazonaws\.com/[^)\s"]+\.(jpg|jpeg|png|gif|webp)` .RawContent 1 -}}
  {{- with $match -}}
    {{- $cover = index . 0 -}}
  {{- end -}}
{{- end -}}
{{- return $cover -}}
```

This partial:
1. Checks if `cover.image` is set in frontmatter
2. If not, extracts the first S3 image URL from the post content
3. Returns that as the cover image

Modified `layouts/_default/single.html` and `layouts/partials/article-card.html` to use this partial instead of directly reading `.Params.cover.image`.

### Template Auto-fill (Templater)

The template at `_templates/new-post.md` uses Templater syntax:

```markdown
---
title: "<% tp.file.title %>"
date: "<% tp.date.now("YYYY-MM-DDTHH:mm:ss") %>+00:00"
author: guisho
categories:
  -
tags:
  -
url: /<% tp.file.title.toLowerCase().replace(/\s+/g, '-') %>/
draft: "true"
---
```

- `tp.file.title` → Gets filename without extension
- `tp.date.now(...)` → Current timestamp
- The URL transform lowercases and replaces spaces with hyphens

### S3 Image Upload Flow

1. You paste/drag an image in Obsidian
2. S3 Image Uploader plugin:
   - Uploads to `s3://guisho-media/uploads/YYYY/MM/`
   - Inserts markdown: `![](https://guisho-media.s3.amazonaws.com/uploads/...)`
3. CloudFront serves images at `https://guisho.com/uploads/...`

### Deployment Flow

1. You commit and push from Obsidian Git
2. GitHub Actions triggers on push to `main`
3. Hugo builds the site
4. Syncs to S3 bucket `guisho.com`
5. Invalidates CloudFront cache
6. Site is live at https://guisho.com

---

## Troubleshooting

### Template not working
- Ensure Templater is installed and enabled
- Check template folder is set to `_templates`
- Restart Obsidian after config changes

### Hugo crashes with "invalid URL escape" error
This happens when Templater syntax (`<% tp.file.title %>`) wasn't executed and remains as literal text.

**Fix:**
1. Open the problematic file in Obsidian
2. `Cmd+P` → "Templater: Replace templates in the active file"
3. Verify frontmatter shows actual values (not `<% ... %>`)

**Find all affected files:**
```bash
grep -r "tp.file\|tp.date" content/
```

### Images not uploading
- Check S3 plugin credentials are correct
- Verify AWS region is `us-east-1`
- Check bucket name is `guisho-media`

### Git push failing
- Ensure you have GitHub SSH access: `ssh -T git@github.com`
- Check you're on the `main` branch

### Cover image not showing
- Ensure image URL starts with `https://guisho-media.s3.amazonaws.com/`
- Check image is the first one in the post content
- Test locally: `hugo server -D`

---

## File Structure

```
guisho.com-vault/
├── .obsidian/              # Obsidian config (gitignored)
│   └── plugins/
│       ├── templater-obsidian/
│       ├── s3-image-uploader/
│       └── obsidian-git/
├── _templates/
│   └── new-post.md         # Post template
├── content/
│   └── posts/              # Your articles go here
├── themes/
│   └── guisho-blog/
│       └── layouts/
│           └── partials/
│               └── get-cover-image.html  # Auto-cover logic
├── OBSIDIAN-SETUP.md       # This file
├── OBSIDIAN-WORKFLOW.md    # Daily workflow guide
└── DEPLOYMENT.md           # Full deployment docs
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| New post | Create file in `content/posts/`, insert template |
| Insert template | `Cmd+P` → "Templater: Insert template" |
| Execute template | `Cmd+P` → "Templater: Replace templates in the active file" |
| Commit changes | `Cmd+P` → "Obsidian Git: Commit all changes" |
| Push to GitHub | `Cmd+P` → "Obsidian Git: Push" |
| Pull latest | `Cmd+P` → "Obsidian Git: Pull" |
| Preview locally | `hugo server -D` in terminal |
