output "autoscaling_group_id" {
  value = aws_autoscaling_group.default.id
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.default.arn
}

output "asg_sg_id" {
  value = aws_security_group.default.id
}
