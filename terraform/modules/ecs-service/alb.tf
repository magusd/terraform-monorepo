resource "aws_lb_target_group" "this" {
  for_each             = var.tasks
  name_prefix          = replace(substr(each.key, 0, 6), "_", "-")
  port                 = each.value.port
  deregistration_delay = 60
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  target_type          = "ip"
  vpc_id               = var.vpc_id


  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 7
    path                = "/_/healthcheck"
    protocol            = "HTTP"
    port                = each.value.port
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {
  for_each          = var.tasks
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "this_ssl" {
  for_each          = var.tasks
  load_balancer_arn = var.alb_arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
  certificate_arn = aws_acm_certificate_validation.this.certificate_arn
}


resource "aws_route53_record" "fqdn_cname" {
  for_each = var.tasks
  name     = each.value.fqdn
  zone_id  = data.aws_route53_zone.domain.zone_id
  type     = "CNAME"
  ttl      = 60
  records  = [data.aws_lb.alb.dns_name]
  provider = aws.shared-resources
}
