resource "aws_sns_topic" "sns" {
  name = var.sns_name
  tags = var.sns_tags
}

resource "aws_sns_topic_policy" "example" {
  arn    = aws_sns_topic.sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = var.sns_subscription_protocol
  endpoint  = var.sns_subscription_endpoint
}