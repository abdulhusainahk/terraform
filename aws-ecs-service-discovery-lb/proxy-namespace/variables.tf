variable "ecs_task_execution_role" {
  type = string
  # default = "gworks-dev-taskExecution-role"
}

variable "subnet_ids" {
  default = [""]
}

variable "security_grp" {
}

variable "app_port" {

}

variable "vpc_id" {

}

variable "https_port" {
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

# Service discvoery

variable "namespace_id" {

}

variable "service_discovery_service_name" {

}
variable "log_grp" {
  
}
