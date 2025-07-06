output "s3_bucket" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}