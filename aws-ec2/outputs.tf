output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = [data.aws_subnets.gworks_subnets.*.ids]
}

output "id" {
  value = aws_instance.ec2[0].id
}