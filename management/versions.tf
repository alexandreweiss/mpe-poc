terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = ">= 1.3.1"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_r1_location
}
