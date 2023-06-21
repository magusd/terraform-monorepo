module "cross_account_role" {
  source = "../../modules/github-actions-role"
  trusted_roles = [
    "arn:aws:iam::984855687104:role/github"
  ]
}
locals {
  name = "foocompany-dev"
}

module "ecs_cluster" {
  source       = "../../modules/ecs-cluster"
  cluster_name = local.name
}


module "networking" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  # enable_vpn_gateway = true

  private_subnet_tags = {
    Tier = "Private"
  }

  public_subnet_tags = {
    Tier = "Public"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb" "this" {
  name               = local.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = module.networking.public_subnets

  enable_deletion_protection = true
}
