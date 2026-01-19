resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10) # .10.0, .11.0
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.environment}-${var.project_name}-private-${count.index + 1}"
  }
}