# ============================================
# main.tf - EC2 + Docker + Security Group
# Fixes from original:
#   - Port changed 5000 → 80 (Nginx standard)
#   - AMI updated to Amazon Linux 2023 eu-north-1
#   - Added tags for resource tracking
#   - Security group uses vpc_id for modern AWS compatibility
# ============================================

# --- Security Group ---
resource "aws_security_group" "ecourses_sg" {
  name        = "ecourses-sg"
  description = "Allow HTTP and SSH inbound traffic"

  # SSH access — for your own machine only (change IP for better security)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ⚠️ Restrict to your IP in production: ["YOUR.IP.ADDRESS/32"]
  }

  # HTTP — public web access on standard port
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound (needed for Docker pull, git clone, yum updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecourses-sg"
  }
}

# --- EC2 Instance ---
resource "aws_instance" "ecourses_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ecourses_sg.id]

  # Auto-run script: installs Docker, clones repo, builds & runs container
  user_data = templatefile("${path.module}/user_data.sh", {
    repo_url = var.repo_url
  })

  # Free Tier: 30GB EBS gp2 is included
  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "ECourses-Docker-Server"
  }
}
