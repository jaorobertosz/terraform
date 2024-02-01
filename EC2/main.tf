// main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }
}

provider "aws" {
  region = var.availability_zone_names
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = file("/home/souza/terraform/EC2/aws_key.pub")
}
resource "aws_eip" "associate_public_ip_address" {
  instance = aws_instance.teste_servidor.id
  domain   = "vpc"
}

resource "null_resource" "executar_script" {
  depends_on = [
    aws_instance.teste_servidor
  ]
}
resource "aws_instance" "teste_servidor" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  subnet_id              = var.aws_subnet
  vpc_security_group_ids = [var.aws_security_group]
  key_name               = aws_key_pair.deployer.id

  user_data_replace_on_change = true
  monitoring                  = false
  disable_api_termination     = false
  ebs_optimized               = false
  associate_public_ip_address = true

  provisioner "file" {
    source      = "/home/souza/terraform/EC2/docker.py"
    destination = "docker.py"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/souza/terraform/EC2/aws_key")
    timeout     = "1m"
  }
  provisioner "remote-exec" {
    inline = [
      "python3 docker.py"
    ]
  }

  tags = {
    Name = "UbuntuTeste"
  }

  timeouts {
    create = "10m"
  }
}
