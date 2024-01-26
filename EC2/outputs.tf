output "public_ip" {
  value       = aws_instance.teste_servidor.public_ip
  description = "IP publico EC2"
}
output "user_data" {
  value       = aws_instance.teste_servidor.user_data
  description = "USER-DATA"
}
output "subnet_id" {
  value = var.aws_subnet
  description = "Subnet"
}