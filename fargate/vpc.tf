module "vpc" {
  source    = "cloudposse/vpc/aws"
  version   = "2.1.1"
  namespace = var.namespace
  stage     = var.stage
  name      = var.app_name

  ipv4_primary_cidr_block = "10.0.0.0/16"

  assign_generated_ipv6_cidr_block = false
}

module "dynamic_subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  namespace          = var.namespace
  stage              = var.stage
  name               = var.app_name
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
