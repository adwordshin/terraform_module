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

variable "ami-id" {
  type = string
  default = "ami-0ea4d4b8dc1e46212"
  description = "Bastion Host ami id 지정"
}

variable "instance-type" {
  type = string
  default = "t2.large"
  description = "Bastion Host 인스턴스 타입 지정"
}

variable "sg-name" {
  type = string
  default = "seoul-center-bastion-sg"
  description = "Bastion Host Security group 이름 지정"
}

variable "key-name" {
  type = string
  default = "seoul-center-bastion-sg"
  description = "Bastion Host Key Pair 이름 지정"
}