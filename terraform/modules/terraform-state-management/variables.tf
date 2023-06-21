variable "lock_table_name" {
  type        = string
  description = "The name of the DynamoDB table used for state locking."
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket used for state storage."
}
