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

variable "alb_env_tag" {
  
}

variable "target_id" {
  
}