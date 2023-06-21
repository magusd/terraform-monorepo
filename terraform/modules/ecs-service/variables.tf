variable "name" {
  type        = string
  description = "name for the app"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "alb_arn" {
  type        = string
  description = "value of the alb arn"
}

variable "subnets" {
  type        = list(string)
  description = "a list subnet ids"
}

variable "security_groups" {
  type        = list(string)
  description = "a list of security group ids"
}

variable "tasks" {
  type        = any
  description = "docker compose like definition"
}

variable "domain" {
  type        = string
  description = "domain name"
}
