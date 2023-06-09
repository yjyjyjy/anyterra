locals {
  worker_service_name = "${var.resource_prefix}_worker_service"
}

# variables
variable "resource_prefix" { type = string }
variable "ecs_cluster_arn" { type = string }
variable "service_task_definition_arn" { type = string }

# resources
resource "aws_ecs_service" "default" {
  name                = local.worker_service_name
  cluster             = var.ecs_cluster_arn
  task_definition     = var.service_task_definition_arn
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
}

# outputs
output "worker_service_arn" {
  value = aws_ecs_service.default.id
}

output "worker_service_name" {
  value = aws_ecs_service.default.name
}
