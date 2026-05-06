# Guisho.com Architecture

## Overview

Guisho.com is a static blog built with Hugo, hosted on AWS, with a headless CMS for content management.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CONTENT CREATION                                │
│                                                                              │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐                │
│   │   Author     │────▶│  Decap CMS   │────▶│   GitHub     │                │
│   │  (Browser)   │     │  (/admin/)   │     │    Repo      │                │
│   └──────────────┘     └──────────────┘     └──────────────┘                │
│                              │                      │                        │
│                              │ images               │ code push              │
│                              ▼                      ▼                        │
│                        ┌──────────┐          ┌──────────────┐               │
│                        │    S3    │          │   GitHub     │               │
│                        │ (media)  │          │   Actions    │               │
│                        └──────────┘          └──────────────┘               │
│                                                     │                        │
│                                                     │ hugo build             │
│                                                     ▼                        │
│                                              ┌──────────────┐               │
│                                              │      S3      │               │
│                                              │  (website)   │               │
│                                              └──────────────┘               │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              CONTENT DELIVERY                                │
│                                                                              │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────────────────┐   │
│   │   Visitor    │────▶│  CloudFront  │────▶│  S3 (website + media)    │   │
│   │  (Browser)   │     │     CDN      │     │  Lambda (API endpoints)  │   │
│   └──────────────┘     └──────────────┘     └──────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Components

### 1. Hugo (Static Site Generator)

**Purpose**: Converts Markdown content into static HTML files.

**Location**: Source code in GitHub repository

**Key Files**:
- `content/posts/*.md` - Blog posts in Markdown
- `themes/guisho-blog/` - Custom theme with layouts
- `hugo.yaml` - Site configuration

**Build Process**:
```
Markdown + Templates → Hugo → Static HTML/CSS/JS
```

---

### 2. GitHub Repository

**Purpose**: Version control for all source code and content.

**Repository**: `github.com/guishogt/guisho.com`

**What's Stored**:
- Hugo source files (templates, config)
- Content (Markdown posts)
- Lambda function code
- CMS configuration
- Deployment workflows

**What's NOT Stored**:
- Images (too large, stored in S3)
- Build artifacts (generated on deploy)

---

### 3. GitHub Actions

**Purpose**: Automated build and deployment pipeline.

**Trigger**: Push to `main` branch

**Workflow** (`.github/workflows/deploy.yml`):
```
1. Checkout code
2. Install Hugo
3. Build site (hugo --minify)
4. Sync to S3 (excluding /uploads/)
5. Invalidate CloudFront cache
```

**Credentials**: AWS IAM user `guisho-github-deploy` with limited permissions.

---

### 4. S3 Buckets

#### guisho.com (Website)
- **Purpose**: Hosts the static website files
- **Contents**: HTML, CSS, JS from Hugo build
- **Access**: Public read via CloudFront
- **Updated by**: GitHub Actions

#### guisho-media (Images)
- **Purpose**: Stores all images and media files
- **Contents**: ~3.5GB of images in `/uploads/YYYY/MM/` structure
- **Access**: Public read via CloudFront
- **Updated by**: Decap CMS (direct upload)

---

### 5. CloudFront (CDN)

**Purpose**: Global content delivery, SSL termination, caching.

**Distribution ID**: `E1E71K2HUK1HID`

**How Routing Works**:

```
Request URL                    → Origin
─────────────────────────────────────────────────
guisho.com/                    → S3 (guisho.com)
guisho.com/posts/hello/        → S3 (guisho.com)
guisho.com/uploads/2024/img.jpg → S3 (guisho-media)
guisho.com/api/auth            → Lambda (OAuth)
guisho.com/api/s3-upload       → Lambda (Upload)
```

**Cache Behaviors**:
| Path | TTL | Purpose |
|------|-----|---------|
| `/uploads/*` | 1 year | Images rarely change |
| `/api/*` | 0 (no cache) | Dynamic API endpoints |
| `*` (default) | 24 hours | HTML/CSS/JS |

---

### 6. Lambda Functions

#### guisho-cms-oauth

**Purpose**: Handles GitHub OAuth authentication for the CMS.

**Flow**:
```
1. CMS opens popup → /api/auth
2. Lambda redirects → github.com/login/oauth/authorize
3. User authorizes on GitHub
4. GitHub redirects → /api/auth/callback?code=xxx
5. Lambda exchanges code for access token
6. Lambda verifies user is in ALLOWED_USERS
7. Lambda redirects → /admin/callback.html#token=xxx
8. Callback page sends token to CMS via postMessage
9. CMS stores token and user is logged in
```

**Security**: Only users listed in `ALLOWED_USERS` array can log in.

#### guisho-cms-s3-upload

**Purpose**: Generates presigned URLs for direct S3 uploads.

**Flow**:
```
1. User selects image in CMS
2. CMS widget calls /api/s3-upload with filename
3. Lambda generates presigned PUT URL (valid 5 minutes)
4. Lambda returns URL to browser
5. Browser uploads directly to S3 using presigned URL
6. CMS saves image path in post frontmatter
```

