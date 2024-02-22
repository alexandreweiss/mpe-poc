## Deploy Guacamole remote access machine

resource "aws_security_group" "allow_web_ssh_public" {
  name        = "allow_web_ssh_public"
  description = "allow_web_ssh_public"
  vpc_id      = module.aws_r1_spoke_app1.vpc.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.source_ip_cidrs
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.source_ip_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_ssh_public"
  }
}

module "ec2_instance_guacamole" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "guacamole-jump-server"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3a.small"
  key_name                    = module.key_pair_r1.key_pair_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.allow_web_ssh_public.id]
  subnet_id                   = module.aws_r1_spoke_app1.vpc.public_subnets[0].subnet_id
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/3_jumpbox.tpl", {
    hostname_r1_app1             = module.aws_r1_app1_vm.private_ip
    hostname_r1_app2             = module.aws_r1_app2_vm.private_ip
    hostname_r2_app1             = module.aws_r2_app1_vm.private_ip
    hostname_r2_app2             = module.aws_r2_app2_vm.private_ip
    hostname_r1_spoke_a_app1_nat = var.aws_r1_spoke_a_app1_advertised_ip
    hostname_r1_spoke_b_app1_nat = var.aws_r1_spoke_b_app1_advertised_ip
    aws_r1_location_short        = var.aws_r1_location_short
    aws_r2_location_short        = var.aws_r2_location_short
    application_1                = var.application_1
    application_2                = var.application_2
    username                     = "ubuntu"
  admin_password = var.admin_password })
  user_data_replace_on_change = true
  tags = {
    Cloud       = "AWS"
    Application = "Jump Server"
  }
}

# Assign an EIP to Guacamole so that the URL doesn't change across reboots
resource "aws_eip" "guacamole" {
  instance                  = module.ec2_instance_guacamole.id
  associate_with_private_ip = module.ec2_instance_guacamole.private_ip
}

