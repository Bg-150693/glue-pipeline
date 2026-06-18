# Output values from Terraform

output "glue_job_1_name" {
  description = "Name of the first Glue job"
  value       = aws_glue_job.data_transformation_1.name
}

output "glue_job_1_arn" {
  description = "ARN of the first Glue job"
  value       = aws_glue_job.data_transformation_1.arn
}

output "glue_job_2_name" {
  description = "Name of the second Glue job"
  value       = aws_glue_job.data_transformation_2.name
}

output "glue_job_2_arn" {
  description = "ARN of the second Glue job"
  value       = aws_glue_job.data_transformation_2.arn
}

output "script_1_location" {
  description = "S3 location of first Glue script"
  value       = "s3://${var.s3_output_bucket}/scripts/${var.script_1}"
}

output "script_2_location" {
  description = "S3 location of second Glue script"
  value       = "s3://${var.s3_output_bucket}/scripts/${var.script_2}"
}