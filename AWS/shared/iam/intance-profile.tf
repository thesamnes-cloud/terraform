resource "aws_iam_instance_profile" "data_collector" {
  name = "${var.environment}-${var.project_name}-data-collector-profile"
  role = aws_iam_role.data_collector.name
}
