# Guisho.com Deployment Guide

## Architecture Overview

```
GitHub (code) ──> AWS Amplify (auto-deploy, SSL, CDN) ──> guisho.com
                                                              │
Local (images) ──────────────────> S3 (guisho-media) ─────────┘
```

- **Website files**: Stored in GitHub, auto-deployed via AWS Amplify
- **Images/Media**: Stored in S3 bucket `guisho-media` (3.5GB, too large for Git)
- **CDN/SSL**: Handled automatically by Amplify

## Current Status

| Component | Status | URL/Details |
|-----------|--------|-------------|
| GitHub Repo | Done | github.com/guishogt/guisho.com |
| S3 Media Bucket | Done | guisho-media.s3.amazonaws.com |
| AWS Amplify | Done | main.d1a77te62cconr.amplifyapp.com |
| Route53 DNS | TODO | Point guisho.com → Amplify |
| CMS OAuth | TODO | Needed for /admin/ to work |
| Cloudinary | TODO | Needed for CMS image uploads |

---

## Part 1: S3 Bucket for Images/Media

Since images are excluded from Git (3.5GB), they need to be uploaded directly to S3.

### Step 1.1: Create S3 Bucket for Media

1. Go to **AWS Console → S3**
2. Click **Create bucket**
3. Configuration:
   - **Bucket name**: `guisho-media` (or `media.guisho.com` if you want subdomain)
   - **Region**: `us-east-1` (required for CloudFront)
   - **Object Ownership**: ACLs disabled
   - **Block Public Access**: UNCHECK "Block all public access" (we need public read)
   - Check the acknowledgment box
4. Click **Create bucket**

### Step 1.2: Configure Bucket Policy for Public Read

1. Go to your bucket → **Permissions** tab
2. Scroll to **Bucket policy** → Click **Edit**
3. Paste this policy (replace `guisho-media` with your bucket name):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::guisho-media/*"
        }
    ]
}
```

4. Click **Save changes**

### Step 1.3: Upload Images to S3

**Option A: AWS Console (for small uploads)**
1. Go to your bucket
2. Click **Upload**
3. Drag and drop folders from `assets/uploads/`
4. Click **Upload**

**Option B: AWS CLI (recommended for 3.5GB)**

First, install AWS CLI if not installed:
```bash
# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# macOS
brew install awscli
```

Configure credentials:
```bash
aws configure
# Enter your Access Key ID
# Enter your Secret Access Key
# Region: us-east-1
# Output format: json
```

Upload images:
```bash
# From the Hugo project directory
cd /home/luis/migrations/guisho.com/generated-2026-02-21-11-30-18

# Sync all uploads to S3 (preserves folder structure)
aws s3 sync assets/uploads/ s3://guisho-media/uploads/ --acl public-read

# This will show progress and upload ~3.5GB
```

### Step 1.4: Verify Upload

After upload, images will be accessible at:
```
https://guisho-media.s3.amazonaws.com/uploads/2017/11/IMG_1849.jpg
```

Or with CloudFront (configured later):
```
https://media.guisho.com/uploads/2017/11/IMG_1849.jpg
```

---

## Part 2: AWS Amplify Setup (Done)

Amplify replaces S3 website hosting + CloudFront + GitHub Actions.

### Step 2.1: Create Amplify App

1. Go to **AWS Console → Amplify**
2. Click **"Host web app"** → Select **GitHub**
3. Authorize and select repo: `guishogt/guisho.com`
4. Branch: `main`

### Step 2.2: Build Settings

```yaml
version: 1
frontend:
  phases:
    build:
      commands:
        - hugo --minify
  artifacts:
    baseDirectory: public
    files:
      - '**/*'
```

### Step 2.3: Result

- **Amplify URL**: https://main.d1a77te62cconr.amplifyapp.com
- Auto-deploys on every push to `main`
- SSL included automatically

---

## Part 3: Route53 DNS Configuration (TODO)

### Step 3.1: Add Custom Domain in Amplify

1. Go to **Amplify → guisho.com app → Domain management**
2. Click **Add domain**
3. Enter: `guisho.com`
4. Amplify will provide DNS records to add

### Step 3.2: Update Route53

1. Go to **Route53 → Hosted zones → guisho.com**
2. Add the records Amplify provides (usually CNAME or ALIAS)

---

## Part 5: Update Hugo Configuration for S3 Media

Since images are in S3, you need to update image URLs in your content.

### Option A: Use CloudFront URL for Media

If you set up a separate CloudFront distribution for media bucket:

1. Update `hugo.yaml`:
```yaml
params:
  mediaURL: https://media.guisho.com
```

2. In templates, reference images as:
```html
{{ with .Params.cover.image }}
  <img src="{{ site.Params.mediaURL }}{{ . }}" />
{{ end }}
```

### Option B: Use S3 Direct URL

Simpler option - just use S3 URLs directly:
```yaml
params:
  mediaURL: https://guisho-media.s3.amazonaws.com
