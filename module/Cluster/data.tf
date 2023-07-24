data "aws_iam_role" "cluster-role" {
  filter {
    name = "tag:Name"
    values = [var.cluster-role-name]
  }
}

data "aws_security_group" "cluster-sg" {
  filter {
    name = "tag:Name"
    values = [var.cluster-sg-name]
  }
}

data "aws_subnet" "pvt-2a-name" {
  filter {
    name = "tag:Name"
    values = [var.pvt-2a-name]
  }
}

data "aws_subnet" "pvt-2c-name" {
  filter {
    name = "tag:Name"
    values = [var.pvt-2c-name]
  }
}
