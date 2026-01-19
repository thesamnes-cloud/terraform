resource "aws_vpc" "main" {
  cidr_block            = lookup(local.vpc_cidrs, var.environment,"")
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name        = "${var.environment}-${var.project_name}"
  }
}