resource "aws_s3_bucket" "data_storage" {
  bucket = lower("${var.environment}-${var.project_name}")
}