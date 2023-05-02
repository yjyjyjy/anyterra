locals {
  iam_role_name = "${var.resource_prefix}_ecs_agent_role"
}

# variables
variable "resource_prefix" { type = string }

# data sources
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# resources
resource "aws_iam_role" "ecs_agent" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# outputs
output "iam_role_arn" {
  value = aws_iam_role.ecs_agent.arn
}

output "iam_role_name" {
  value = aws_iam_role.ecs_agent.name
}
