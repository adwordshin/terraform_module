variable "vpc-name" {
  type = string
  default = "seoul-center"
  description = "data로 가져올 VPC 이름 정의"
}

variable "pub-2a-name" {
  type = string
  default = "seoul-pub-2a"
  description = "data로 가져올 pub-2a subnet 이름 정의"
}

variable "pvt-rtb-name" {
  type = string
  default = "seoul-pvt-rtb"
  description = "data로 가져올 pvt route table 이름 정의"
}

variable "eip-name" {
  type = string
  default = "eip-seoul-center"
  description = "eip 이름 정의"
}

variable "natgw-name" {
  type = string
  default = "nat-gw-seoul-center"
  description = "eip 이름 정의"
}