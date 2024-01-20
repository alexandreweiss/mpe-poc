terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
}

provider "aviatrix" {
  controller_ip = "52.45.164.188"
  password      = var.admin_password
  username      = "admin"
}

provider "aws" {
  region = var.aws_r1_location
}

provider "aws" {
  region = var.aws_r2_location
  alias  = "r2"
}