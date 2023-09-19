## ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ])

  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = each.value
}

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
  target_type = "ip"
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

resource "aws_ecs_cluster" "cluster_name" {
  name = var.ecs_cluster_name
}

/*
data "template_file" "app_template" {
  template = var.template_file

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    app     = var.app
    env     = var.env
  }
}
*/

resource "aws_ecs_task_definition" "ecs_def" {
  family                   = join("-", [var.app, var.env])
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = templatefile(var.template_file, { app_image = var.app_image, app_port = var.app_port, fargate_cpu = var.fargate_cpu, fargate_memory = var.fargate_memory, aws_region = var.aws_region, app = var.app, env = var.env })
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
}


resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.cluster_name.id
  task_definition = aws_ecs_task_definition.ecs_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_grp]
    subnets          = var.subnet_ids_ecs
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_targetgroup.arn
    container_name   = join("-", [var.app, var.env])
    container_port   = var.container_port
  }
  depends_on = [aws_alb_listener.app_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}