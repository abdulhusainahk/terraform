resource "aws_apigatewayv2_api" "apigateway" {
  name          = "${var.api_gateway_name}_gw"
  protocol_type = var.protocol_type
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.apigateway.id

  name        = "${var.api_gateway_name}_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = var.destination_arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "apigateway_integration" {
  api_id             = aws_apigatewayv2_api.apigateway.id
  integration_uri    = var.integration_uri
  integration_type   = var.integration_type
  integration_method = var.integration_method
}

resource "aws_apigatewayv2_route" "api_gateway_route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.apigateway_integration.id}"
}

