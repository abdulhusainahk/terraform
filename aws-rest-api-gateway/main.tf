# Module      : REST Api Gateway
resource "aws_api_gateway_rest_api" "default" {
  count                    = var.enabled ? 1 : 0
  name                     = var.api_gateway_name
  description              = var.description
  binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source

  endpoint_configuration {
    types            = var.types
    vpc_endpoint_ids = length(var.vpc_endpoint_ids) > 0 && var.vpc_endpoint_ids[0] != "" ? var.vpc_endpoint_ids : null
  }

  #   body   = jsonencode(var.openapi_config)
  policy = var.api_policy
  tags   = var.tags
}

# Module      : Api Gateway Resource
resource "aws_api_gateway_resource" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  parent_id   = aws_api_gateway_rest_api.default.*.root_resource_id[0]
  path_part   = element(var.path_parts, count.index)
}

# Module      : Api Gateway Method
resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.default.*.id[0]
  resource_id   = aws_api_gateway_resource.default.*.id[0]
  http_method   = var.http_method
  authorization = var.authorization
}

# Module      : Api Gateway Integration
resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.default.*.id[0]
  resource_id             = aws_api_gateway_resource.default.*.id[0]
  http_method             = aws_api_gateway_method.MyDemoMethod.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.uri
  depends_on              = [aws_api_gateway_method.MyDemoMethod]
}

# Module      : Api Gateway Method response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[0]
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = var.status_code
}

# Module      : Api Gateway Integration response
resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[0]
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  depends_on  = [aws_api_gateway_integration.MyDemoIntegration]
}

# Module      : Api Gateway Deployment
resource "aws_api_gateway_deployment" "default" {
  count             = var.deployment_enabled ? 1 : 0
  rest_api_id       = aws_api_gateway_rest_api.default.*.id[0]
  description       = var.description
  stage_description = var.stage_description
  variables         = var.variables
  depends_on        = [aws_api_gateway_method.MyDemoMethod, aws_api_gateway_integration.MyDemoIntegration]
}

# Module      : Api Gateway Stage
resource "aws_api_gateway_stage" "example" {
  count         = var.stage_enabled ? 1 : 0
  deployment_id = aws_api_gateway_deployment.default.*.id[0]
  rest_api_id   = aws_api_gateway_rest_api.default.*.id[0]
  stage_name    = var.stage_name
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.example.arn
    format          = "$context.requestId $context.identity.sourceIp $context.identity.caller $context.identity.user $context.requestTime $context.httpMethod $context.resourcePath $context.status $context.responseLength $context.protocol"
  }

  # execution_arn = aws_iam_role.cloudwatch.arn
  depends_on = [
    aws_cloudwatch_log_group.example
  ]
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  stage_name  = aws_api_gateway_stage.example.*.stage_name[0]
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}


# Cloudwatch log Account
resource "aws_cloudwatch_log_group" "example" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.default.*.id[0]}"
  retention_in_days = var.retention_in_days
}

resource "aws_iam_role" "cloudwatch" {
  name = var.cloudwatch_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "api_gateway_cloudwatch_logs_policy" {
  name   = var.cloudwatch_logs_policy_name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_logs_attachment" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = aws_iam_policy.api_gateway_cloudwatch_logs_policy.arn
}