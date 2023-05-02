locals {
  worker_role_name = "${var.resource_prefix}_worker_role"
  worker_policy_name = "${var.resource_prefix}_worker_policy"
}

resource "aws_iam_policy" "worker_iam_policy" {
  name   = local.worker_policy_name
  path   = "/"
  policy = data.aws_iam_policy_document.worker_policy_document.json
}

resource "aws_iam_role" "worker_iam_role" {
  name               = local.worker_role_name
  assume_role_policy = data.aws_iam_policy_document.worker_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "worker_role_policy_attachment" {
  role       = aws_iam_role.worker_iam_role.name
  policy_arn = aws_iam_policy.worker_iam_policy.arn
}
