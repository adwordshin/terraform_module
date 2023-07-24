### Create VPC EIP & NAT-GW
## EIP
resource "aws_eip" "create-eip-nat-gw" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
  
  tags = {
    Name = var.eip-name
  }
}


#NAT-GW
resource "aws_nat_gateway" "create-nat-gw" {
  allocation_id = aws_eip.create-eip-nat-gw.id

  subnet_id = data.aws_subnet.pub-2a.id

  tags = {
    Name = var.natgw-name
  }
}

## NAT-GW & pvt routetable routing setting
resource "aws_route" "pvt-rtb-create-nat-gw" {
  route_table_id              = data.aws_route_table.pvt-rtb.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.create-nat-gw.id
}