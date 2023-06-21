resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.cluster_name}"
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      #   kms_key_id = aws_kms_key.example.arn
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

