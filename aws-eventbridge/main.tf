resource "aws_cloudwatch_event_rule" "every_scheduled_interval" {
  name                = "Processor-Trigger"
  description         = "Fires after every 5 minutes"
  schedule_expression = var.schedule_expression
}