#Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/16
  instance_tenancy = var.vpc_instance_tenacy
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Env  = var.vpc_env
  }
}

#Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id # vpc_id will be generated after we create VPC

  tags = {
    Name = var.igw_name
    Env  = var.igw_env
  }
}

#Create a Public Subnets.
data "aws_availability_zones" "available" {}
resource "aws_subnet" "publicsubnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnets[count.index] # CIDR block of public subnets
  map_public_ip_on_launch = true

  tags = {
    Env = var.public_subnets_env
  }
}

#Create a Private Subnet                   
resource "aws_subnet" "privatesubnets" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnets[count.index] # CIDR block of private subnets

  tags = {
    Env = var.private_subnets_env
  }
}

#Route table for Public Subnet's
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Env = var.public_route_table_env
  }
}

#Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Env = var.private_route_table_env
  }
}

#Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.publicsubnets.*.id, count.index)
  route_table_id = aws_route_table.PublicRT.id
}

#Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.privatesubnets.*.id, count.index)
  route_table_id = aws_route_table.PrivateRT.id
}

# elastic ip
resource "aws_eip" "nateIP" {
  vpc = true

  tags = {
    Name = var.eip_name
  }
}

#Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {

  allocation_id = aws_eip.nateIP.id
  subnet_id     = element(aws_subnet.publicsubnets.*.id, 0)
}