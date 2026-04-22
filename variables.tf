# ============================================
# variables.tf - All Input Variables
# Fixed: "eu-north-1a" was an AZ, not a region!
# ============================================

variable "aws_region" {
  description = "AWS region to deploy into (Free Tier available)"
  type        = string
  default     = "eu-north-1"   # ✅ FIXED: was "eu-north-1a" (that's an AZ, not a region!)
}

variable "instance_type" {
  description = "EC2 instance type — t3.micro is Free Tier in eu-north-1"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of your AWS EC2 Key Pair for SSH access (create in AWS Console first)"
  type        = string
  # No default — you MUST provide this. See deployment guide step 1.
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI for eu-north-1 (Free Tier eligible)"
  type        = string
  default     = "ami-0c1ac8a41498b9c0f"  # Amazon Linux 2023 — eu-north-1 (April 2025)
}

variable "repo_url" {
  description = "Your GitHub repo URL"
  type        = string
  default     = "https://github.com/tomasayman60-cmd/online-course-website-"
}
