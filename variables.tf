variable "customer_name" {
  description = "Name of customer to be used in resources"
  default     = "contoso"
}

variable "aws_r1_location" {
  default     = "us-east-1"
  description = "region to deploy resources"
  type        = string
}

variable "aws_r1_location_short" {
  default     = "use1"
  description = "region to deploy resources"
  type        = string
}

variable "aws_transit_r1_cidr" {
  description = "CIDR block allocated to transit in region r1"
  default     = "10.10.0.0/23"
}

variable "aws_r1_spoke_app1_cidr" {
  description = "CIDR block allocated to spoke 1 in region r1"
  default     = "10.11.0.0/24"
}

variable "aws_r1_spoke_app2_cidr" {
  description = "CIDR block allocated to spoke 2 in region r1"
  default     = "10.12.0.0/24"
}

variable "aws_r2_location" {
  default     = "sa-east-1"
  description = "region to deploy resources"
  type        = string
}

variable "aws_r2_location_short" {
  default     = "sae1"
  description = "region to deploy resources"
  type        = string
}

variable "aws_transit_r2_cidr" {
  description = "CIDR block allocated to transit in region r2"
  default     = "10.20.0.0/23"
}

variable "aws_r2_spoke_app1_cidr" {
  description = "CIDR block allocated to transit in region r2"
  default     = "10.21.0.0/24"
}


variable "aws_r2_spoke_app2_cidr" {
  description = "CIDR block allocated to transit in region r2"
  default     = "10.22.0.0/24"
}

variable "application_1" {
  description = "Name of application 1"
  default     = "MyApp1"
}

variable "application_2" {
  description = "Name of application 2"
  default     = "MyApp2"
}

variable "admin_password" {
  sensitive   = true
  description = "Admin password"
}

variable "aws_account" {
  description = "Name of the AWS account onboarded to controller"
  default     = "aws_admin"
}

variable "controller_ip" {
  description = "IP or FQDN of the target Aviatrix controller"
  type        = string
}
