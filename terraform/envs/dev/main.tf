locals {
  root    = "${path.cwd}/../../../"
  name    = "foocompany-dev"
  service = "rg-ops-dev"
  vpc_id  = "vpc-07e8abcd2f2141563"
  tag     = var.image_label == "" ? "development" : var.image_label
  domain  = "seeclops.com"
}


module "tg_ops" {
  source          = "../../modules/ecs-service"
  name            = local.name
  vpc_id          = local.vpc_id
  subnets         = data.aws_subnets.private.ids
  security_groups = [data.aws_security_group.private.id]
  alb_arn         = data.aws_lb.this.arn
  domain          = local.domain
  tasks = {
    tg_ops : {
      image = "984855687104.dkr.ecr.us-east-1.amazonaws.com/rg-ops:${local.tag}"
      port  = 3000
      fqdn  = "api.dev.${local.domain}"
    }
  }
  providers = {
    # aws = aws
    aws.shared-resources = aws.shared-resources
  }
}

