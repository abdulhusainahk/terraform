variable "password_length" {
  type        = number
  description = "The length of the generated password"
  default     = 16
}

variable "special_characters" {
  type        = bool
  description = "Whether to include special characters in the generated password"
  default     = true
}

variable "upper_case" {
  type        = bool
  description = "Whether to include upper case characters in the generated password"
  default     = true
}

variable "lower_case" {
  type        = bool
  description = "Whether to include lower case characters in the generated password"
  default     = true
}