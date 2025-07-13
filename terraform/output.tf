output "frontend_public_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "backend_private_ip" {
  value = aws_instance.backend_instance.private_ip
}

