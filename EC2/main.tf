// main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.availability_zone_names
}
resource "aws_vpc" "vpc_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_test.id
  cidr_block = "10.0.1.0/24"

}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_test.id
  cidr_block = "10.0.2.0/24"

}

resource "aws_security_group" "instance" {
  name   = "teste_servidor"
  vpc_id = aws_vpc.vpc_test.id

  ingress {
    from_port   = var.server_port_http
    to_port     = var.server_port_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key.pub"
  public_key = file("/home/terraform/EC2/aws_key.pub")
}

resource "aws_instance" "teste_servidor" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
  #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Hello World run on port ${var.server_port_http}> /var/www/html/index.html'
              EOF

  user_data_replace_on_change = false
  monitoring                  = false
  disable_api_termination     = false
  ebs_optimized               = false
  associate_public_ip_address = true

  tags = {
    Name = "UbuntuTeste"
  }
}
resource "aws_security_group_rule" "acesso-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["177.206.86.197/32"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.instance.id
}
resource "aws_security_group_rule" "trafego-https" {
  type              = "ingress"
  from_port         = var.server_port_https
  to_port           = var.server_port_https
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.instance.id
}
