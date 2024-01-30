variable "availability_zone_names" {
  type    = string
  default = "us-east-2"
}
variable "server_port_http" {
  description = "porta_web_server"
  type        = number
  default     = 80
}
variable "server_port_https" {
  description = "porta_https_server"
  type        = number
  default     = 443
}
variable "image_id" {
  description = "Valor da imagem"
  default     = "ami-05fb0b8c1424f266b"
  type        = string
}
variable "instance_type" {
  description = "Tipo de instancia"
  default     = "t2.nano"
  type        = string
}
variable "aws_security_group" {
  description = "Security Group"
  default     = "sg-04f803cf48c274f87"
  type        = string
}
variable "aws_subnet" {
  description = "Subnet Us-east2-a"
  default     = "subnet-0b44e6f8ea32cf5f5"
  type        = string
}