terraform {
  backend "s3" {
    bucket = "sam-terraform-state-48291"
    key    = "project/terraform.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "My First Terraform Bucket"
    Environment = "learning"
    ManagedBy   = "terraform"
  }
}
