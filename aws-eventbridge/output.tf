output "event_name" {
  value = aws_cloudwatch_event_rule.every_scheduled_interval.name
}
output "source_arn" {
  value = aws_cloudwatch_event_rule.every_scheduled_interval.arn
}