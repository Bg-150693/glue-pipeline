# AWS Secrets required for GitHub Actions deployment

# Add these secrets to your GitHub repository:
# 
# Settings > Secrets and variables > Actions > New repository secret
#
# Required secrets::
# - AWS_ACCESS_KEY_ID: AWS access key for deployment
# - AWS_SECRET_ACCESS_KEY: AWS secret access key
# - AWS_REGION: AWS region (e.g., us-east-1)
# - S3_INPUT_BUCKET: S3 input bucket name
# - S3_OUTPUT_BUCKET: S3 output bucket name  
# - GLUE_ROLE_ARN: ARN of Glue service role
#
# Optional secrets:
# - SLACK_WEBHOOK_URL: Slack webhook for notifications
# - SNS_TOPIC_ARN: SNS topic for failure alerts

# GitHub Environment Protection Rules:
# Settings > Environments > Create environment "aws-production"
# Add required reviewers for deployments
