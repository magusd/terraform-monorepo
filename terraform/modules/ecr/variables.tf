variable "name" {
  type        = string
  description = "Name of the ECR repository"

}

variable "shared_with" {
  type        = list(string)
  description = "List of aws accounts to share this repo with"
}