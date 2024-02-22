# We deploy two spokes with overlapping CIDRs but advertising different /32 IP address to be used for inbound
# Spoke A
module "aws_r1_spoke_a_app1_nat" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud                            = "AWS"
  name                             = "aws-${var.aws_r1_location_short}-spoke-a-${var.application_1}-${var.customer_name}"
  cidr                             = var.aws_r1_spoke_app1_nat_cidr
  region                           = var.aws_r1_location
  account                          = var.aws_account
  transit_gw                       = module.aws_transit_r1.transit_gateway.gw_name
  attached                         = true
  ha_gw                            = false
  single_az_ha                     = false
  included_advertised_spoke_routes = "${var.aws_r1_spoke_a_app1_advertised_ip}/32"
}

# Spoke B
module "aws_r1_spoke_b_app1_nat" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.6.7"

  cloud                            = "AWS"
  name                             = "aws-${var.aws_r1_location_short}-spoke-b-${var.application_1}-${var.customer_name}"
  cidr                             = var.aws_r1_spoke_app1_nat_cidr
  region                           = var.aws_r1_location
  account                          = var.aws_account
  transit_gw                       = module.aws_transit_r1.transit_gateway.gw_name
  attached                         = true
  ha_gw                            = false
  single_az_ha                     = false
  included_advertised_spoke_routes = "${var.aws_r1_spoke_b_app1_advertised_ip}/32"
}

## Deploy Linux as Application 1 server in spoke a
module "aws_r1_spoke_a_app1_nat_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_1

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t3a.small"
  key_name      = module.key_pair_r1.key_pair_name

  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_a_app1_nat.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_all_internal_vpc_r1_spoke_a_app1_nat.id, aws_security_group.allow_ec2_connect_r1_spoke_a_app1_nat.id]
  user_data = templatefile("${path.module}/2_set-host.tpl",
    {
      name           = "aws-${var.aws_r1_location_short}-${var.application_1}-spoke-a",
      admin_password = var.admin_password
  })
  user_data_replace_on_change = true

  tags = {
    Application = var.application_1
  }
}

resource "aws_security_group" "allow_all_internal_vpc_r1_spoke_a_app1_nat" {
  name        = "allow_all_internal_vpc_${var.aws_r1_location_short}_app1_nat"
  description = "allow_all_internal_vpc"
  vpc_id      = module.aws_r1_spoke_a_app1_nat.vpc.vpc_id

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

resource "aws_security_group" "allow_ec2_connect_r1_spoke_a_app1_nat" {
  name        = "allow_ec2_connect_${var.aws_r1_location_short}_app1_nat"
  description = "allow_ec2_connect"
  vpc_id      = module.aws_r1_spoke_a_app1_nat.vpc.vpc_id

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

## Deploy Linux as Application 1 server in spoke B
module "aws_r1_spoke_b_app1_nat_vm" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.application_1

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t3a.small"
  key_name      = module.key_pair_r1.key_pair_name

  monitoring                  = true
  subnet_id                   = module.aws_r1_spoke_b_app1_nat.vpc.private_subnets[0].subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_all_internal_vpc_r1_spoke_b_app1_nat.id, aws_security_group.allow_ec2_connect_r1_spoke_b_app1_nat.id]
  user_data = templatefile("${path.module}/2_set-host.tpl",
    {
      name           = "aws-${var.aws_r1_location_short}-${var.application_1}-spoke-b",
      admin_password = var.admin_password
  })
  user_data_replace_on_change = true

  tags = {
    Application = var.application_1
  }
}

resource "aws_security_group" "allow_all_internal_vpc_r1_spoke_b_app1_nat" {
  name        = "allow_all_internal_vpc_${var.aws_r1_location_short}_app1_nat"
  description = "allow_all_internal_vpc"
  vpc_id      = module.aws_r1_spoke_b_app1_nat.vpc.vpc_id

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

resource "aws_security_group" "allow_ec2_connect_r1_spoke_b_app1_nat" {
  name        = "allow_ec2_connect_${var.aws_r1_location_short}_app1_nat"
  description = "allow_ec2_connect"
  vpc_id      = module.aws_r1_spoke_b_app1_nat.vpc.vpc_id

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

# NAT rule configuration for each spoke
module "aws_r1_spoke_a_app1_nat_rules" {
  source  = "terraform-aviatrix-modules/mc-overlap-nat-spoke/aviatrix"
  version = "1.1.1"

  #Tip, use count on the module to create or destroy the NAT rules based on spoke gateway attachement
  #Example: count = var.attached ? 1 : 0 #Deploys the module only if var.attached is true.

  spoke_gw_object = module.aws_r1_spoke_a_app1_nat.spoke_gateway
  spoke_cidrs     = [var.aws_r1_spoke_app1_nat_cidr]
  transit_gw_name = module.aws_transit_r1.transit_gateway.gw_name
  gw1_snat_addr   = var.aws_r1_spoke_a_app1_advertised_ip
  dnat_rules = {
    rule1 = {
      dst_cidr  = "${var.aws_r1_spoke_a_app1_advertised_ip}/32",
      dst_port  = "22",
      protocol  = "tcp",
      dnat_ips  = module.aws_r1_spoke_a_app1_nat_vm.private_ip,
      dnat_port = "22",
    }
  }
  depends_on = [module.aws_r1_spoke_a_app1_nat]
}

module "aws_r1_spoke_b_app1_nat_rules" {
  source  = "terraform-aviatrix-modules/mc-overlap-nat-spoke/aviatrix"
  version = "1.1.1"

  #Tip, use count on the module to create or destroy the NAT rules based on spoke gateway attachement
  #Example: count = var.attached ? 1 : 0 #Deploys the module only if var.attached is true.

  spoke_gw_object = module.aws_r1_spoke_b_app1_nat.spoke_gateway
  spoke_cidrs     = [var.aws_r1_spoke_app1_nat_cidr]
  transit_gw_name = module.aws_transit_r1.transit_gateway.gw_name
  gw1_snat_addr   = var.aws_r1_spoke_b_app1_advertised_ip
  dnat_rules = {
    rule1 = {
      dst_cidr  = "${var.aws_r1_spoke_b_app1_advertised_ip}/32",
      dst_port  = "22",
      protocol  = "tcp",
      dnat_ips  = module.aws_r1_spoke_b_app1_nat_vm.private_ip,
      dnat_port = "22",
    }
  }
  depends_on = [module.aws_r1_spoke_b_app1_nat]
}
