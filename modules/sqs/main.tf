locals {
  sqs_queue_name     = "${var.resource_prefix}" # "${var.resource_prefix}.fifo"
  sqs_dlq_queue_name = "${var.resource_prefix}-dlq" # "${var.resource_prefix}-dlq.fifo"
}

resource "aws_sqs_queue" "sqs_queue" {
  name       = local.sqs_queue_name
  fifo_queue = false

  visibility_timeout_seconds = var.queue_visibility_timeout_seconds
  message_retention_seconds  = var.queue_message_retention_seconds
  receive_wait_time_seconds  = var.queue_receive_wait_time_seconds
  max_message_size           = var.queue_max_message_size
  delay_seconds              = var.queue_delay_seconds
}

resource "aws_sqs_queue" "dlq_queue" {
  name       = local.sqs_dlq_queue_name
  fifo_queue = false

  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  message_retention_seconds  = var.dlq_message_retention_seconds
  receive_wait_time_seconds  = var.dlq_receive_wait_time_seconds
  max_message_size           = var.dlq_max_message_size
  delay_seconds              = var.dlq_delay_seconds

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.sqs_queue.arn]
  })
}

