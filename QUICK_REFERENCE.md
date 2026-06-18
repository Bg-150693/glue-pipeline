# 🚀 QUICK REFERENCE GUIDE

## Your Project Structure (Simplified)

```
my-public-repo/
├── scripts/aws_glue_Script_1.py       ← Your Glue job
├── config/
│   ├── config.yaml                    ← Base settings
│   ├── dev.yaml                       ← Dev settings
│   └── prod.yaml                      ← Prod settings
├── terraform/
│   ├── main.tf                        ← AWS resources
│   ├── variables.tf                   ← Variables
│   ├── outputs.tf                     ← Outputs
│   └── terraform.tfvars.example       ← Example
├── .github/workflows/
│   ├── tests.yml                      ← CI/CD tests
│   └── deploy.yml                     ← CI/CD deploy
└── README.md                          ← Documentation
```

---

## Key Changes Made

✅ **Terraform Files**: Updated to use `scripts/aws_glue_Script_1.py`  
✅ **CI/CD Workflows**: Updated to test and deploy scripts/ folder  
✅ **README.md**: Updated with new structure  
✅ **Documentation**: Created comprehensive guides  

---

## Common Tasks

### Edit Job Logic
```bash
nano scripts/aws_glue_Script_1.py
```

### Change Configuration
```bash
# Development settings
nano config/dev.yaml

# Production settings  
nano config/prod.yaml
```

### Deploy to AWS
```bash
cd terraform
terraform init
terraform apply
```

### Run Job
```bash
aws glue start-job-run --job-name glue-pipeline-dev
```

### Monitor Job
```bash
aws logs tail /aws-glue/glue-pipeline-dev --follow
```

---

## Configuration Files

**config/config.yaml** (All environments)
```yaml
glue:
  job_name: aws_glue_Script_1.py
  glue_version: "4.0"
  worker_type: "G.1X"
  number_of_workers: 2
```

**config/dev.yaml** (Development only)
```yaml
environment: dev
s3:
  input_bucket: datalakebg-dev
  output_path: s3://datalakebg-dev/output/
number_of_workers: 1  # Cheaper for dev
```

**config/prod.yaml** (Production only)
```yaml
environment: prod
s3:
  input_bucket: datalakebg-prod
  output_path: s3://datalakebg-prod/output/
number_of_workers: 10  # More workers for prod
```

---

## Terraform Variables

Create `terraform/terraform.tfvars`:
```hcl
environment         = "dev"
project_name        = "glue-pipeline"
aws_region          = "us-east-1"
glue_version        = "4.0"
worker_type         = "G.1X"
number_of_workers   = 2
job_timeout         = 2880
s3_output_bucket    = "my-bucket-name"
glue_service_role_arn = "arn:aws:iam::ACCOUNT_ID:role/glue-role"
```

---

## CI/CD Workflows

**tests.yml** runs on every push:
- Linting (flake8)
- Formatting (black)
- Type checking (mypy)
- Security scan (bandit)

**deploy.yml** runs on push to main:
- Uploads scripts/aws_glue_Script_1.py to S3
- Applies Terraform infrastructure
- Triggers Glue job

---

## Deployment Flow

```
1. Edit scripts/aws_glue_Script_1.py
            ↓
2. Git push to main
            ↓
3. GitHub Actions runs tests (tests.yml)
            ↓
4. GitHub Actions deploys (deploy.yml)
   ├─ Uploads script to S3
   ├─ Runs terraform apply
   └─ Job ready to execute
            ↓
5. Trigger job manually or via schedule
            ↓
6. Glue reads config/dev.yaml or config/prod.yaml
            ↓
7. Glue executes scripts/aws_glue_Script_1.py
```

---

## Important Files You'll Edit

| File | What It Does | Edit When |
|------|--------------|-----------|
| `scripts/aws_glue_Script_1.py` | Main job logic | Changing data processing |
| `config/dev.yaml` | Dev settings | Changing dev S3 paths, workers |
| `config/prod.yaml` | Prod settings | Changing prod S3 paths, workers |
| `terraform/terraform.tfvars` | AWS configuration | Changing AWS account details |
| `README.md` | Documentation | Updating docs |

---

## Before You Deploy

**Checklist**:
- [ ] `scripts/aws_glue_Script_1.py` is complete and tested
- [ ] `config/dev.yaml` has correct S3 paths
- [ ] `config/prod.yaml` has correct S3 paths
- [ ] `terraform/terraform.tfvars` has AWS account ID
- [ ] S3 buckets exist and are accessible
- [ ] IAM role has Glue permissions

---

## Troubleshooting

**Q: Terraform apply fails?**
A: Check `terraform/terraform.tfvars` has all required values

**Q: Glue job not found?**
A: Run `aws glue get-job --name glue-pipeline-dev`

**Q: Job fails to run?**
A: Check logs: `aws logs tail /aws-glue/glue-pipeline-dev --follow`

**Q: Configuration not loading?**
A: Verify `config/dev.yaml` or `config/prod.yaml` is correct

---

## Documentation

For more details, see:
- **README.md** - Main documentation
- **NEW_STRUCTURE.txt** - Detailed structure guide
- **STRUCTURE_UPDATE_SUMMARY.md** - Complete update guide
- **STRUCTURE_UPDATE_VERIFICATION.md** - Verification details

---

## Git Workflow

```bash
# Make changes to job or config
git add .
git commit -m "Update job logic"

# Push to main
git push origin main

# GitHub Actions automatically:
# 1. Runs tests (tests.yml)
# 2. Deploys infrastructure (deploy.yml)
# 3. Job is ready to execute
```

---

## Environment-Specific Execution

**Run on Dev**:
```bash
aws glue start-job-run --job-name glue-pipeline-dev
```

**Run on Prod**:
```bash
aws glue start-job-run --job-name glue-pipeline-prod
```

---

## Next Steps

1. **Review** your `scripts/aws_glue_Script_1.py` - ensure it's complete
2. **Update** `terraform/terraform.tfvars` with your AWS details
3. **Verify** S3 buckets and IAM roles are configured
4. **Deploy** with `terraform apply`
5. **Test** by running the job manually
6. **Monitor** via CloudWatch logs

---

**Version**: 2.0 (Simplified)  
**Status**: ✅ Ready to Deploy  
**Generated**: 2026-06-18
