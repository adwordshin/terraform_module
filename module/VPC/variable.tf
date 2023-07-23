### VPC variable
variable "vpc-cidr" {
    type = string
    default = "10.10.0.0/16"
    description = "vpc cidr 정의"
}

variable "vpc-name" {
    type = string
    default = "seoul-center"
    description = "vpc 이름 정의"
}





### Subnet Variable
## pub-2a variable
variable "pub-2a-cidr" {
    type = string
    default = "10.10.0.0/20"
    description = "pub-2a cidr 정의"
}

variable "pub-2a-name" {
    type = string
    default = "seoul-pub-2a"
    description = "pub-2a-name 이름 정의"
}


## pub-2c variable
variable "pub-2c-cidr" {
    type = string
    default = "10.10.32.0/20"
    description = "pub-2c cidr 정의"
}

variable "pub-2c-name" {
    type = string
    default = "seoul-pub-2c"
    description = "pub-2c-name 이름 정의"
}



## pvt-2a variable
variable "pvt-2a-cidr" {
  type = string
  default = "10.10.64.0/20"
  description = "pvt-2a cidr 정의"
}

variable "pvt-2a-name" {
  type = string
  default = "seoul-pvt-2a"
  description = "pvt-2a 이름 정의"
}


## pvt-2c variable
variable "pvt-2c-cidr" {
  type = string
  default = "10.10.96.0/20"
  description = "pvt-2c cidr 정의"
}

variable "pvt-2c-name" {
  type = string
  default = "seoul-pvt-2c"
  description = "pvt-2c 이름 정의"
}





### Route Table
variable "pub-rtb-name" {
  type = string
  default = "seoul-pub-rtb"
  description = "pub-rtb 이름 정의"
}

variable "pvt-rtb-name" {
  type = string
  default = "seoul-pvt-rtb"
  description = "pvt-rtb 이름 정의"
}





variable "igw-name" {
  type = string
  default = "seoul-center-igw"
  description = "igw 이름 정의"
}