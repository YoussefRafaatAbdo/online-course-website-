# ============================================
# provider.tf - AWS Provider Configuration
# Fixed: added required_providers block + version pinning
# ============================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Best practice: tag all resources for cost tracking
  default_tags {
    tags = {
      Project     = "ECourses"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
