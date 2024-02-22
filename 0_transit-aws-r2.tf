module "aws_transit_r2" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.5.2"

  cloud                  = "aws"
  region                 = var.aws_r2_location
  cidr                   = var.aws_transit_r2_cidr
  account                = var.aws_account
  enable_transit_firenet = true
  gw_name                = "aws-${var.aws_r2_location_short}-transit-${var.customer_name}"
  name                   = "aws-${var.aws_r2_location_short}-transit-${var.customer_name}"
  ha_gw                  = false
}
