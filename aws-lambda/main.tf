# LAMBDA FUNCTION 


resource "aws_lambda_function" "EMS_lambda" {
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = var.ecr_image_uri
  package_type  = "Image"
  timeout       = 900
  memory_size   = 10240
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_grp_id]
  }
  tags = {
    Name    = var.function_name
    Appname = "Dev"
  }
}
resource "aws_lambda_permission" "lambda_security" {
  statement_id  = var.statement_id
  action        = var.action
  function_name = var.function_name
  principal     = var.lambda_principal
  source_arn    = var.source_arn
}
