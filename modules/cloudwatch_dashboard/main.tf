variable "resource_prefix"              { type = string }

variable "worker_ecs_cluster_name"      { type = string }
variable "worker_ecs_service_name"      { type = string }

variable "free_fifo_queue_name"         { type = string }
variable "premium_fifo_queue_name"      { type = string }
variable "free_fifo_dlq_name"           { type = string }
variable "premium_fifo_dlq_name"        { type = string }


locals {
  dashboard_name                = "${var.resource_prefix}-dashboard"
  dashboard_template_file_path  = "${path.module}/templates/dashboard_source.tftpl"
}

data "aws_region" "current" {}

data "template_file" "dashboard_source" {
  filename = local.dashboard_template_file_path
  vars = {
    AWS_REGION = data.aws_region.current.id

    WORKER_ECS_CLUSTER_NAME = var.worker_ecs_cluster_name
    WORKER_ECS_SERVICE_NAME = var.worker_ecs_service_name

    PREMIUM_FIFO_QUEUE_NAME  = var.premium_fifo_queue_name
    PREMIUM_FIFO_DLQ_NAME    = var.premium_fifo_dlq_name
    FREE_FIFO_QUEUE_NAME     = var.free_fifo_queue_name
    FREE_FIFO_DLQ_NAME       = var.free_fifo_dlq_name
  }
}

resource "aws_cloudwatch_dashboard" "default" {
  dashboard_name = local.dashboard_name
  dashboard_body = data.template_file.dashboard_source.rendered
}