**Why Presigned URLs?**
- Browser can't have AWS credentials
- Presigned URLs allow temporary, limited access
- Upload goes directly to S3 (no Lambda in data path)

---

### 7. Decap CMS

**Purpose**: Web-based content management interface.

**URL**: `https://guisho.com/admin/`

**Components**:
- `index.html` - Loads Decap CMS from CDN
- `config.yml` - Defines content structure and backend
- `callback.html` - Handles OAuth callback
- `s3-widget.js` - Custom widget for S3 image uploads

**How It Works**:
1. Author visits `/admin/` and logs in via GitHub
2. CMS fetches content from GitHub API
3. Author edits posts in browser
4. On save, CMS commits changes to GitHub
5. GitHub Actions deploys the changes

---

## Data Flows

### Creating a New Post

```
┌────────┐    ┌─────────┐    ┌────────┐    ┌─────────┐    ┌────┐
│ Author │───▶│  Decap  │───▶│ GitHub │───▶│ Actions │───▶│ S3 │
│        │    │   CMS   │    │  API   │    │  Build  │    │    │
└────────┘    └─────────┘    └────────┘    └─────────┘    └────┘
     │
     │ (if includes image)
     ▼
┌─────────┐    ┌────────┐    ┌─────────────┐
│ Browser │───▶│ Lambda │───▶│ S3 (media)  │
│ Upload  │    │ presign│    │ direct PUT  │
└─────────┘    └────────┘    └─────────────┘
```

### Viewing the Site

```
┌─────────┐    ┌────────────┐    ┌─────────────────┐
│ Visitor │───▶│ CloudFront │───▶│ S3 (cached)     │
│ Browser │    │    Edge    │    │ or origin fetch │
└─────────┘    └────────────┘    └─────────────────┘
```

### OAuth Login Flow

```
┌────────┐    ┌───────┐    ┌────────┐    ┌────────┐
│  CMS   │───▶│Lambda │───▶│ GitHub │───▶│ Lambda │
│ popup  │    │ /auth │    │ OAuth  │    │callback│
└────────┘    └───────┘    └────────┘    └────────┘
                                              │
                                              ▼
                                        ┌──────────┐
                                        │ Validate │
                                        │   user   │
                                        └──────────┘
                                              │
              ┌────────┐    ┌──────────┐      │
              │  CMS   │◀───│ callback │◀─────┘
              │ logged │    │  .html   │
              │   in   │    │postMessage
              └────────┘    └──────────┘
```

---

## Security

### Access Control

| Resource | Who Can Access |
|----------|----------------|
| Website (read) | Everyone (public) |
| CMS login | Only `ALLOWED_USERS` in Lambda |
| GitHub repo | Collaborators |
| AWS resources | IAM users with permissions |

### Credentials Storage

| Secret | Location |
|--------|----------|
| GitHub OAuth App secrets | Lambda environment variables |
| AWS deploy credentials | GitHub Secrets |
| GitHub personal access token | Generated per-session via OAuth |

### Lambda Permissions

| Lambda | Permissions |
|--------|-------------|
| guisho-cms-oauth | None (only makes HTTPS requests) |
| guisho-cms-s3-upload | s3:PutObject on guisho-media bucket |

---

## Cost Breakdown

| Service | What For | Est. Monthly |
|---------|----------|--------------|
| S3 | Website + 4GB media storage | $0.10 |
| CloudFront | CDN, ~100GB transfer | $1-5 |
| Lambda | OAuth + presigned URLs | Free tier |
| Route53 | DNS hosting | $0.50 |
| **Total** | | **$2-6** |

---

## Why This Architecture?

### Separation of Code and Media
- **Problem**: 3.5GB of images is too large for Git
- **Solution**: Images in S3, code in GitHub
- **Benefit**: Fast Git operations, no LFS needed

### Static Site + CMS
- **Problem**: Need easy editing without technical knowledge
- **Solution**: Decap CMS provides UI, commits to Git
- **Benefit**: Best of both worlds - static performance with CMS convenience

### Serverless
- **Problem**: Don't want to manage servers
- **Solution**: S3 + CloudFront + Lambda
- **Benefit**: No maintenance, scales automatically, cheap

### Direct S3 Uploads
- **Problem**: Lambda has 6MB payload limit, images can be larger
- **Solution**: Presigned URLs let browser upload directly to S3
- **Benefit**: No size limits, faster uploads, Lambda only generates URL

---

## Extending the System

### Adding a New Admin User
Edit `lambda/oauth/index.js`:
```javascript
const ALLOWED_USERS = ['guishogt', 'newuser'];
```
Then redeploy the Lambda.

### Adding New Content Types
Edit `static/admin/config.yml` and add to `collections`.

### Custom Domain for Media
1. Create CloudFront distribution for guisho-media
2. Add CNAME record: `media.guisho.com → CloudFront`
3. Update `public_folder` in CMS config

### Adding Search
Hugo doesn't have built-in search. Options:
1. Algolia (hosted search)
2. Lunr.js (client-side, build index at deploy)
3. Pagefind (static search index)
