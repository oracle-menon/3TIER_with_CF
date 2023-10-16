resource "aws_lb_listener" "project" {
  load_balancer_arn = aws_lb.project.arn
  port              = "443"   #80
  protocol          = "HTTPS" #HTTP
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.project.arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project.arn

  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.project.arn
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

resource "aws_security_group" "alb" {
  name   = "alb-secgroup-${var.env}"
  vpc_id = module.vpc.vpc_id

  # Allow inbound HTTP requests
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

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "project" {
  name               = "alb-project-${var.env}"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "project" {
  name     = "asg-tg-project-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id


  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}