terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-project-state-1185"
    key    = "terraform/backend"
    region = "us-west-2"
  }
}