```

### Updating Existing Posts

If your posts reference `/uploads/2017/...`, you have two options:

1. **Search and replace** in all markdown files:
```bash
# Find files with upload references
grep -r "/uploads/" content/posts/ | head -20

# Replace with S3 URL (be careful, test first)
find content/posts -name "*.md" -exec sed -i 's|/uploads/|https://guisho-media.s3.amazonaws.com/uploads/|g' {} \;
```

2. **Use Hugo's baseURL** for uploads by creating a redirect or using CloudFront behaviors.

---

## Part 4: Quick Reference Commands

### Upload images to S3
```bash
aws s3 sync assets/uploads/ s3://guisho-media/uploads/
```

### Check S3 bucket size
```bash
aws s3 ls s3://guisho-media --recursive --summarize | tail -2
```

### Invalidate CloudFront cache
```bash
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

### Test Hugo build locally
```bash
hugo server -D
```

### Build for production
```bash
hugo --minify
```

---

## Estimated Costs

| Service | Estimated Monthly Cost |
|---------|----------------------|
| Amplify (build + hosting) | Free tier: 1000 min/month |
| S3 (media ~3.5GB) | $0.08 |
| Route53 | $0.50 |
| **Total** | **~$1-2/month** |

---

## Troubleshooting

### Images not loading
1. Check bucket policy allows public read
2. Verify image URLs in posts match S3 path
3. Check CloudFront distribution is deployed (status: Deployed)

### 403 Forbidden on website
1. Check S3 bucket policy
2. Verify CloudFront OAC/OAI is configured
3. Check default root object is set to `index.html`

### DNS not resolving
1. Route53 changes can take up to 48 hours
2. Clear local DNS cache: `sudo systemd-resolve --flush-caches`
3. Verify A record points to CloudFront distribution

### GitHub Actions failing
1. Check AWS credentials are correct in GitHub secrets
2. Verify IAM user has S3 and CloudFront permissions
3. Check CloudFront distribution ID is correct

---

## Part 8: Decap CMS Setup (Admin Panel)

The CMS is available at `https://guisho.com/admin/` for editing content.

### Media Handling

Since images are stored in S3 (not Git), the CMS uses **Cloudinary** for new media uploads.

**Why Cloudinary?**
- Decap CMS can't upload directly to S3
- Cloudinary offers 25GB free storage
- Automatic image optimization and CDN
- Native integration with Decap CMS

### Step 8.1: Create Cloudinary Account

1. Go to [cloudinary.com](https://cloudinary.com/) and sign up (free)
2. After signup, go to **Dashboard**
3. Note your:
   - **Cloud name**: (e.g., `guisho`)
   - **API Key**: (e.g., `123456789012345`)

### Step 8.2: Update CMS Configuration

Edit `static/admin/config.yml`:

```yaml
media_library:
  name: cloudinary
  config:
    cloud_name: YOUR_CLOUD_NAME  # From dashboard
    api_key: YOUR_API_KEY        # From dashboard
```

### Step 8.3: GitHub OAuth Setup

For the CMS to commit to GitHub, you need OAuth:

**Option A: Use a third-party OAuth provider**

1. Go to [Netlify](https://app.netlify.com/) and create a free account
2. Create a new site from Git (connect your repo)
3. Go to **Site settings → Identity → Enable Git Gateway**
4. This provides OAuth without running your own server

**Option B: Self-hosted OAuth (advanced)**

If you want to avoid Netlify:
1. Deploy an OAuth server (e.g., [netlify-cms-oauth-provider-node](https://github.com/vencax/netlify-cms-github-oauth-provider))
2. Update `config.yml`:
```yaml
backend:
  name: github
  repo: guishogt/guisho.com
  branch: main
  base_url: https://your-oauth-server.com
  auth_endpoint: /auth
```

### Media Strategy Summary

| Media Type | Storage | Access URL |
|------------|---------|------------|
| **Existing images** (3.5GB) | S3 `guisho-media` | `https://guisho-media.s3.amazonaws.com/uploads/...` |
| **New uploads via CMS** | Cloudinary | `https://res.cloudinary.com/guisho/...` |

---

## Part 9: Deployment Checklist

### Before Going Live

- [ ] Create S3 bucket for website (`guisho.com`)
- [ ] Create S3 bucket for media (`guisho-media`)
- [ ] Upload existing images to S3 media bucket
- [ ] Update image URLs in posts to use S3
- [ ] Create CloudFront distribution
- [ ] Configure SSL certificate in CloudFront
- [ ] Update Route53 DNS records
- [ ] Create IAM user for GitHub Actions
- [ ] Add AWS secrets to GitHub repo
- [ ] Create GitHub Actions workflow
- [ ] Push code to GitHub
- [ ] Set up Cloudinary account
- [ ] Update CMS config with Cloudinary credentials
- [ ] Test CMS login and media upload

### Post-Launch

- [ ] Verify all pages load correctly
- [ ] Test image loading from S3
- [ ] Test CMS login at `/admin/`
- [ ] Create a test post with image upload
- [ ] Verify HTTPS redirect works
- [ ] Set up Google Analytics verification
