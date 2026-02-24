# Guisho.com Deployment Guide

## Architecture Overview

```
GitHub (code) ──> GitHub Actions ──> S3 (website) ──> CloudFront ──> guisho.com
                                           │
Local (images) ──────────────────> S3 (media) ──────────┘
```

- **Website files**: Stored in GitHub, deployed via GitHub Actions to S3
- **Images/Media**: Stored directly in S3 (3.5GB, too large for Git)
- **CDN**: CloudFront serves both website and media with HTTPS

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

## Part 2: S3 Bucket for Website

### Step 2.1: Create Website Bucket

1. Go to **AWS Console → S3**
2. Click **Create bucket**
3. Configuration:
   - **Bucket name**: `guisho.com`
   - **Region**: `us-east-1`
   - **Object Ownership**: ACLs disabled
   - **Block Public Access**: UNCHECK "Block all public access"
4. Click **Create bucket**

### Step 2.2: Enable Static Website Hosting

1. Go to bucket → **Properties** tab
2. Scroll to **Static website hosting** → Click **Edit**
3. Configuration:
   - **Static website hosting**: Enable
   - **Hosting type**: Host a static website
   - **Index document**: `index.html`
   - **Error document**: `404.html`
4. Click **Save changes**

### Step 2.3: Add Bucket Policy

Same as media bucket - go to **Permissions** → **Bucket policy**:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::guisho.com/*"
        }
    ]
}
```

---

## Part 3: CloudFront Distribution

### Step 3.1: Create Distribution for Website

1. Go to **AWS Console → CloudFront**
2. Click **Create distribution**
3. **Origin settings**:
   - **Origin domain**: Select your S3 bucket `guisho.com.s3.amazonaws.com`
   - **Origin path**: Leave empty
   - **S3 bucket access**: Yes, use OAC (or legacy OAI)
4. **Default cache behavior**:
   - **Viewer protocol policy**: Redirect HTTP to HTTPS
   - **Allowed HTTP methods**: GET, HEAD
   - **Cache policy**: CachingOptimized
5. **Settings**:
   - **Alternate domain name (CNAME)**: `guisho.com` and `www.guisho.com`
   - **Custom SSL certificate**: Select your existing ACM certificate
   - **Default root object**: `index.html`
6. Click **Create distribution**

### Step 3.2: Note the Distribution Domain

After creation, note the distribution domain name:
```
d1234567890.cloudfront.net
```

You'll need this for Route53.

---

## Part 4: Route53 DNS Configuration

### Step 4.1: Create/Update A Records

1. Go to **AWS Console → Route53 → Hosted zones**
2. Select `guisho.com`
3. Create record for root domain:
   - **Record name**: (leave empty for root)
   - **Record type**: A
   - **Alias**: Yes
   - **Route traffic to**: CloudFront distribution
   - Select your distribution
4. Create record for www:
   - **Record name**: `www`
   - **Record type**: A
   - **Alias**: Yes
   - **Route traffic to**: CloudFront distribution

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

## Part 6: GitHub Actions Deployment

### Step 6.1: Create IAM User for GitHub Actions

1. Go to **AWS Console → IAM → Users**
2. Click **Create user**
3. **User name**: `github-actions-guisho`
4. Click **Next**
5. **Attach policies directly**:
   - Search and select `AmazonS3FullAccess`
   - Search and select `CloudFrontFullAccess`
6. Click **Create user**
7. Click on the user → **Security credentials** tab
8. Click **Create access key**
9. Select **Application running outside AWS**
10. Copy the **Access Key ID** and **Secret Access Key**

### Step 6.2: Add Secrets to GitHub

1. Go to your GitHub repo → **Settings** → **Secrets and variables** → **Actions**
2. Add these secrets:
   - `AWS_ACCESS_KEY_ID`: Your access key
   - `AWS_SECRET_ACCESS_KEY`: Your secret key
   - `CLOUDFRONT_DISTRIBUTION_ID`: Your distribution ID (e.g., `E1234567890ABC`)

### Step 6.3: Create GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: hugo --minify

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to S3
        run: aws s3 sync public/ s3://guisho.com --delete

      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"
```

---

## Part 7: Quick Reference Commands

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
| S3 (website ~50MB) | $0.01 |
| S3 (media ~3.5GB) | $0.08 |
| CloudFront | $1-5 (depends on traffic) |
| Route53 | $0.50 |
| **Total** | **~$2-6/month** |

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
