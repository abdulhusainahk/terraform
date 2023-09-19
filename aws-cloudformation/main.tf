resource "aws_cloudformation_stack" "stack" {
  name         = var.stack_name
  template_url = var.template_url
  capabilities = ["CAPABILITY_IAM"]
  tags         = var.tags
}
