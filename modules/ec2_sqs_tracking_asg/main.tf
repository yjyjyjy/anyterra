locals {
  autoscaling_group_name  = "${var.resource_prefix}_cluster_asg"
  launch_type_name_prefix = "${var.resource_prefix}_lt"
  autoscaling_policy_name = "${var.resource_prefix}_scaling_policy"

  security_group_name = "${var.resource_prefix}_asg_sg"
  security_group_desc = "${var.resource_prefix} asg sg"
}

locals {
  user_data_template_file_path = "${path.module}/templates/userdata.tftpl"
}

data "template_file" "asg_user_data" {
  template = file(local.user_data_template_file_path)
  vars = {
    ecs_cluster_name = var.ecs_cluster_name
  }
}

resource "aws_iam_instance_profile" "asg_instance_profile" {
  name = "${var.resource_prefix}_instance_profile"
  role = var.instance_iam_role_name
}

resource "aws_security_group" "default" {
  name        = local.security_group_name
  description = local.security_group_desc
  vpc_id      = var.vpc_id

  ingress {
    description = "allow_ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_ipv4_ips
  }

  ingress {
    description = "allow_ingress"
    from_port   = 7860
    to_port     = 7860
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_ipv4_ips
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_launch_template" "default" {
  name_prefix   = local.launch_type_name_prefix
  instance_type = var.instance_type
  image_id      = var.image_id
  key_name      = var.access_key_name
  user_data     = base64encode(data.template_file.asg_user_data.rendered)
  instance_market_options {
    market_type = "spot"
    # spot_options {
    #   max_price = var.max_price
    # }
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 80
      encrypted             = true
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.asg_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.default.id]
  }
}

resource "aws_autoscaling_group" "default" {
  name                  = local.autoscaling_group_name
  vpc_zone_identifier   = var.subnet_ids_list
  min_size              = var.min_size
  max_size              = var.max_size
  protect_from_scale_in = false
  health_check_type     = "EC2"

  launch_template {
    id      = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      skip_matching = false
    }
  }
}

resource "aws_autoscaling_policy" "default" {
  autoscaling_group_name = aws_autoscaling_group.default.name
  name                   = local.autoscaling_policy_name
  enabled                = true
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = var.target_capacity
    customized_metric_specification {
      metrics {
        id          = "target"
        label       = "message_per_worker"
        return_data = true
        expression  = "(mFree/3 + mPremium) / nWorkers"
      }

      metrics {
        id          = "mFree"
        label       = "free_users_visible_messages"
        return_data = false
        metric_stat {
          stat = "Average"
          metric {
            namespace   = "AWS/SQS"
            metric_name = "ApproximateNumberOfMessagesVisible"
            dimensions {
              name  = "QueueName"
              value = var.free_users_sqs_queue_name
            }
          }
        }
      }

      metrics {
        id          = "mPremium"
        label       = "premium_users_visible_messages"
        return_data = false
        metric_stat {
          stat = "Average"
          metric {
            namespace   = "AWS/SQS"
            metric_name = "ApproximateNumberOfMessagesVisible"
            dimensions {
              name  = "QueueName"
              value = var.premium_users_sqs_queue_name
            }
          }
        }
      }

      metrics {
        id          = "nWorkers"
        label       = "number_of_workers"
        return_data = false
        metric_stat {
          stat = "Average"
          metric {
            namespace   = "ECS/ContainerInsights"
            metric_name = "RunningTaskCount"
            dimensions {
              name  = "ClusterName"
              value = var.ecs_cluster_name
            }
          }
        }
      }
    }
  }
}
