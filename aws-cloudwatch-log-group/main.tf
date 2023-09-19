resource "aws_cloudwatch_log_group" "log" {
  name              = var.log_name
  retention_in_days = var.retention_in_days

  tags = var.tags
}