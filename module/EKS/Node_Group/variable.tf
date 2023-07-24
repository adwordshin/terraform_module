variable "eks-cluster-name" {
  type = string
  default = "eks-cluster-seoul"
  description = "data로 가져올 Cluster 이름 지정"
}

variable "node-group-name" {
  type = string
  default = "eks-cluster-seoul-node-group"
  description = "node group 이름 지정"
}

variable "pvt-2a-name" {
  type = string
  default = "seoul-pvt-2a"
  description = "node group pvt-2a subnet 이름 지정"
}

variable "pvt-2c-name" {
  type = string
  default = "seoul-pvt-2c"
  description = "node group pvt-2c subnet 이름 지정"
}

variable "node-group-capacity-type" {
  type = string
  default = "ON_DEMAND"
  description = "node group capacity type 지정"
}

variable "node-group-instance-types" {
  type = string
  default = "t3.medium"
  description = "node group instance type 지정"
}

variable "node-group-desired-size" {
  type = string
  default = "4"
  description = "node group desired size(갯수) 지정"
}

variable "node-group-min-size" {
  type = string
  default = "2"
  description = "node group min size(갯수) 지정"
}

variable "node-group-max-size" {
  type = string
  default = "10"
  description = "node group max size(갯수) 지정"
}