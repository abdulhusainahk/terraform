variable "key_name" {
  type        = string
  description = "The name of the key pair"
}

variable "public_key_path" {
  type        = string
  description = "The path to the public key file"
}

variable "key_algorithm" {
  type        = string
  description = "The encryption algorithm used for the key pair"
  default     = "RSA"
}

variable "tags" {
  type        = map(string)
  description = "Additional metadata tags to apply to the key pair resource"
  default     = {}
}