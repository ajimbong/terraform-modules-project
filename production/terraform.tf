terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
  backend "s3" {
    bucket = "terrabackend-demo"
    key = "tfstate/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state-lock"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}