variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}