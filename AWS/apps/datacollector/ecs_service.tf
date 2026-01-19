# Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-${var.project_name}-${var.app_name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Task Definition (the ‘what’ to run))
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.environment}-${var.project_name}-${var.app_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU
  memory                   = "512" # 0.5 GB
  execution_role_arn       = var.execution_role_arn # Using a shared role
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = "${aws_ecr_repository.repo.repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/${var.project_name}/${var.app_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
    }
  ])
}

# Service (how it stays active)
resource "aws_ecs_service" "main" {
  name            = "${var.environment}-${var.project_name}-${var.app_name}"
  cluster         = var.cluster_id 
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.app_sg.id]
    assign_public_ip = false
  }
}