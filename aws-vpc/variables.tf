# variable "vpc_id" {
#   type = string
# }

variable "vpc_name" {
  type = string
}

variable "vpc_env" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "igw_env" {
  type = string
}

variable "vpc_instance_tenacy" {
  type    = string
  default = "default"
}

variable "public_subnets_env" {
  type = string
}

variable "private_subnets_env" {
  type = string
}

variable "public_route_table_env" {
  type = string
}

variable "private_route_table_env" {
  type = string
}

variable "eip_name" {
  type = string
}

# variable "region" {}

variable "main_vpc_cidr" {}

variable "public_subnets" {
  type    = list(any)
  default = []
}

variable "private_subnets" {
  type    = list(any)
  default = []
}
