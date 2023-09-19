output "name" {
  value       = aws_cloudformation_stack.stack.name
  description = "Name of the CloudFormation Stack"
}

output "id" {
  value       = aws_cloudformation_stack.stack.id
  description = "ID of the CloudFormation Stack"
}

output "outputs" {
  value       = aws_cloudformation_stack.stack.outputs
  description = "Outputs of the CloudFormation Stack"
}