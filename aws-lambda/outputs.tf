#OUTPUTS OF THE LAMBDA FUNCTION

output "lambda_arn" {
  value = aws_lambda_function.EMS_lambda.arn
}

output "EMS_lambda" {
  value = aws_lambda_function.EMS_lambda
}
output "lambda_invoke_arn" {
  value = aws_lambda_function.EMS_lambda.invoke_arn
}