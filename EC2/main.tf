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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9RNzZ+TK0i++Ya04dKVrl7w6Thxh6kD9DABLIw+MBjXGgdh3/dmfsEkOyfv3VfOg4wIlvg/dZibvm7SM336BvK67ih+qQlqE76ZfRt0og0r7W0lWaWbr6ToPe+yx5J4sIdhj8PGTjgqysSyb0xB39GTkaGFz27PnXOMD8irWd+sJkHXhYlyRRKvabnYSV7Qc3p1kndIkG9evBWFKWeFK8XNgOiW11zQaVbJXn7biDD0xfm46Yqh9H9NJGFpTlHDVyzIwRaxFf3J7uqZ0brE7ScoB3Q9wHDT3QKraZQJs/Mr23sfUVVqIqMYsaxFY4loJaz4AxpddJx8tcsp3rRSrJ souza@UBN-LNX"
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

  user_data_replace_on_change = true
  monitoring                  = false
  disable_api_termination     = false
  ebs_optimized               = false
  associate_public_ip_address = true

  tags = {
    Name = "UbuntuTeste"
  }
}
