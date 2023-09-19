resource "aws_service_discovery_service" "service_discovery" {
  name = var.service_discovery_service_name

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_task_definition" "ecs_def" {
  family                   = join("-", [var.app, var.env])
  execution_role_arn       = var.ecs_task_execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = templatefile(var.template_file, { app_image = var.app_image, app_port = var.app_port, fargate_cpu = var.fargate_cpu, fargate_memory = var.fargate_memory, aws_region = var.aws_region, app = var.app, env = var.env, log_grp = var.log_grp })
  task_role_arn            = var.ecs_task_execution_role
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.ecs_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_grp]
    subnets          = var.subnet_ids_ecs
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }
}