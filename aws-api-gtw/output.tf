output "invoke_url" {
  value = aws_apigatewayv2_stage.lambda.invoke_url
}
output "gatewayname" {
  value = aws_apigatewayv2_api.apigateway.name
}
output "execution_arn" {
  value = aws_apigatewayv2_api.apigateway.execution_arn
}