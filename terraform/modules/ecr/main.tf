resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}


# data "aws_iam_policy_document" "account_sharing_policy" {
#   statement {
#     sid    = "new policy"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = var.shared_with
#     }

#     actions = [
#       "ecr:*",
#     ]
#   }
# }


resource "aws_ecr_repository_policy" "ecr_repo_account_sharing" {
  repository = aws_ecr_repository.ecr_repo.name
  #   policy     = data.aws_iam_policy_document.account_sharing_policy.json
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ecr-account-sharing",
        Effect = "Allow",
        Principal = {
          "AWS" : var.shared_with
        },
        Action = [
          "ecr:*"
        ],
        # Resource = [
        #   "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/*"
        # ]
      }
    ]
  })
}