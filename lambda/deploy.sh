#!/bin/bash
set -e

# Configuration
REGION="us-east-1"
OAUTH_FUNCTION_NAME="guisho-cms-oauth"
S3_UPLOAD_FUNCTION_NAME="guisho-cms-s3-upload"
API_NAME="guisho-cms-api"
S3_BUCKET="guisho-media"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Deploying Decap CMS Lambda Functions ===${NC}\n"

# Check for required environment variables
if [ -z "$GITHUB_CLIENT_ID" ] || [ -z "$GITHUB_CLIENT_SECRET" ]; then
    echo -e "${RED}Error: Please set GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET${NC}"
    echo "Example:"
    echo "  export GITHUB_CLIENT_ID='your-client-id'"
    echo "  export GITHUB_CLIENT_SECRET='your-client-secret'"
    exit 1
fi

# Create IAM role for Lambda (if doesn't exist)
echo "Creating IAM role..."
ROLE_NAME="guisho-cms-lambda-role"

aws iam get-role --role-name $ROLE_NAME 2>/dev/null || \
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {"Service": "lambda.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }]
    }' \
    --region $REGION

# Attach policies
aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole 2>/dev/null || true

# Create S3 policy for upload function
cat > /tmp/s3-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": ["s3:PutObject"],
        "Resource": "arn:aws:s3:::${S3_BUCKET}/*"
    }]
}
EOF

aws iam put-role-policy \
    --role-name $ROLE_NAME \
    --policy-name guisho-s3-upload-policy \
    --policy-document file:///tmp/s3-policy.json

ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text)
echo -e "${GREEN}Role ARN: $ROLE_ARN${NC}"

# Wait for role to propagate
echo "Waiting for role to propagate..."
sleep 10

# Deploy OAuth Lambda
echo -e "\n${YELLOW}Deploying OAuth Lambda...${NC}"
cd oauth
zip -r function.zip index.js
aws lambda create-function \
    --function-name $OAUTH_FUNCTION_NAME \
    --runtime nodejs18.x \
    --handler index.handler \
    --role $ROLE_ARN \
    --zip-file fileb://function.zip \
    --environment "Variables={GITHUB_CLIENT_ID=$GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET=$GITHUB_CLIENT_SECRET,REDIRECT_URI=https://guisho.com/api/auth/callback}" \
    --region $REGION 2>/dev/null || \
aws lambda update-function-code \
    --function-name $OAUTH_FUNCTION_NAME \
    --zip-file fileb://function.zip \
    --region $REGION
rm function.zip
cd ..

# Deploy S3 Upload Lambda
echo -e "\n${YELLOW}Deploying S3 Upload Lambda...${NC}"
cd s3-upload
npm install --production
zip -r function.zip index.js node_modules
aws lambda create-function \
    --function-name $S3_UPLOAD_FUNCTION_NAME \
    --runtime nodejs18.x \
    --handler index.handler \
    --role $ROLE_ARN \
    --zip-file fileb://function.zip \
    --environment "Variables={S3_BUCKET=$S3_BUCKET}" \
    --region $REGION 2>/dev/null || \
aws lambda update-function-code \
    --function-name $S3_UPLOAD_FUNCTION_NAME \
    --zip-file fileb://function.zip \
    --region $REGION
rm -rf function.zip node_modules
cd ..

# Create HTTP API Gateway
echo -e "\n${YELLOW}Creating API Gateway...${NC}"
API_ID=$(aws apigatewayv2 get-apis --region $REGION --query "Items[?Name=='$API_NAME'].ApiId" --output text)

if [ -z "$API_ID" ]; then
    API_ID=$(aws apigatewayv2 create-api \
        --name $API_NAME \
        --protocol-type HTTP \
        --cors-configuration "AllowOrigins=https://guisho.com,AllowMethods=GET,POST,OPTIONS,AllowHeaders=Content-Type,Authorization" \
        --region $REGION \
        --query 'ApiId' --output text)
    echo -e "${GREEN}Created API: $API_ID${NC}"
else
    echo -e "${GREEN}Using existing API: $API_ID${NC}"
fi

# Get Lambda ARNs
OAUTH_ARN=$(aws lambda get-function --function-name $OAUTH_FUNCTION_NAME --region $REGION --query 'Configuration.FunctionArn' --output text)
S3_UPLOAD_ARN=$(aws lambda get-function --function-name $S3_UPLOAD_FUNCTION_NAME --region $REGION --query 'Configuration.FunctionArn' --output text)

# Create integrations
echo "Creating integrations..."
OAUTH_INTEGRATION_ID=$(aws apigatewayv2 create-integration \
    --api-id $API_ID \
    --integration-type AWS_PROXY \
    --integration-uri $OAUTH_ARN \
    --payload-format-version 2.0 \
    --region $REGION \
    --query 'IntegrationId' --output text 2>/dev/null) || true

S3_INTEGRATION_ID=$(aws apigatewayv2 create-integration \
    --api-id $API_ID \
    --integration-type AWS_PROXY \
    --integration-uri $S3_UPLOAD_ARN \
    --payload-format-version 2.0 \
    --region $REGION \
    --query 'IntegrationId' --output text 2>/dev/null) || true

# Create routes
echo "Creating routes..."
aws apigatewayv2 create-route --api-id $API_ID --route-key "GET /api/auth" --target "integrations/$OAUTH_INTEGRATION_ID" --region $REGION 2>/dev/null || true
aws apigatewayv2 create-route --api-id $API_ID --route-key "GET /api/auth/callback" --target "integrations/$OAUTH_INTEGRATION_ID" --region $REGION 2>/dev/null || true
aws apigatewayv2 create-route --api-id $API_ID --route-key "POST /api/s3-upload" --target "integrations/$S3_INTEGRATION_ID" --region $REGION 2>/dev/null || true

# Add Lambda permissions
ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
aws lambda add-permission \
    --function-name $OAUTH_FUNCTION_NAME \
    --statement-id apigateway-invoke \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*" \
    --region $REGION 2>/dev/null || true

aws lambda add-permission \
    --function-name $S3_UPLOAD_FUNCTION_NAME \
    --statement-id apigateway-invoke \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*" \
    --region $REGION 2>/dev/null || true

# Create deployment
aws apigatewayv2 create-stage --api-id $API_ID --stage-name '$default' --auto-deploy --region $REGION 2>/dev/null || true

# Get the API endpoint
API_ENDPOINT=$(aws apigatewayv2 get-api --api-id $API_ID --region $REGION --query 'ApiEndpoint' --output text)

echo -e "\n${GREEN}=== Deployment Complete ===${NC}"
echo -e "API Endpoint: ${YELLOW}$API_ENDPOINT${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Add CloudFront behavior for /api/* pointing to this API"
echo "   - Or set up a custom domain for the API"
echo ""
echo "2. Update your GitHub OAuth App callback URL to:"
echo "   https://guisho.com/api/auth/callback"
echo ""
echo "3. Test at: https://guisho.com/admin/"
