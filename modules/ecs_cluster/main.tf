locals {
  cluster_name = "${replace(var.resource_prefix,"_","-")}-cluster"
}

variable "resource_prefix" { type = string }

resource "aws_ecs_cluster" "default" {
  name = local.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.default.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.default.arn
}
