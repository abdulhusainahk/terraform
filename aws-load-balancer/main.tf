resource "aws_alb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = var.lb_type
  subnets                    = var.subnet_ids
  security_groups            = [var.security_grp]
  enable_deletion_protection = true
  #   access_logs {
  #     bucket  = ""
  #     prefix  = join("/", [var.app, var.env])
  #     enabled = true
  #   }

  tags = {
    Environment = var.alb_env_tag
    Name        = var.alb_name
  }
}

resource "aws_alb_target_group" "alb_targetgroup" {
  name        = var.alb_tg_name
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 4
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_alb_target_group.alb_targetgroup.arn
  target_id = var.target_id
  port             = 80
}

#redirecting all incomming traffic from ALB to the target group

resource "aws_alb_listener" "app_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = "HTTP"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_targetgroup.arn
  }
}


resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.lb_tls_policy

  default_action {
    target_group_arn = aws_alb_target_group.alb_targetgroup.arn
    type             = "forward"
  }
}
