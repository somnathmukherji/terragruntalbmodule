#provider "aws" {
#  region = "ap-south-1"  
#}

resource "aws_security_group" "WEB_LB" {
  name        = "WEB_LB"
  description = "ALLOW HTTP HTTPS"
  
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "MYALB" {
  name               = "MYALB"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  
  tags = {
    Name = "MYALB"
  }
}

resource "aws_lb_target_group" "ProdTG" {
  name     = "ProdTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.MYALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ProdTG.arn
    type             = "forward"
  }
}
