provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "Project-17"
      ManagedBy = "Terraform"
    }
  }
}
