output "task_definition_revision_arn" {
  value = aws_ecs_task_definition.default.arn
}

output "task_definition_family_arn" {
  value = aws_ecs_task_definition.default.arn_without_revision
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.default.revision
}
