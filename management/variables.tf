variable "aws_r1_location" {
  default     = "us-east-1"
  description = "AWS Region to deploy the controller"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "Instance type for the controller."
  default     = "t3.xlarge"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "172.16.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet."
  default     = "172.16.1.0/24"
}

variable "ctrl_label_text" {
  type        = string
  description = "Label text for the contoller. Ex: pod123"
}

variable "ctrl_version" {
  type        = string
  description = "Version of the controller to deploy."
  default     = "latest"
}

variable "account_email" {
  type        = string
  sensitive   = true
  description = "Admin email for the controller."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for the controller."
}

variable "ctrl_customer_id" {
  type        = string
  description = "Customer ID for the controller."
}

variable "template_url" {
  type        = string
  description = "URL for the controller template."
  default     = "https://s3.us-west-2.amazonaws.com/public.aviatrixlab.com/avx_simple_deployment.yaml"
}

variable "access_key" {
  type        = string
  description = "Access key needed to access AWS account to deploy controller and copilot"
}

variable "access_secret" {
  type        = string
  sensitive   = true
  description = "Secret key needed to access AWS account to deploy controller and copilot"
}

variable "allowed_source_ip_https" {
  type        = string
  description = "Default IP CIDR allowed to connect to controller IP"
  default     = "0.0.0.0"
}
