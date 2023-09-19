resource "aws_db_subnet_group" "gworks_subnet_group" {
  count = var.create ? 1 : 0

  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}