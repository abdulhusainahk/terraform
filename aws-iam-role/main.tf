resource "aws_iam_role" "transfer_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "transfer_policy" {
  name   = var.policy_name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "transfer_role_attachment" {
  role       = aws_iam_role.transfer_role.name
  policy_arn = aws_iam_policy.transfer_policy.arn
}
