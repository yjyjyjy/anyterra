locals {
  cluster_name        = "${replace(var.resource_prefix,"_","-")}-cluster"
  subnet_group_name   = "${replace(var.resource_prefix,"_","-")}-subnet-group"
  security_group_name = "${var.resource_prefix}_sg"
  security_group_desc = "${var.resource_prefix} redis sg"
  redis_port          = 6379
}

# variables
variable "resource_prefix"              { type = string }

variable "node_type"                    { type = string }
variable "num_cache_nodes"              { type = string }

variable "engine_version"               { type = string }
variable "auto_minor_version_upgrade"   { type = bool }
variable "apply_immediately"            { type = bool }

variable "snapshot_retention_limit"     { type = string }

variable "vpc_id"                       { type = string }
variable "subnet_ids"                   { type = list }
variable "ingress_sgs"                  { type = list }


# resources
resource "aws_security_group" "default" {
  name        = local.security_group_name
  description = local.security_group_desc
  vpc_id      = var.vpc_id

  ingress {
    description     = "allow_ingress"
    from_port       = local.redis_port
    to_port         = local.redis_port
    protocol        = "tcp"
    security_groups = var.ingress_sgs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = local.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "default" {
  cluster_id                 = local.cluster_name
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_nodes            = var.num_cache_nodes
  port                       = local.redis_port
  security_group_ids         = [aws_security_group.default.id]
  subnet_group_name          = aws_elasticache_subnet_group.default.name
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  snapshot_retention_limit   = var.snapshot_retention_limit
}
