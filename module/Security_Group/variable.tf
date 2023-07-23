### Security Group Variable
variable "vpc-name" {
  type = string
  default = "seoul-center"
  description = "data로 가져올 VPC 이름 정의"
}

variable "bastion-sg-name" {
  type = string
  default = "seoul-center-bastion-sg"
  description = "Bastion Host Security Group 이름 정의"
}


variable "eks-cluster-sg-name" {
  type = string
  default = "seoul-eks-cluster-sg"
  description = "seoul-eks-cluster Security Group 이름 정의"
}
