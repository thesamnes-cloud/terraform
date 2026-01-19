# --- APPLICATION LOAD BALANCER (SHARED) ---
# This resource is shared across all applications in the cluster
resource "aws_lb" "main" {
  name               = "${var.environment}-${var.project_name}"
  internal           = false # Public-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id # ALB must be in public subnets

  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-${var.project_name}"
  }
}

# --- HTTPS LISTENER (PORT 443) ---
# The entry point for all secure traffic
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08" # Recommended AWS policy
#   certificate_arn   = var.acm_certificate_arn

#   # Default Action: If a request doesn't match any App rule, return 404
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Error 404: The requested application is not configured in this cluster."
#       status_code  = "404"
#     }
#   }
# }

# --- HTTP TO HTTPS REDIRECT (PORT 80) ---
# Force all unencrypted traffic to use the secure port
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# --- ALB SECURITY GROUP ---
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.project_name}-ALB"
  description = "Allow inbound HTTPS/HTTP traffic"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (for redirect) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic to the containers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-ALB"
  }
}