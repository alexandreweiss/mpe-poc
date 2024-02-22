terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
  # cloud {
  #   organization = "ananableu"
  #   workspaces {
  #     name = "mpe-poc"
  #   }
  # }
}

provider "aviatrix" {
  controller_ip = var.controller_ip
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
