# AWS Glue Pipeline Terraform Variables

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws_glue_Script_1"
}

# When you prefer explicit resources, set these two variables to the script
# filenames you want deployed. Leave empty string to disable.
variable "script_1" {
  description = "First script filename to deploy (e.g. aws_glue_Script_1.py)"
  type        = string
  default     = "aws_glue_Script_1.py"
}

variable "script_2" {
  description = "Second script filename to deploy (e.g. test.py). Empty = disabled"
  type        = string
  default     = "aws_glue_Script_2.py"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "glue_version" {
  description = "AWS Glue version"
  type        = string
  default     = "4.0"
}

variable "worker_type" {
  description = "Glue job worker type"
  type        = string
  default     = "G.1X"
}

variable "number_of_workers" {
  description = "Number of workers"
  type        = number
  default     = 2
}

variable "job_timeout" {
  description = "Job timeout in minutes"
  type        = number
  default     = 5
}

variable "max_retries" {
  description = "Maximum number of retries"
  type        = number
  default     = 1
}

variable "s3_input_bucket" {
  description = "S3 input bucket name"
  type        = string
}

variable "s3_output_bucket" {
  description = "S3 output bucket name"
  type        = string
}

variable "glue_role_arn" {
  description = "IAM role ARN for Glue service"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "glue-pipeline"
  }
}
