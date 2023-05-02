# resource naming
locals {
  task_definition_family = var.resource_prefix

  task_manager_name     = "task_manager"
  task_manager_hostname = "taskManager"

  worker_name     = "worker"
  worker_hostname = "worker"

  efs_mount_volume_name = "efs_mount"
}

# module configuration
locals {
  worker_definitations_template_file_path = "${path.module}/templates/worker_definitation.tftpl"
  retain_old_task_definitation_revisions  = true
}

# worker definition template
data "template_file" "container_definitions" {
  template = file(local.worker_definitations_template_file_path)
  vars = {
    task_manager_name               = local.task_manager_name
    task_manager_image              = var.task_manager_docker_image
    task_manager_cmd                = var.task_manager_cmd
    task_manager_cpu                = var.task_manager_cpu
    task_manager_memory             = var.task_manager_memory
    task_manager_memory_reservation = var.task_manager_memory_reservation
    task_manager_hostname           = local.task_manager_hostname

    worker_name                  = local.worker_name
    worker_image                 = var.worker_docker_image
    worker_cmd                   = var.worker_cmd
    worker_cpu                   = var.worker_cpu
    worker_memory                = var.worker_memory
    worker_memory_reservation    = var.worker_memory_reservation
    worker_gpu_requirement_count = var.worker_gpu_requirement_count
    worker_hostname              = local.worker_hostname

    efs_source_volume_name      = local.efs_mount_volume_name
    worker_container_mount_path = var.efs_container_mount_point
  }
}

# resources
resource "aws_ecs_task_definition" "default" {
  family = local.task_definition_family

  container_definitions = data.template_file.container_definitions.rendered

  task_role_arn = var.task_iam_role_arn
  network_mode  = "host"
  cpu           = var.ecs_task_cpu_hard_limit
  memory        = var.ecs_task_memory_hard_limit

  requires_compatibilities = ["EC2"]
  skip_destroy             = local.retain_old_task_definitation_revisions

  volume {
    name = local.efs_mount_volume_name
    efs_volume_configuration {
      file_system_id = var.efs_filesystem_id
      root_directory = var.efs_root_directory
    }
  }
}
