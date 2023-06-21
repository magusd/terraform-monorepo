module "github_oidc_role" {
  source      = "../../modules/github-oidc-role"
  github_org  = "redguava"
  github_repo = "2023-ops-hiring-vitor*"
}

module "tf_backend" {
  source          = "../../modules/terraform-state-management"
  bucket_name     = "foocompany-vitor-backend-state"
  lock_table_name = "foocompany-vitor-backend-lock"
}

module "cross_account_role" {
  source = "../../modules/github-actions-role"
  trusted_roles = [
    "arn:aws:iam::984855687104:role/github"
  ]
}

module "ecr" {
  for_each = local.ecr_repositories
  source   = "../../modules/ecr"
  name     = each.key
  shared_with = [
    "984855687104",
    "950001364817"
  ]
}


resource "aws_route53_zone" "dns" {
  name = "seeclops.com"
}
