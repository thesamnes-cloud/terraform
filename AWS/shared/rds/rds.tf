# Security Group
resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-${var.project_name}-DB"
  description = "Access to the shared database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Subnet Group (RDS requires at least 2 subnets)
resource "aws_db_subnet_group" "main" {
  name          = lower("${var.environment}-${var.project_name}")
  subnet_ids    = var.subnet_ids

  tags = { Name = "${var.environment}-${var.project_name}" }
}

# Dtabase engine
resource "aws_db_instance" "postgres" {
  count                 = var.environment == "prod" ? 1 : 0  # Only created if the environment is ‘PROD’
  identifier            = "${var.environment}-${var.project_name}"
  allocated_storage     = 20
  max_allocated_storage = 100 
  db_name               = "mindbio" 
  engine                = "postgres"
  engine_version        = "17.6"
  instance_class        = "db.t3.micro"
  username              = "postgres"
  password              = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  publicly_accessible = true # Short-term public access
  skip_final_snapshot = true
  
  tags = {
    Name = "${var.environment}-${var.project_name}"
  }
}