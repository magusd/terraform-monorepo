data "aws_route53_zone" "domain" {
  name     = var.domain
  provider = aws.shared-resources
}

data "aws_lb" "alb" {
  arn = var.alb_arn
}

data "aws_ssm_parameters_by_path" "secrets" {
  path     = "/apps/env-vars/${var.name}/"
  provider = aws.shared-resources
}
