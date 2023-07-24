data "aws_vpc" "VPC" {
  filter {
    name = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_subnet" "pub-2a" {
  filter {
    name = "tag:Name"
    values = [var.pub-2a-name]
  }
}

data "aws_route_table" "pvt-rtb" {
  filter {
    name = "tag:Name"
    values = [var.pvt-rtb-name]
  }
}

data "aws_security_group" "bastion-sg" {
  filter {
    name = "tag:Name"
    values = [var.sg-name]
  }
}