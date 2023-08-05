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





##NAT-GW
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





### Bastion Host
resource "aws_instance" "create-bastion" {
  ami                    = var.ami-id
  instance_type          = var.instance-type
  subnet_id              = data.aws_subnet.pub-2a.id
  vpc_security_group_ids = [data.aws_security_group.bastion-sg.id]
  key_name  = var.key-name
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "bastion-block-device"
    }
  }

  tags = {
    Name = var.bastion-name
  }
}
