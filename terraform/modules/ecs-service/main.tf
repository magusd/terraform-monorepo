resource "aws_ecs_service" "service" {
  name                   = var.name
  cluster                = var.name
  task_definition        = aws_ecs_task_definition.service.arn
  desired_count          = 1
  enable_execute_command = true
  force_new_deployment   = true
  launch_type            = "FARGATE"
  propagate_tags         = "TASK_DEFINITION"

  dynamic "load_balancer" {
    for_each = var.tasks
    content {
      target_group_arn = aws_lb_target_group.this[load_balancer.key].arn
      container_name   = load_balancer.key
      container_port   = load_balancer.value.port
    }
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }
}


resource "aws_ecs_task_definition" "service" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.role.arn
  task_role_arn            = aws_iam_role.role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = sum([for name, service in var.tasks : try(service.cpu, 256)])
  memory                   = sum([for name, service in var.tasks : try(service.memory, 512)])
  container_definitions = jsonencode([
    for name, service in var.tasks :
    {
      name        = name
      image       = service.image
      cpu         = try(service.cpu, 256)
      memory      = try(service.memory, 512)
      essential   = true
      environment = [for k, v in zipmap(data.aws_ssm_parameters_by_path.secrets.names, data.aws_ssm_parameters_by_path.secrets.values) : { name : element(split("/", k), length(split("/", k)) - 1), value : v }]
      portMappings = [
        {
          containerPort = service.port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
