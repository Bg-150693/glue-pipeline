# AWS Glue Job Resource with Environment-Specific Configuration
#
# IMPORTANT: If you get "IdempotentParameterMismatchException: Job already submitted with different configuration"
# This means Glue jobs exist in AWS but Terraform state is out of sync.
# 
# SOLUTION: Import existing jobs into Terraform state first
# Run these commands BEFORE applying:
#   terraform import aws_glue_job.data_transformation_1 aws_glue_Script_1.py-dev
#   terraform import aws_glue_job.data_transformation_2 aws_glue_Script_2.py-dev
# (Replace 'dev' with your environment if different)
#
# Alternative: Refresh state and re-plan
#   terraform refresh
#   terraform plan
#   terraform apply

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ========== READ ENVIRONMENT-SPECIFIC CONFIG FILE ==========
locals {
  config_file = "../config/${var.environment}.yaml"
  config_data = yamldecode(file(local.config_file))
  
  # Extract values from config file (with fallbacks to variables)
  glue_version          = try(local.config_data.glue.glue_version, var.glue_version)
  worker_type           = try(local.config_data.glue.worker_type, var.worker_type)
  number_of_workers     = try(local.config_data.glue.number_of_workers, var.number_of_workers)
  job_timeout           = try(local.config_data.glue.timeout, var.job_timeout)
  max_retries           = try(local.config_data.glue.max_retries, var.max_retries)
  s3_input_path         = try(local.config_data.s3.input_path, "s3://${var.s3_input_bucket}/input/")
  s3_output_path        = try(local.config_data.s3.output_path, "s3://${var.s3_output_bucket}/output/")
  s3_logs_path          = try(local.config_data.s3.logs_path, "s3://${var.s3_output_bucket}/logs/")
}

# ========== SCRIPT 1 UPLOAD ==========
resource "aws_s3_object" "glue_script_1" {
  bucket = var.s3_output_bucket
  key    = "scripts/aws_glue_Script_1.py"
  source = "../scripts/aws_glue_Script_1.py"
  tags   = var.tags
}

# ========== GLUE JOB 1 (Uses config from dev.yaml, prod.yaml, etc.) ==========
resource "aws_glue_job" "data_transformation_1" {
  name              = "${var.script_1}-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = local.glue_version           # ← FROM CONFIG FILE
  worker_type       = local.worker_type            # ← FROM CONFIG FILE
  number_of_workers = local.number_of_workers      # ← FROM CONFIG FILE
  timeout           = local.job_timeout            # ← FROM CONFIG FILE
  max_retries       = local.max_retries            # ← FROM CONFIG FILE

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_output_bucket}/scripts/aws_glue_Script_1.py"
    python_version  = "3.9"
  }

  default_arguments = {
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--enable-glue-datacatalog"    = "false"
    "--enable-spark-ui"            = "false"
    "--spark-event-logs-path"      = local.s3_logs_path              # ← FROM CONFIG FILE
    "--TempDir"                    = "s3://${var.s3_output_bucket}/temp/"
    "--S3_INPUT_PATH"              = local.s3_input_path             # ← FROM CONFIG FILE
    "--S3_OUTPUT_PATH"             = local.s3_output_path            # ← FROM CONFIG FILE
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = var.tags

  depends_on = [aws_s3_object.glue_script_1]

  # Lifecycle: Update in-place instead of recreate to avoid IdempotentParameterMismatchException
  lifecycle {
    create_before_destroy = false
  }
}

# ========== SCRIPT 2 UPLOAD ==========
resource "aws_s3_object" "glue_script_2" {
  bucket = var.s3_output_bucket
  key    = "scripts/aws_glue_Script_2.py"
  source = "../scripts/aws_glue_Script_2.py"
  tags   = var.tags
}

# ========== GLUE JOB 2 (Uses config from dev.yaml, prod.yaml, etc.) ==========
resource "aws_glue_job" "data_transformation_2" {
  name              = "${var.script_2}-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = local.glue_version           # ← FROM CONFIG FILE
  worker_type       = local.worker_type            # ← FROM CONFIG FILE
  number_of_workers = local.number_of_workers      # ← FROM CONFIG FILE
  timeout           = local.job_timeout            # ← FROM CONFIG FILE
  max_retries       = local.max_retries            # ← FROM CONFIG FILE

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_output_bucket}/scripts/aws_glue_Script_2.py"
    python_version  = "3.9"
  }

  default_arguments = {
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--enable-glue-datacatalog"    = "false"
    "--enable-spark-ui"            = "false"
    "--spark-event-logs-path"      = local.s3_logs_path              # ← FROM CONFIG FILE
    "--TempDir"                    = "s3://${var.s3_output_bucket}/temp/"
    "--S3_INPUT_PATH"              = local.s3_input_path             # ← FROM CONFIG FILE
    "--S3_OUTPUT_PATH"             = local.s3_output_path            # ← FROM CONFIG FILE
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = var.tags

  depends_on = [aws_s3_object.glue_script_2]

  # Lifecycle: Update in-place instead of recreate to avoid IdempotentParameterMismatchException
  lifecycle {
    create_before_destroy = false
  }
}

# ========== UPLOAD CONFIG FILES TO S3 ==========
resource "aws_s3_object" "config_environment" {
  bucket = var.s3_output_bucket
  key    = "config/${var.environment}.yaml"
  source = "../config/${var.environment}.yaml"
  tags   = var.tags
}

resource "aws_s3_object" "config_base" {
  bucket = var.s3_output_bucket
  key    = "config/config.yaml"
  source = "../config/config.yaml"
  tags   = var.tags
}