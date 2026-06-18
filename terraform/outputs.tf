# Output values from Terraform

output "glue_job_name" {
  description = "Name of the created Glue job"
  value       = aws_glue_job.data_transformation.name
}

output "glue_job_arn" {
  description = "ARN of the created Glue job"
  value       = aws_glue_job.data_transformation.arn
}

output "script_location" {
  description = "S3 location of Glue script"
  value       = "s3://${var.s3_output_bucket}/scripts/aws_glue_Script_1.py"
}
