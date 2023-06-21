//role for cross account assume role
resource "aws_iam_role" "cross_account_role" {
  name               = "github_cross_account_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": ${jsonencode(var.trusted_roles)}
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//allow cross_account_role admin access to the account
resource "aws_iam_role_policy_attachment" "cross_account_role_admin" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}