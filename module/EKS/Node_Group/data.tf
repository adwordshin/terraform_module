data "aws_eks_cluster" "eks-cluster" {
  filter {
    name = "tag:Name"
    values = [var.eks-cluster-name]
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