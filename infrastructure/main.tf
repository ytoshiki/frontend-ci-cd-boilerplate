// terraform uses default profile if profile is not specified
// $ cat ~/.aws/credentials
provider "aws" {
  region = "ap-northeast-1"
  #   profile = "profile_name"
}

terraform {
  backend "s3" {
    bucket = "frontend-boilerplate-tf-state"
    # terraform uses the key to store the states
    key     = "frontend-boilerplate.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

locals {
  # terraform.workspace is going to be production, staging, development, and so on
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    # Keys can be called whatever you want
    Environment = terraform.workspace
    Project     = var.project
    ManageBy    = "Terraform"
    Owner       = "Toshiki Yoshioka"
  }
}
