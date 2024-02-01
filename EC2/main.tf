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
  public_key = file("/terraform/EC2/aws_key.pub")
}

resource "aws_eip" "aws_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "aws_eip_association" {
  instance_id         = aws_instance.teste_servidor.id
  allow_reassociation = true
  allocation_id       = "eipalloc-0111bcf764ff47928"
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

  tags = {
    Name = "UbuntuTeste"
  }

  timeouts {
    create = "10m"
  }
}

resource "null_resource" "exec_python" {

  connection {
    type        = "ssh"
    host        = "3.141.203.83"
    user        = "ubuntu"
    private_key = file("/terraform/EC2/aws_key")
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "/terraform/EC2/docker.py"
    destination = "docker.py"
  }
  
  provisioner "file" {
    source      = "/terraform/Docker"
    destination = "/home/ubuntu/Docker"
  }
  provisioner "remote-exec" {
    inline = [
      "python3 docker.py",
    ]
  }
}