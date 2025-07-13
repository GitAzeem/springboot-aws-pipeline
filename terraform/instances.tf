resource "aws_instance" "frontend_instance" {
  ami                         = "ami-020cba7c55df1f615" # Ubuntu 22.04
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              echo '<html><body><h1>Frontend Running</h1></body></html>' > /var/www/html/index.html
              systemctl restart nginx
              EOF

  tags = {
    Name = "frontend-server"
  }
}

resource "aws_instance" "backend_instance" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              # Add AWS ECR login
              aws ecr get-login-password --region ${var.region} | \
                docker login --username AWS --password-stdin ${var.docker_image.split("/")[0]}
              
              # Run the container
              docker run -d -p 9090:8080 \
                --name springboot-app \
                ${var.docker_image}
              EOF

  tags = {
    Name = "backend-server"
  }
}
