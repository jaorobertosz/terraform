variable "availability_zone_names" {
  type    = string
  default = "us-east-1"
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
  default     = "ami-06aa3f7caf3a30282"
  type        = string
}
variable "instance_type" {
  description = "Tipo de instancia"
  default     = "t2.nano"
  type        = string
}

