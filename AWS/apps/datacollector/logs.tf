# Logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.environment}/${var.project_name}/${var.app_name}"
  retention_in_days = 7
}

