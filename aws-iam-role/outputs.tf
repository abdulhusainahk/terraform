output "role_name" {
  value       = aws_iam_role.transfer_role.name
  description = "The name of the IAM role created"
}

output "role_id" {
  value       = aws_iam_role.transfer_role.unique_id
  description = "The stable and unique string identifying the role"
}

output "arn" {
  value       = aws_iam_role.transfer_role.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}