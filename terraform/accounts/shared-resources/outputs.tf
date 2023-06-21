output "role_arn" {
  value = module.cross_account_role.role_arn
}
output "ecr" {
  value = module.ecr
}

output "dns" {
  value = aws_route53_zone.dns.name_servers
}
