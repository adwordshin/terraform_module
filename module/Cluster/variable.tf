variable "cluster-name" {
  type = string
  default = "eks-cluster-seoul"
  description = "Cluster 이름 정의"
}

variable "cluster-role-name" {
  type = string
  default = "eks-cluster-role"
  description = "data로 가져올 cluster role 이름 정의"
}

variable "cluster-sg-name" {
  type = string
  default = "seoul-center-eks-cluster-sg"
  description = "data로 가져올 cluster sg 이름 정의"
}

variable "pvt-2a-name" {
  type = string
  default = "seoul-pvt-2a"
  description = "data로 가져올 pvt-2a 이름 지정"
}

variable "pvt-2c-name" {
  type = string
  default = "seoul-pvt-2c"
  description = "data로 가져올 pvt-2c 이름 지정"
}

variable "cluster-policy-name" {
  type = string
  default = "eks-cluster-role-aws-eks-cluster-policy"
  description = "data로 불러올 eks cluster policy 이름 지정"
}

variable "eks-vpc-resource-controller-name" {
  type = string
  default = "eks-cluster-role-aws-eks-VPCResourceController"
  description = "data로 불러올 eks vpc resource controller 이름 지정"
}