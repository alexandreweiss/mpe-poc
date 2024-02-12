module "aws_r1_spoke_app1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud        = "AWS"
  name         = "aws-${var.aws_r1_location_short}-spoke-${var.application_1}-${var.customer_name}"
  cidr         = var.aws_r1_spoke_app1_cidr
  region       = var.aws_r1_location
  account      = var.aws_account
  transit_gw   = module.aws_transit_r1.transit_gateway.gw_name
  attached     = true
  ha_gw        = false
  single_az_ha = false
}

## Deploy Linux as Application 1 server
module "aws_r1_app1_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_1

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t3a.small"
  key_name                    = module.key_pair_r1.key_pair_name
  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_app1.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_all_internal_vpc_r1_app1.id, aws_security_group.allow_ec2_connect_r1_app1.id]

  tags = {
    Application = var.application_1
  }
}

module "aws_r1_spoke_app2" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud        = "AWS"
  name         = "aws-${var.aws_r1_location_short}-spoke-${var.application_2}-${var.customer_name}"
  cidr         = var.aws_r1_spoke_app2_cidr
  region       = var.aws_r1_location
  account      = var.aws_account
  transit_gw   = module.aws_transit_r1.transit_gateway.gw_name
  attached     = true
  ha_gw        = false
  single_az_ha = false
}

## Deploy Linux as Application 2 server
module "aws_r1_app2_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_2

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t3a.small"
  key_name                    = module.key_pair_r1.key_pair_name
  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_app2.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_all_internal_vpc_r1_app2.id, aws_security_group.allow_ec2_connect_r1_app2.id]

  tags = {
    Application = var.application_2
  }
}

resource "aws_security_group" "allow_all_internal_vpc_r1_app1" {
  name        = "allow_all_internal_vpc_${var.aws_r1_location_short}_app1"
  description = "allow_all_internal_vpc"
  vpc_id      = module.aws_r1_spoke_app1.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_internal_vpc"
  }
}

resource "aws_security_group" "allow_ec2_connect_r1_app1" {
  name        = "allow_ec2_connect_${var.aws_r1_location_short}_app1"
  description = "allow_ec2_connect"
  vpc_id      = module.aws_r1_spoke_app1.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ec2_connect_src_ip_r1
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ec2_connect"
  }
}

resource "aws_security_group" "allow_all_internal_vpc_r1_app2" {
  name        = "allow_all_internal_vpc_${var.aws_r1_location_short}_app2"
  description = "allow_all_internal_vpc"
  vpc_id      = module.aws_r1_spoke_app2.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_internal_vpc"
  }
}

resource "aws_security_group" "allow_ec2_connect_r1_app2" {
  name        = "allow_ec2_connect_${var.aws_r1_location_short}_app2"
  description = "allow_ec2_connect"
  vpc_id      = module.aws_r1_spoke_app2.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ec2_connect_src_ip_r1
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ec2_connect"
  }
}

## Deploy VPN gateway

# resource "aviatrix_gateway" "aws_r1_vpn_0" {
#   cloud_type       = 1
#   account_name     = var.aws_account
#   gw_name          = "aws-${var.aws_r1_location_short}-vpn-0-${var.customer_name}"
#   vpc_id           = module.aws_r1_spoke_app1.vpc.vpc_id
#   vpc_reg          = var.aws_r1_location
#   gw_size          = "t3.small"
#   subnet           = module.aws_r1_spoke_app1.vpc.public_subnets[0].cidr
#   vpn_access       = true
#   vpn_cidr         = var.aws_r1_vpn_user_cidr
#   additional_cidrs = var.aws_r1_vpn_tunnel_cidr
#   max_vpn_conn     = "100"
#   split_tunnel     = true
#   enable_vpn_nat   = true
#   vpn_protocol     = "TCP"
# }

# ## User VPN
# resource "aviatrix_vpn_user" "aweiss" {

#   user_email = var.vpn_user_email
#   user_name  = var.vpn_user_name
#   gw_name    = aviatrix_gateway.aws_r1_vpn_0.gw_name
#   vpc_id     = module.aws_r1_spoke_app1.vpc.vpc_id

#   depends_on = [aviatrix_gateway.aws_r1_vpn_0]
# }
