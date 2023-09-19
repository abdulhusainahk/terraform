resource "aws_instance" "ec2" {
  ami                         = var.ami
  count                       = var.node_count
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile == "" ? "" : var.iam_instance_profile
  vpc_security_group_ids      = var.security_group_ids

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_delete_on_termination
    encrypted             = var.root_encrypted
  }

  tags = {
    Name = var.ec2_name_tag
  }

  lifecycle {
    ignore_changes = [ebs_block_device]
  }
}

resource "aws_eip" "eip" {
  count    = var.enable_eip ? var.node_count : 0
  vpc      = true
  instance = element(aws_instance.ec2.*.id, count.index)
  tags = {

  }
}