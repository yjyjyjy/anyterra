output "sqs_queue_arn" {
  value = aws_sqs_queue.sqs_queue.arn
}

output "sqs_queue_name" {
  value = aws_sqs_queue.sqs_queue.name
}

output "dlq_queue_arn" {
  value = aws_sqs_queue.dlq_queue.arn
}

output "dlq_queue_name" {
  value = aws_sqs_queue.dlq_queue.name
}

