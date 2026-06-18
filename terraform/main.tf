# AWS Glue Job Resource

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

## Explicit resources for two scripts (no loops).
## Script blocks are created only when the corresponding variable is non-empty.

# Script 1 upload
resource "aws_s3_object" "glue_script_1" {
  bucket = var.s3_output_bucket
  key    = "scripts/aws_glue_Script_1.py"
  source = "../scripts/aws_glue_Script_1.py"
  tags   = var.tags
}


# Glue job for script 1
resource "aws_glue_job" "data_transformation_1" {
  name              = "${var.script_1}-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  timeout           = var.job_timeout
  max_retries       = var.max_retries

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_output_bucket}/scripts/aws_glue_Script_1.py"
    python_version  = "3.9"
  }

  default_arguments = {
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--enable-glue-datacatalog"    = "false"
    "--enable-spark-ui"            = "false"
    "--spark-event-logs-path"      = "s3://${var.s3_output_bucket}/logs/"
    "--TempDir"                    = "s3://${var.s3_output_bucket}/temp/"
    "--S3_INPUT_PATH"              = "s3://${var.s3_input_bucket}/input/"
    "--S3_OUTPUT_PATH"             = "s3://${var.s3_output_bucket}/output/"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = var.tags

  depends_on = [aws_s3_object.glue_script_1]
}

# Script 2 upload
resource "aws_s3_object" "glue_script_2" {
  bucket = var.s3_output_bucket
  key    = "scripts/aws_glue_Script_2.py"
  source = "../scripts/aws_glue_Script_2.py"
  tags   = var.tags
}

# Glue job for script 2
resource "aws_glue_job" "data_transformation_2" {
  name              = "${var.script_2}-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  timeout           = var.job_timeout
  max_retries       = var.max_retries

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_output_bucket}/scripts/aws_glue_Script_2.py"
    python_version  = "3.9"
  }

  default_arguments = {
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--enable-glue-datacatalog"    = "false"
    "--enable-spark-ui"            = "false"
    "--spark-event-logs-path"      = "s3://${var.s3_output_bucket}/logs/"
    "--TempDir"                    = "s3://${var.s3_output_bucket}/temp/"
    "--S3_INPUT_PATH"              = "s3://${var.s3_input_bucket}/input/"
    "--S3_OUTPUT_PATH"             = "s3://${var.s3_output_bucket}/output/"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = var.tags

  depends_on = [aws_s3_object.glue_script_2]
}