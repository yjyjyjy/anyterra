variable "resource_prefix"              { type = string }

variable "worker_ecs_cluster_name"      { type = string }
variable "worker_ecs_service_name"      { type = string }

variable "sqs_queue_name"               { type = string }
variable "dlq_queue_name"               { type = string }


locals {
  dashboard_name                = "${var.resource_prefix}-dashboard"
  dashboard_template_file_path  = "${path.module}/templates/dashboard_source.tftpl"
    dashboard_template_vars     = {
    AWS_REGION              = data.aws_region.current.id

    WORKER_ECS_CLUSTER_NAME = var.worker_ecs_cluster_name
    WORKER_ECS_SERVICE_NAME = var.worker_ecs_service_name

    SQS_QUEUE_NAME          = var.sqs_queue_name
    DLQ_QUEUE_NAME          = var.dlq_queue_name
  }
}

data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "default" {
  dashboard_name = local.dashboard_name
  dashboard_body = templatefile(local.dashboard_template_file_path, local.dashboard_template_vars)
}