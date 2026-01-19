resource "aws_ecr_repository" "repo" {
  name                 = lower("${var.environment}-${var.project_name}-${var.app_name}")
  image_tag_mutability = "MUTABLE" #Enables overriding the :latest tag

  image_scanning_configuration {
    scan_on_push = true
  }
}