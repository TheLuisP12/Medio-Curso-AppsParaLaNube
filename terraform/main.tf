provider "aws" {
  region = "us-east-2" # Ajusta la región según tu preferencia
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  key_name = "PSWD-AWS-Ponce" # Reemplaza con tu par de claves

  user_data = file("ec2-init.sh") # Script de configuración inicial para instalar Node.js

  tags = {
    Name = "RecipesAppInstance"
  }

  # Security Group to allow HTTP and SSH access
  security_groups = [aws_security_group.allow_http_ssh.name]
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
