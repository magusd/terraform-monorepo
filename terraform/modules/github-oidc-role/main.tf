locals {
  role_name = "github"
}

module "iam_role" {
  source  = "unfunco/oidc-github/aws"
  version = "1.5.0"

  attach_read_only_policy = false
  iam_role_name           = local.role_name
  iam_role_policy_arns    = [aws_iam_policy.main.arn]
  github_repositories     = ["${var.github_org}/${var.github_repo}"]
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "main" {
  name        = "${local.role_name}-main"
  description = "Access to provision resources for the ${var.github_repo} repo"

  policy = templatefile("${path.module}/main-policy.json", {
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
