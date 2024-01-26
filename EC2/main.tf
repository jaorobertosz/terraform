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

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = file("/terraform/EC2/aws_key.pub")
}

resource "aws_instance" "teste_servidor" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  subnet_id              = var.aws_subnet
  vpc_security_group_ids = [var.aws_security_group]
  key_name               = aws_key_pair.deployer.id


  user_data = <<-EOF
  #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Hello World run on port ${var.server_port_http}> /var/www/html/index.html'
              EOF

  user_data_replace_on_change = true
  monitoring                  = false
  disable_api_termination     = false
  ebs_optimized               = false
  associate_public_ip_address = true

  tags = {
    Name = "UbuntuTeste"
  }
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.teste_servidor.id
  domain = "vpc"
}