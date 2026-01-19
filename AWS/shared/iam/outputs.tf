output "ecs_exec_role_arn" {
  description = "The ARN of the role used by the ECS agent to pull images and push logs"
  value       = aws_iam_role.ecs_exec_role.arn
}

output "ecs_task_role_arn" {
  description = "The ARN of the role used by the application code to access S3, Rekognition, etc."
  value       = aws_iam_role.ecs_task_role.arn
}

output "data_collector_instance_profile_name" {
  value = aws_iam_instance_profile.data_collector.name
}
