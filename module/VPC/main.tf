### Create VPC
resource "aws_vpc" "create-vpc" {
  cidr_block  = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "create-vpc-id"{
  value = aws_vpc.create-vpc.id
}



### Create VPC Subnet
## create-pub-2a subnet
resource "aws_subnet" "create-pub-2a" {
  vpc_id = aws_vpc.create-vpc.id
  cidr_block = var.pub-2a-cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = var.pub-2a-name
  }
}

output "create-pub-2a-id"{
  value = aws_subnet.create-pub-2a.id
}


## create-pub-2c subnet
resource "aws_subnet" "create-pub-2c" {
  vpc_id = aws_vpc.create-vpc.id
  cidr_block = var.pub-2c-cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = var.pub-2c-name
  }
}

output "create-pub-2c-id"{
  value = aws_subnet.create-pub-2c.id
}



## create-pvt-2a subnet
resource "aws_subnet" "create-pvt-2a" {
  vpc_id = aws_vpc.create-vpc.id
  cidr_block = var.pvt-2a-cidr
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = var.pvt-2a-name
  }
}

output "create-pvt-2a_id"{
  value = aws_subnet.create-pvt-2a.id
}


## create-pvt-2c subnet
resource "aws_subnet" "create-pvt-2c" {
  vpc_id = aws_vpc.create-vpc.id
  cidr_block = var.pvt-2c-cidr
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = var.pvt-2c-name
  }
}

output "create-pvt-2c_id"{
  value = aws_subnet.create-pvt-2c.id
}





### Create VPC Route Table
resource "aws_route_table" "create-pub-rtb" {
  vpc_id = aws_vpc.create-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.create-igw.id
  }
  tags = {
    Name = var.pub-rtb-name
  }
}

resource "aws_route_table" "create-pvt-rtb" {
  vpc_id = aws_vpc.create-vpc.id
  tags = {
    Name = var.pvt-rtb-name
  }
}

## Association Subnet to Route Table
resource "aws_route_table_association" "create-pub-2a-association" {
  subnet_id = aws_subnet.create-pub-2a.id
  route_table_id = aws_route_table.create-pub-rtb.id
}

resource "aws_route_table_association" "create-pub-2c-association" {
  subnet_id = aws_subnet.create-pub-2c.id
  route_table_id = aws_route_table.create-pub-rtb.id
}

resource "aws_route_table_association" "create-pvt-2a-association" {
  subnet_id = aws_subnet.create-pvt-2a.id
  route_table_id = aws_route_table.create-pvt-rtb.id
}

resource "aws_route_table_association" "create-pvt-2c-association" {
  subnet_id = aws_subnet.create-pvt-2c.id
  route_table_id = aws_route_table.create-pvt-rtb.id
}





### Create VPC Internet Gateway
resource "aws_internet_gateway" "create-igw" {
  vpc_id = aws_vpc.create-vpc.id
  tags = {
    Name = var.igw-name
  }
}