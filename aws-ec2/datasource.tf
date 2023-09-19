data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["Jenkins_Ami"]
  }

  # filter {
  #   name   = "tag:Env"
  #   values = ["dev"]
  # }

  owners = ["1111111"]
}

data "aws_vpc" "gworks_vpc" {
  tags = {
    Name = "dev-server"
  }
}

data "aws_subnets" "gworks_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.gworks_vpc.id]
  }
  filter {
    name = "tag:Env"
    values = ["public_dev"]
  }
}

data "aws_subnet" "gworks_subnet" {
  for_each = toset(data.aws_subnets.gworks_subnets.ids)
  id       = each.value
}

# subnets = [for subnet in data.aws_subnet.this : subnet.id if subnet.availability_zone != "us-east-1a"]

data "aws_security_group" "gworks_sg" {
  vpc_id = data.aws_vpc.gworks_vpc.id

  filter {
    name   = "tag:Name"
    values = ["lb-dev-sg"]
  }
}