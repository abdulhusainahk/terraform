provider "aws" {
  region  = "us-east-1"
  profile = "project"
}

terraform {
  backend "s3" {
    bucket  = "terrform-bucket"
    key     = "terraform/aws-dev/key-pair/terraform.tfstate"
    profile = "project"
    region  = "us-east-1"
  }
}