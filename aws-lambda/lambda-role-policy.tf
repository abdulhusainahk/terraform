# IAM role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.function_name}_${var.lambda_role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


#IAM policy for lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.function_name}_${var.lambda_policy_name}"
  role = aws_iam_role.iam_for_lambda.id

  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:AssociateKmsKey",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface"
    ]
  }

  statement {
    sid       = "Stmt1653937553337"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/lambda/${var.function_name}:*"]
    actions   = ["logs:*"]
  }
  statement {
    actions = ["s3:*",
    "secretsmanager:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}