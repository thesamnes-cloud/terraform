# Server

resource "aws_instance" "app_server" {
  ami           = "ami-06777e7ef7441deff" # Windows server
  instance_type = "t3.small"

  subnet_id              = var.subnet_id       
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "prod-mindbio-server"
  iam_instance_profile = var.iam_instance_profile_name

  # --- CONFIGURACIÓN DE STORAGE ---
  root_block_device {
    volume_size           = 50      # GB
    volume_type           = "gp3"   # General purpouse
    iops                  = 3000    
    throughput            = 125     
    delete_on_termination = true    
    encrypted             = true    

    tags = {
      Name = "${var.environment}-${var.project_name}-APP-SERVER-STORAGE"
    }
  }

  tags = {
     Name = "${var.environment}-${var.project_name}-APP-SERVER"
  }
}


# Security Group

resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-${var.project_name}-APP"
  description = "Allow inbound HTTPS/HTTP traffic"
  vpc_id      = var.vpc_id

  # Allow RDP from anywhere
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
     Name = "${var.environment}-${var.project_name}-APP-SERVER"
  }
}

# resource "aws_lb_listener_rule" "app_rule" {
#   listener_arn = var.lb_listener_https_arn
#   priority     = 100 

#   action {
#     type             = "forward"
#     target_group_arn = var.app_target_group_arn 
#   }

#   condition {
#     path_pattern {
#       values = ["/*"] # All traffic
#     }
#   }
# }

resource "aws_lb_target_group_attachment" "app_server_attachment" {
  target_group_arn = var.app_target_group_arn 
  target_id        = aws_instance.app_server.id    
  port             = 80
}