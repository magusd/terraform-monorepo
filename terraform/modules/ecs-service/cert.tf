locals {
  sans = distinct([for _, task in var.tasks : join(".", concat(["*"], slice(split(".", task.fqdn), 1, length(split(".", task.fqdn)))))])


}
resource "aws_acm_certificate" "wildcard" {
  domain_name               = var.domain
  validation_method         = "DNS"
  subject_alternative_names = local.sans
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id

  provider = aws.shared-resources
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

