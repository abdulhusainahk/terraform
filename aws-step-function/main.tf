resource "aws_sfn_state_machine" "sfn_state_machine" {
  count    = var.create_sfn_machine ? 1 : 0
  name     = var.state_machine_name
  role_arn = aws_iam_role.state_machine_role[0].arn
  type     = var.sfn_machine_type

  definition = var.sfn_definition

  tags = var.tags
}

###########
# IAM Role
###########

data "aws_region" "current" {
  count = var.create_role ? 1 : 0
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = distinct(concat(["states.${data.aws_region.current[0].name}.amazonaws.com"], var.trusted_entities))
    }
  }
}

resource "aws_iam_role" "state_machine_role" {
  count = var.create_role ? 1 : 0

  name                  = var.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = var.role_tags
}

resource "aws_iam_policy" "sfn_policy" {
  count       = var.create_policy ? 1 : 0
  name        = var.sfn_policy_name
  description = var.sfn_policy_description
  policy      = var.sfn_policy
}

resource "aws_iam_role_policy_attachment" "sfn_policy_attach" {
  count      = var.create_policy ? 1 : 0
  role       = aws_iam_role.state_machine_role[0].name
  policy_arn = aws_iam_policy.sfn_policy[0].arn
}