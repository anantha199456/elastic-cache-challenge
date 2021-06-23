# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  #access_key = var.AWS_ACCESS_KEY_ID
  #secret_key = var.AWS_SECRET_ACCESS_KEY
}

terraform {
  required_version = ">= 0.13.4"
  backend "s3" {
    bucket = "my-demo-terraform-backend"
    key    = "terraform_cache_tfstate"
    region = "us-east-1"
  }
}
