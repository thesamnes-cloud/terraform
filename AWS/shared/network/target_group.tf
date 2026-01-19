

# --- TARGET GROUP ---
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.environment}-${var.project_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/login" 
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.environment}-${var.project_name}"
  }
}
