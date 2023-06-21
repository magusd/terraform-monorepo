variable "github_org" {
  description = "GitHub org for the repo with the action that will use this IAM role"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo with the action that will use this IAM role"
  type        = string
}
