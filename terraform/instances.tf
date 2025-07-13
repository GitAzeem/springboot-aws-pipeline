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
              set -e

              # Update and install Docker and AWS CLI
              sudo apt-get update -y
              sudo apt-get install -y docker.io awscli

              sudo systemctl start docker
              sudo systemctl enable docker

              # Add ubuntu user to docker group
              sudo usermod -aG docker ubuntu

              # ECR login (requires sudo for AWS CLI in some AMIs)
              sudo aws ecr get-login-password --region ${var.region} | \
                sudo docker login --username AWS --password-stdin ${split("/", var.docker_image)[0]}

              # Pull the image
              sudo docker pull ${var.docker_image}

              # Run the container
              nohup sudo docker run -d -p 9090:8080 \
                --name springboot-app \
                ${var.docker_image} > /var/log/springboot-app.log 2>&1 &
              EOF

  tags = {
    Name = "backend-server"
  }
}
