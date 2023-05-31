# module "s3_artifact_bucket" {
#   source      = "./modules/s3_bucket"
#   bucket_name = local.artifact_bucket_name
# }

module "iam_ecs_task_role" {
  source = "./modules/iam_ecs_task_role"

  resource_prefix                  = local.resource_prefix
  cloudwatch_log_group_name_prefix = local.resource_prefix
  sqs_queue_name_prefix            = local.resource_prefix
  s3_bucket_arn                    = local.artifact_bucket_arn
}

module "ecs_agent_iam" {
  source          = "./modules/iam_ecs_agent_role"
  resource_prefix = local.resource_prefix
}

module "ecs_cluster" {
  source          = "./modules/ecs_cluster"
  resource_prefix = local.resource_prefix
}

module "ecs_cluster_asg" {
  source          = "./modules/ec2_sqs_tracking_asg"
  resource_prefix = local.resource_prefix

  min_size = local.asg_min_size
  max_size = local.asg_max_size

  instance_type          = local.asg_instance_type
  image_id               = local.asg_image_id
  instance_iam_role_name = module.ecs_agent_iam.iam_role_name
  access_key_name        = local.access_key_name #"aws" # TODO: Fix
  ssh_ingress_ipv4_ips   = local.asg_ssh_ips

  vpc_id          = local.global_vpc_id
  subnet_ids_list = local.global_subnet_ids
  target_capacity = local.asg_target_capacity

  ecs_cluster_name             = module.ecs_cluster.ecs_cluster_name
  ecs_service_name             = module.ecs_worker_service.worker_service_name # TODO: can induce a cyclic dependence.
  free_users_sqs_queue_name    = module.sqs_queue_free.sqs_queue_name
  premium_users_sqs_queue_name = module.sqs_queue_premium.sqs_queue_name
}

module "automatic_111_task_definition" {
  source = "modules/ecs_worker_task_definition"

  resource_prefix = local.resource_prefix

  task_manager_docker_image       = local.task_manager_docker_image
  task_manager_cmd                = local.task_manager_cmd
  task_manager_cpu                = local.task_manager_cpu
  task_manager_memory             = local.task_manager_memory
  task_manager_memory_reservation = local.task_manager_memory_reservation

  # worker configuration
  worker_docker_image          = local.worker_docker_image
  worker_cmd                   = local.worker_cmd
  worker_cpu                   = local.worker_cpu
  worker_memory                = local.worker_memory
  worker_memory_reservation    = local.worker_memory_reservation
  worker_gpu_requirement_count = local.worker_gpu_requirement_count

  # # efs configuration
  # efs_filesystem_id         = local.efs_filesystem_id
  # efs_root_directory        = local.efs_root_directory
  # efs_container_mount_point = local.efs_container_mount_point

  # ecs task limits
  ecs_task_cpu_hard_limit    = local.ecs_task_cpu_hard_limit
  ecs_task_memory_hard_limit = local.ecs_task_memory_hard_limit

  # task configuration
  task_iam_role_arn = module.iam_ecs_task_role.worker_role_arn
}

module "ecs_worker_service" {
  source = "./modules/ecs_worker_service"

  resource_prefix               = local.resource_prefix
  ecs_cluster_arn               = module.ecs_cluster.ecs_cluster_arn
  service_task_definition_arn = module.automatic_111_task_definition.task_definition_revision_arn
}

module "sqs_queue_free" {
  source = "./modules/sqs"

  resource_prefix                  = local.free_queues_resource_prefix
  queue_visibility_timeout_seconds = local.free_queue_visibility_timeout_seconds
  queue_message_retention_seconds  = local.free_queue_message_retention_seconds
  queue_receive_wait_time_seconds  = local.free_queue_receive_wait_time_seconds
  queue_max_message_size           = local.free_queue_max_message_size
  queue_delay_seconds              = local.free_queue_delay_seconds

  dlq_visibility_timeout_seconds = local.free_queue_dlq_visibility_timeout_seconds
  dlq_message_retention_seconds  = local.free_queue_dlq_message_retention_seconds
  dlq_receive_wait_time_seconds  = local.free_queue_dlq_receive_wait_time_seconds
  dlq_max_message_size           = local.free_queue_dlq_max_message_size
  dlq_delay_seconds              = local.free_queue_dlq_delay_seconds
}

module "sqs_queue_premium" {
  source = "./modules/sqs"

  resource_prefix                  = local.premium_queue_resource_prefix
  queue_visibility_timeout_seconds = local.premium_queue_visibility_timeout_seconds
  queue_message_retention_seconds  = local.premium_queue_message_retention_seconds
  queue_receive_wait_time_seconds  = local.premium_queue_receive_wait_time_seconds
  queue_max_message_size           = local.premium_queue_max_message_size
  queue_delay_seconds              = local.premium_queue_delay_seconds

  dlq_visibility_timeout_seconds = local.premium_queue_dlq_visibility_timeout_seconds
  dlq_message_retention_seconds  = local.premium_queue_dlq_message_retention_seconds
  dlq_receive_wait_time_seconds  = local.premium_queue_dlq_receive_wait_time_seconds
  dlq_max_message_size           = local.premium_queue_dlq_max_message_size
  dlq_delay_seconds              = local.premium_queue_dlq_delay_seconds
}

# module "redis_cluster" {
#   source = "./modules/redis_cluster"

#   resource_prefix = local.resource_prefix
#   node_type = local.redis_node_type
#   num_cache_nodes = local.redis_num_cache_nodes
#   engine_version = local.redis_engine_version
#   auto_minor_version_upgrade = local.redis_auto_minor_version_upgrade
#   apply_immediately = local.redis_apply_immediately
#   snapshot_retention_limit = local.redis_snapshot_retention_limit
#   vpc_id = local.global_vpc_id
#   subnet_ids = local.global_subnet_ids
#   ingress_sgs = [module.ecs_cluster_asg.asg_sg_id]
# }
