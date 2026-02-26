# Obsidian Workflow for guisho.com

## Quick Start

1. Create new file in `content/posts/` (e.g., `My New Article.md`)
2. `Cmd+P` → "Templater: Insert template" → `new-post`
3. **IMPORTANT:** If you see `<% tp.file.title %>` instead of actual values, run:
   `Cmd+P` → "Templater: Replace templates in the active file"
4. Fill in `categories` and `tags`
5. Write content, paste images
6. Delete `draft: true` line when ready
7. Commit + push → auto-deploys

> **WARNING:** If template syntax (`<% ... %>`) is not replaced with actual values, Hugo will crash. Always verify the frontmatter shows real values before running Hugo.

---

## What's Automatic

### Template Auto-fills:
| Field | Value |
|-------|-------|
| `title` | From filename (e.g., "My New Article") |
| `date` | Current timestamp |
| `author` | "guisho" |
| `url` | From filename, lowercased & hyphenated (e.g., `/my-new-article/`) |
| `draft` | "true" (remove to publish) |

### Hugo Auto-detects:
| Feature | How it works |
|---------|--------------|
| **Cover image** | First image in your post becomes the cover |
| **Reading time** | Calculated from content length |
| **Summary** | First paragraph or manual `summary:` in frontmatter |

---

## What You Fill In

### Required:
- **`categories`** - Pick at least one:
  - `travel`
  - `tech`
  - `software-engineering`
  - `software-business`
  - `strategy`
  - `mis-escritos`
  - `mi-literatura`
  - `personas-lugares-cosas-sucesos`
  - `ayudas-para-el-camino`
  - `lo-que-opino-sobre`
  - `standing-in-the-shoulder-of-giants`

### Optional:
- **`tags`** - Add specific tags for the post
- **`summary`** - Custom summary (otherwise uses first paragraph)
- **`cover.image`** - Override auto-detected cover with specific URL

---

## Image Workflow

1. **Paste or drag** an image into your post
2. S3 Image Uploader automatically:
   - Uploads to `guisho-media` S3 bucket
   - Inserts markdown: `![](https://guisho-media.s3.amazonaws.com/uploads/2026/02/image.jpg)`
3. **First image** in post = automatic cover image (no config needed)

### If you want a specific cover:
Add to frontmatter:
```yaml
cover:
  image: https://guisho-media.s3.amazonaws.com/uploads/2026/02/specific-image.jpg
```

---

## Publishing

### Option 1: Obsidian Git (recommended)
1. Delete `draft: "true"` from frontmatter
2. `Cmd+P` → "Obsidian Git: Commit all changes"
3. Enter commit message (e.g., "New post: Article Title")
4. `Cmd+P` → "Obsidian Git: Push"

### Option 2: Terminal
```bash
cd /path/to/guisho.com-vault
git add .
git commit -m "New post: Article Title"
git push
```

GitHub Actions will automatically build and deploy to guisho.com.

---

## Example Post

**Filename:** `Pacaya Siempre Espectaculo.md`

```markdown
---
title: "Pacaya Siempre Espectaculo"
date: "2026-02-26T10:30:00+00:00"
author: guisho
categories:
  - travel
tags:
  - guatemala
  - volcanes
url: /pacaya-siempre-espectaculo/
draft: "true"
---

El volcán Pacaya nunca decepciona...

![](https://guisho-media.s3.amazonaws.com/uploads/2026/02/pacaya-sunset.jpg)

Cada vez que subo, la experiencia es diferente.
```

**Result:**
- URL: `https://guisho.com/pacaya-siempre-espectaculo/`
- Cover: `pacaya-sunset.jpg` (auto-detected from content)
- Category page: `https://guisho.com/category/travel/`

---

## Tips

- **Filename = URL**: Choose descriptive filenames
- **First image = Cover**: Put your best image first
- **Draft mode**: Keep `draft: "true"` until ready, Hugo won't publish it
- **Preview locally**: Run `hugo server -D` to preview drafts
