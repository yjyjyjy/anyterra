output "worker_role_name" {
  value = aws_iam_role.worker_iam_role.name
}

output "worker_role_arn" {
  value = aws_iam_role.worker_iam_role.arn
}

