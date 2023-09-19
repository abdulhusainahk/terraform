resource "aws_cloudwatch_event_rule" "console" {
  name                = var.event_rule_name
  description         = var.event_rule_description
  schedule_expression = var.schedule_expression
  role_arn            = aws_iam_role.event_role.arn
  is_enabled          = var.is_enabled
  event_pattern       = var.event_pattern
}

resource "aws_cloudwatch_event_target" "target" {
  arn       = var.target_arn
  role_arn  = aws_iam_role.event_role.arn
  target_id = var.target_id
  rule      = aws_cloudwatch_event_rule.console.id
}

# IAM Role

resource "aws_iam_role" "event_role" {
  name                  = var.event_role_name
  description           = var.event_role_description
  path                  = var.event_role_path
  force_detach_policies = var.event_role_force_detach_policies
  permissions_boundary  = var.event_role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  tags                  = var.event_role_tags
}

resource "aws_iam_policy" "event_policy" {
  name        = var.event_policy_name
  description = var.event_policy_description
  policy      = var.event_policy
}

resource "aws_iam_role_policy_attachment" "event_policy_attach" {
  role       = aws_iam_role.event_role.name
  policy_arn = aws_iam_policy.event_policy.arn
}
