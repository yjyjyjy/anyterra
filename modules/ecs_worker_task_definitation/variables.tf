variable "resource_prefix"                  { type = string }

# task manager configuration
variable "task_manager_docker_image"        { type = string }
variable "task_manager_cmd"                 { type = string }
variable "task_manager_cpu"                 { type = string }
variable "task_manager_memory"              { type = string }
variable "task_manager_memory_reservation"  { type = string }

# worker configuration
variable "worker_docker_image"              { type = string }
variable "worker_cmd"                       { type = string }
variable "worker_cpu"                       { type = string }
variable "worker_memory"                    { type = string }
variable "worker_memory_reservation"        { type = string }
variable "worker_gpu_requirement_count"     { type = string }

# efs configuration
# variable "efs_filesystem_id"                { type = string }
# variable "efs_root_directory"               { type = string }
# variable "efs_container_mount_point"        { type = string }

# ecs task limits
variable "ecs_task_cpu_hard_limit"          { type = string }
variable "ecs_task_memory_hard_limit"       { type = string }

# task configuration
variable "task_iam_role_arn"                { type = string }
