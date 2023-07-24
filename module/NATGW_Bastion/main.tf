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
  user_data = <<-EOF
              #! /bin/bash
              hostnamectl set-hostname create-bastion
              yum -y update
              yum install -y bash-completion tree jq git htop go
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip >/dev/null 2>&1
              sudo ./aws/install
              echo "export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" >> /etc/profile
              curl -LO https://dl.k8s.io/release/v1.22.2/bin/linux/amd64/kubectl
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin
              source <(kubectl completion bash)
              echo "source <(kubectl completion bash)" >> ~/.bashrc
              source /usr/share/bash-completion/bash_completion
              echo 'alias k=kubectl' >>~/.bashrc
              echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
              exec bash
	      EOF
  tags = {
    Name = "create-bastion"
  }
}