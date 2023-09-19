variable "server_role_name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "server_policy_name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}


variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "enable_sftp" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "user_name" {
  type        = string
  description = "User name for SFTP server."
  sensitive   = true
}

variable "public_key" {
  type        = string
  default     = ""
  description = "Name  (e.g. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`)."
  sensitive   = true
}

variable "identity_provider_type" {
  type        = string
  default     = "SERVICE_MANAGED"
  description = "The mode of authentication enabled for this service. The default value is SERVICE_MANAGED, which allows you to store and access SFTP user credentials within the service. API_GATEWAY."
}

variable "s3_bucket_id" {
  type        = string
  description = "The landing directory (folder) for a user when they log in to the server using their SFTP client."
  sensitive   = true
}

variable "key_path" {
  type        = string
  default     = ""
  description = "Name  (e.g. `~/.ssh/id_rsa.pub`)."
  sensitive   = true
}
variable "sub_folder" {
  type        = string
  default     = ""
  description = "Landind folder."
  sensitive   = true
}

variable "endpoint_type" {
  type        = string
  default     = "PUBLIC"
  description = "The type of endpoint that you want your SFTP server connect to. If you connect to a VPC (or VPC_ENDPOINT), your SFTP server isn't accessible over the public internet. If you want to connect your SFTP server via public internet, set PUBLIC. Defaults to PUBLIC"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID"
}

variable "subnet_ids" {
  type = list(string)
}

variable "ingress_rules" {
  
}

variable "sg_name" {
  
}

variable "sg_description" {
  
}

# variable "server_key" {
#   type        = string
#   default     = ""
#   description = " Server key e.g `aws:transfer:customHostname` "
# }

# variable "server_value" {
#   type        = string
#   default     = ""
#   description = " Server key value e.g `example.com` "
# }