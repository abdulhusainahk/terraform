variable "create_sfn_machine" {
  type = bool
}

variable "state_machine_name" {

}

variable "sfn_machine_type" {

}

variable "sfn_definition" {

}

variable "tags" {

}

variable "create_role" {
  type = bool
}

# IAM Role
variable "role_name" {

}

variable "trusted_entities" {
}

variable "role_description" {

}

variable "role_path" {

}

variable "role_force_detach_policies" {

}

variable "role_permissions_boundary" {

}

variable "role_tags" {

}

# IAM Role Policy
variable "create_policy" {
  type = bool
}

variable "sfn_policy_name" {

}

variable "sfn_policy_description" {

}

variable "sfn_policy" {

}