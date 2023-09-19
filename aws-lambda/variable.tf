variable "runtime" {
  type        = string
  default     = ""
  description = "Identifier of the function's runtime."
}

variable "function_name" {
  type        = string
  default     = ""
  description = " Name for the Lambda Function."
}

variable "handler" {
  type        = string
  default     = ""
  description = " Function entrypoint in the code."
}

variable "role" {
  type        = string
  default     = ""
  description = "Amazon Resource Name (ARN) of the lambda function's execution role"
}

variable "assume_role_policy" {
  type        = string
  default     = ""
  description = "lambda assume role policy for to use the lambda function"
}

variable "lambda_policy" {
  type        = string
  default     = ""
  description = "AWS Lambda Basic Execution Role"
}

variable "lambda_role_name" {
  type        = string
  default     = ""
  description = "Nmae of the lambda role"
}
variable "lambda_policy_name" {
  type        = string
  default     = ""
  description = "Name of the lambda policy name"
}

variable "ecr_image_uri" {
  type    = string
  default = ""
}

variable "package_type" {
  type    = string
  default = ""
}
variable "aws_region" {

}
variable "account_id" {

}
variable "statement_id" {
  type = string
}
variable "action" {
  type = string
}
variable "lambda_principal" {
  type = string
}
variable "source_arn" {
  type = string
}
variable "lambda_security_grp_id" {
}
variable "subnet_ids" {

}
