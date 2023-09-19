locals {
  db_instance_endpoint = element(concat(aws_db_instance.gworks_rds_postgres.*.endpoint, [""]), 0)
  db_instance_address  = element(concat(aws_db_instance.gworks_rds_postgres.*.address, [""]), 0)
  db_instance_name     = element(concat(aws_db_instance.gworks_rds_postgres.*.name, [""]), 0)
  # db_instance_username        = element(concat(aws_db_instance.gworks_rds_postgres.*.username, [""]), 0)
  # db_instance_master_password = element(concat(aws_db_instance.gworks_rds_postgres.*.password, [""]), 0)
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = local.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = local.db_instance_endpoint
}

output "db_instance_name" {
  description = "The database name"
  value       = local.db_instance_name
}

# output "db_instance_username" {
#   description = "The master username for the database"
#   value       = local.db_instance_username
#   sensitive   = true
# }

# output "db_instance_master_password" {
#   description = "The master password"
#   value       = local.db_instance_master_password
#   sensitive   = true
# }