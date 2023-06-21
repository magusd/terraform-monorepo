terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    key            = "envs/dev/tg-ops/terraform.tfstate"
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

locals {
  tags = {
    "Terraform" = "true"
    "Env"       = "dev"
    "VcsUrl"    = "https://github.com/redguava/2023-ops-hiring-vitor"
    "Project"   = "AccountBaseline"
    "Team"      = "SoftwareEngineering"
  }
}


provider "aws" {
  profile = "foocompany-development"
  region  = "us-east-1"
  default_tags {
    tags = local.tags
  }
}
provider "aws" {
  alias   = "shared-resources"
  profile = "foocompany-shared-resources"
  region  = "us-east-1"
  default_tags {
    tags = local.tags
  }
}
