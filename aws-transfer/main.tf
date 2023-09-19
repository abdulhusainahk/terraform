# Module      : IAM ROLE
# Description : This data source can be used to fetch information about a specific IAM role.
resource "aws_iam_role" "transfer_server_role" {
  count = var.enable_sftp ? 1 : 0

  name               = var.server_role_name
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
}

# Module      : IAM ROLE POLICY
resource "aws_iam_role_policy" "transfer_server_policy" {
  count = var.enable_sftp ? 1 : 0

  name   = var.server_policy_name
  role   = join("", aws_iam_role.transfer_server_role.*.name)
  policy = data.aws_iam_policy_document.transfer_server_assume_policy.json
}

# Module      : AWS TRANSFER SERVER
resource "aws_transfer_server" "transfer_server" {
  count = var.enable_sftp && var.endpoint_type == "PUBLIC" ? 1 : 0

  identity_provider_type = var.identity_provider_type
  logging_role           = join("", aws_iam_role.transfer_server_role.*.arn)
  force_destroy          = false
  tags                   = var.tags
  endpoint_type          = var.endpoint_type
}

#with VPC endpoint
resource "aws_transfer_server" "transfer_server_vpc" {
  count = var.enable_sftp && var.endpoint_type == "VPC" ? 1 : 0

  identity_provider_type = var.identity_provider_type
  logging_role           = join("", aws_iam_role.transfer_server_role.*.arn)
  force_destroy          = false
  tags                   = var.tags
  endpoint_type          = var.endpoint_type
  endpoint_details {
    vpc_id = var.vpc_id
    subnet_ids = tolist(var.subnet_ids)
    security_group_ids = [aws_security_group.sftp_sg.id]
  }
}

# Module      : AWS TRANSFER USER
# Description : Provides a AWS Transfer User resource.
resource "aws_transfer_user" "transfer_server_user" {
  count = var.enable_sftp ? 1 : 0

  server_id      = var.endpoint_type == "VPC" ? join("", aws_transfer_server.transfer_server_vpc.*.id) : join("", aws_transfer_server.transfer_server.*.id)
  user_name      = var.user_name
  role           = join("", aws_iam_role.transfer_server_role.*.arn)
  home_directory = format("/%s/%s", var.s3_bucket_id, var.sub_folder)
  tags           = var.tags
}

# Module      : AWS TRANSFER SSH KEY
# Description : Provides a AWS Transfer User SSH Key resource.
resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  count = var.enable_sftp ? 1 : 0

  server_id = join("", aws_transfer_server.transfer_server_vpc.*.id)
  user_name = join("", aws_transfer_user.transfer_server_user.*.user_name)
  body      = var.public_key == "" ? file(var.key_path) : var.public_key
}

# Security Group
resource "aws_security_group" "sftp_sg" {
  name        = var.sg_name
  description = var.sg_description

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}