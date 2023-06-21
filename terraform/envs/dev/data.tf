data "aws_lb" "this" {
  name = local.name
}
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  tags = {
    Tier = "Public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  tags = {
    Tier = "Private"
  }
}

data "aws_security_group" "public" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  tags = {
    Tier = "Public"
  }
}

data "aws_security_group" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  tags = {
    Tier = "Private"
  }
}
