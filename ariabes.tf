variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
}

variable "docker_image" {
  description = "Docker image name"
  default = "ecourses:latest"
}
