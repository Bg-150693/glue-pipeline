# Output values from Terraform

output "glue_job_1_name" {
  description = "Name of the first Glue job"
  value       = aws_glue_job.data_transformation_1.name
}

output "glue_job_1_arn" {
  description = "ARN of the first Glue job"
  value       = aws_glue_job.data_transformation_1.arn
}

output "glue_job_1_worker_config" {
  description = "Worker configuration used for Job 1"
  value       = "Workers: ${aws_glue_job.data_transformation_1.number_of_workers} x ${aws_glue_job.data_transformation_1.worker_type}, Timeout: ${aws_glue_job.data_transformation_1.timeout} min"
}

output "glue_job_2_name" {
  description = "Name of the second Glue job"
  value       = aws_glue_job.data_transformation_2.name
}

output "glue_job_2_arn" {
  description = "ARN of the second Glue job"
  value       = aws_glue_job.data_transformation_2.arn
}

output "glue_job_2_worker_config" {
  description = "Worker configuration used for Job 2"
  value       = "Workers: ${aws_glue_job.data_transformation_2.number_of_workers} x ${aws_glue_job.data_transformation_2.worker_type}, Timeout: ${aws_glue_job.data_transformation_2.timeout} min"
}

output "script_1_location" {
  description = "S3 location of first Glue script"
  value       = "s3://${var.s3_output_bucket}/scripts/${var.script_1}"
}

output "script_2_location" {
  description = "S3 location of second Glue script"
  value       = "s3://${var.s3_output_bucket}/scripts/${var.script_2}"
}

output "config_location" {
  description = "S3 location of environment config file"
  value       = "s3://${var.s3_output_bucket}/config/${var.environment}.yaml"
}

output "environment_deployed" {
  description = "Environment that was deployed"
  value       = var.environment
}

output "s3_input_path" {
  description = "S3 input path from config"
  value       = "s3://datalakebg-${var.environment}/input/raw_data/"
}

output "s3_output_path" {
  description = "S3 output path from config"
  value       = "s3://datalakebg-${var.environment}/output/res_output/"
}