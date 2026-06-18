# AWS Glue Data Transformation Pipeline

A production-ready AWS Glue pipeline for processing data with proper configuration management, error handling, and monitoring.

## 📋 Project Structure

```
.
├── scripts/                       # Glue job scripts
│   └── aws_glue_Script_1.py      # Main Glue job to deploy & execute
├── config/                        # Configuration files
│   ├── config.yaml               # Base configuration
│   ├── dev.yaml                  # Development environment
│   └── prod.yaml                 # Production environment
├── terraform/                     # Infrastructure as Code
│   ├── main.tf                   # Glue job and resources
│   ├── variables.tf              # Terraform variables
│   ├── outputs.tf                # Terraform outputs
│   └── terraform.tfvars.example  # Example variables file
├── logs/                          # Job logs directory
├── requirements.txt               # Python dependencies
├── .gitignore                     # Git ignore file
└── README.md                      # This file
```

## 🚀 Quick Start

### Prerequisites

- Python 3.9+
- AWS Account with appropriate permissions
- AWS CLI configured
- Terraform (for infrastructure deployment)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd glue-pipeline
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

## 📝 Configuration

### Environment-Specific Configuration

Configuration is managed through YAML files:

- **`config/config.yaml`** - Base configuration (shared across environments)
- **`config/dev.yaml`** - Development environment overrides
- **`config/prod.yaml`** - Production environment overrides

### Key Configuration Parameters

```yaml
s3:
  input_path: "s3://bucket/input/"
  output_path: "s3://bucket/output/"
  
glue:
  job_name: "data-transformation-pipeline"
  worker_type: "G.2X"
  number_of_workers: 2
  timeout: 2880  # minutes
  
processing:
  input_format: "csv"
  output_format: "parquet"
  partition_columns: ["country", "date"]
```

## 🏗️ Pipeline Components

### 1. **Main Glue Job** (`scripts/aws_glue_Script_1.py`)

The main job script that is deployed to AWS Glue and executed:
- Reads data from S3 (configured in config.yaml)
- Performs data transformations
- Writes results to S3 output location
- Handles errors and logging

## 📦 Deployment

### Step 1: Update Configuration

Edit `config/dev.yaml` or `config/prod.yaml` with your S3 paths and settings:
```bash
nano config/dev.yaml
```

### Step 2: Deploy to AWS Using Terraform

```bash
cd terraform
terraform init
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform apply
```

### Step 3: Run the Job

The AWS Glue job will read the configuration from `config/dev.yaml` or `config/prod.yaml` and execute `scripts/aws_glue_Script_1.py`

```bash
# Trigger job via AWS Console or AWS CLI
aws glue start-job-run --job-name glue-pipeline-dev
```
```

2. **Create variables file**
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

3. **Plan and apply**
```bash
terraform plan
terraform apply
```

## 📊 Monitoring

### CloudWatch Logs
- Logs are written to CloudWatch Log Group: `/aws-glue/{job-name}`
- Accessible via AWS Console or CLI

### Job Monitoring
```bash
aws glue get-job-run \
  --job-name "data-transformation-pipeline" \
  --run-id "jr_XXXXX"
```

### Alerts
- SNS topic configured for job failures
- Email notifications sent on failure/timeout

## 🔧 Advanced Configuration

### Spark Performance Tuning

```yaml
spark:
  sql_shuffle_partitions: 200
  default_parallelism: 200
  max_partition_bytes: 134217728
  shuffle_compress: true
```

### Error Handling

```yaml
error_handling:
  enable_logging: true
  log_level: "INFO"
  notify_on_failure: true
  sns_topic_arn: "arn:aws:sns:..."
```

## 📚 Data Flow

```
S3 Input
   ↓
Read CSV
   ↓
Data Quality Checks
   ↓
Remove Duplicates
   ↓
Clean Strings
   ↓
Handle Nulls
   ↓
Type Casting
   ↓
Business Logic Transformations
   ↓
Add Metadata
   ↓
Write Parquet (Partitioned)
   ↓
S3 Output
```

## 🛡️ Best Practices

1. **Configuration Management**
   - Never commit sensitive data
   - Use environment variables for secrets
   - Keep configs in version control

2. **Error Handling**
   - All functions have try-catch blocks
   - Detailed error logging
   - Graceful failure with notifications

3. **Data Quality**
   - Validate input data schema
   - Check for empty datasets
   - Log transformation statistics

4. **Performance**
   - Partition data appropriately
   - Use job bookmarks for incremental processing
   - Monitor resource utilization

5. **Security**
   - Use IAM roles for job execution
   - Encrypt data in transit and at rest
   - Enable S3 versioning

## 🐛 Troubleshooting

### Job Fails to Start
```bash
# Check IAM role permissions
aws iam get-role --role-name GlueServiceRole

# Check S3 access
aws s3 ls s3://your-bucket/
```

### Insufficient Resources
- Increase `number_of_workers`
- Change `worker_type` to larger instance (G.2X, G.3X)
- Increase `timeout` value

### Data Not Found
- Verify S3 paths in configuration
- Check data format and schema
- Ensure input bucket exists

## 📖 Documentation

- [AWS Glue Documentation](https://docs.aws.amazon.com/glue/)
- [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

- **Name**: bhagyashri
- **Email**: admin@example.com

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Contact the project maintainers
- Check CloudWatch logs for job execution details

---

**Last Updated**: 2026-06-18