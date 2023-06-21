terraform {
  required_version = ">= 1.4.1"
  backend "s3" {
    key            = "accounts/development/terraform.tfstate"
    bucket         = "foocompany-vitor-backend-state"
    dynamodb_table = "foocompany-vitor-backend-lock"
    region         = "us-east-1"
    encrypt        = true
    profile        = "foocompany-shared-resources"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "foocompany-development"
  region  = "us-east-1"
  default_tags {
    tags = {
      "Terraform" = "true"
      "Env"       = "dev"
      "VcsUrl"    = "https://github.com/redguava/2023-ops-hiring-vitor"
      "Project"   = "AccountBaseline"
      "Team"      = "DevOps"
    }
  }
}
