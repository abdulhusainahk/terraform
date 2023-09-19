variable "ecs_task_execution_role" {
  type = string
  # default = "gworks-dev-taskExecution-role"
}

variable "alb_name" {
  type = string
  # default = "gworks-dev-alb"
}

variable "subnet_ids" {
  default = [""]
}

variable "security_grp" {
}

variable "alb_tg_name" {

}

variable "app_port" {

}

variable "vpc_id" {

}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "lb_type" {
  type = string
}

variable "https_port" {
}

variable "certificate_arn" {
  default = ""
}

variable "lb_tls_policy" {
  default = ""
}

variable "ecs_cluster_name" {
  type    = string
  default = ""
}

variable "fargate_cpu" {
  type = number
}

variable "fargate_memory" {
  type = number
}

variable "app_image" {

}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app" {

}

variable "env" {

}

variable "ecs_service_name" {

}

variable "app_count" {
  type = number
}

variable "container_port" {

}

variable "template_file" {

}

variable "subnet_ids_ecs" {

}

variable "alb_env_tag" {
  
}