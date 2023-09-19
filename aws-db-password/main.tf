resource "random_password" "db_password" {
  length           = var.password_length
  special          = var.special_characters
  upper            = var.upper_case
  lower            = var.lower_case
  override_special = "/@-"
}