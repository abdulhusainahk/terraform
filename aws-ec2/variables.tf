variable "ami" {

}

variable "node_count" {

}

variable "instance_type" {

}

variable "key_name" {

}

variable "user_data" {

}

variable "associate_public_ip_address" {

}

variable "subnet_id" {

}

variable "iam_instance_profile" {

}

variable "security_group_ids" {
  type = list(any)
}

variable "root_volume_type" {

}

variable "root_volume_size" {

}

variable "root_delete_on_termination" {

}

variable "root_encrypted" {

}

variable "ec2_name_tag" {

}

variable "enable_eip" {

}

# variable "vpc_name_tag" {

# }

# variable "subnet_env_tag" {

# }

# variable "sg_name_tag" {

# }