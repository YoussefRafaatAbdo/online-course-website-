resource "aws_security_group" "ecourses_sg" {

  name = "ecourses-sg"

  ingress {
    description = "HTTP Port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "ecourses_server" {

  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [
    aws_security_group.ecourses_sg.name
  ]

  user_data = file("user_data.sh")

  tags = {
    Name = "ECourses-Docker-Server"
  }

}