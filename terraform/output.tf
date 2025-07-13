output "frontend_public_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "backend_private_ip" {
  value = aws_instance.backend_instance.private_ip
}

output "frontend_url" {
  value = "http://${aws_instance.frontend_instance.public_ip}"
}

output "api_endpoint" {
  value = "http://${aws_instance.backend_instance.private_ip}:9090"
}