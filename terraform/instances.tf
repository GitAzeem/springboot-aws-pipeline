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

              # Update package lists
              sudo apt-get update -y

              # Install Docker
              sudo apt-get install -y docker.io

              # Install unzip (required for AWS CLI install)
              sudo apt install unzip -y

              # Download and install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              # Enable and start Docker
              sudo systemctl start docker
              sudo systemctl enable docker

              # Add ubuntu user to docker group
              sudo usermod -aG docker ubuntu

              # Wait for group membership to refresh in the current shell
              newgrp docker <<EONG

              # AWS ECR Login
              sudo aws ecr get-login-password --region ${var.region} | \
                  sudo docker login --username AWS --password-stdin ${split("/", var.docker_image)[0]}

              # Pull the Docker image
              sudo docker pull ${var.docker_image}

              # Run the Docker container
              nohup sudo docker run -d -p 9090:8080 \
                  --name springboot-app \
                  ${var.docker_image} > /var/log/springboot-app.log 2>&1 &

              EONG
              EOF


  tags = {
    Name = "backend-server"
  }
}
