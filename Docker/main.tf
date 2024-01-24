// main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "docker_and_ansible" {
  name = "docker_and_ansible"
  build {
    context = "//home/terraform/Docker/Ansible/Dockerfile"
    tag     = ["joao219:docker_and_ansible"]
    memory = "2048"
    memory_swap = "1024"
    cpu_set_cpus = "2"
  }
}