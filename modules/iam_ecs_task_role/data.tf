locals {
  sqs_queue_arn_prefix            = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sqs_queue_name_prefix}"
  cloudwatch_log_group_arn_prefix = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name_prefix}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "worker_assume_role_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "worker_policy_document" {
  statement {
    sid    = "SQSPermissions"
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:ListQueues",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ChangeMessageVisibility",
      "sqs:ReceiveMessage",
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags"
    ]
    resources = ["${local.sqs_queue_arn_prefix}*"]
  }
  statement {
    sid    = "CWLogsPermissions"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${local.cloudwatch_log_group_arn_prefix}*"]
  }
  statement {
    sid    = "S3Permissions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:GetBucketVersioning",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl"
    ]
    resources = ["${var.s3_bucket_arn}*"]
  }
}
