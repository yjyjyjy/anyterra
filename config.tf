locals {
  resource_prefix = "anydream"
  sqs_queue_prefix              = "anydream_queue"
  free_queues_resource_prefix   = "anydream_queue_free"
  premium_queue_resource_prefix = "anydream_queue_premium"
  artifact_bucket_name          = "anydream-gen-storage"
}

locals {
  global_vpc_id = ""        # NOTICE: Fill
  global_subnet_ids = [

  ]                                 # NOTICE: FILL
}

# asg configuration
locals {
  asg_min_size = 1
  asg_max_size = 4

  asg_instance_type   = "g4dn.xlarge"
  asg_image_id        = "ami-05ec607d5b84572e5" # please refer to README
  asg_access_key_name = ""           # NOTICE: FILL

  asg_ssh_ips         = [

  ] # NOTICE: FILL
  asg_target_capacity = 2          # NOTICE: Calibrate
}

# free queue configuration
locals {
  free_queue_visibility_timeout_seconds = 30
  free_queue_message_retention_seconds  = 86400 # 1 Day = 86,400 Seconds
  free_queue_receive_wait_time_seconds  = 0
  free_queue_max_nessage_size           = 262144
  free_queue_delay_seconds              = 0

  free_queue_dlq_visibility_timeout_seconds = 30
  free_queue_dlq_message_retention_seconds  = 345600 # 4 Days = 345600 Seconds
  free_queue_dlq_receive_wait_time_seconds  = 0
  free_queue_dlq_max_nessage_size           = 262144
  free_queue_dlq_delay_seconds              = 0
}

# premium queue configuration
locals {
  premium_queue_visibility_timeout_seconds = 30
  premium_queue_message_retention_seconds  = 86400 # 1 Day = 86,400 Seconds
  premium_queue_receive_wait_time_seconds  = 0
  premium_queue_max_nessage_size           = 262144
  premium_queue_delay_seconds              = 0

  premium_queue_dlq_visibility_timeout_seconds = 30
  premium_queue_dlq_message_retention_seconds  = 345600 # 4 Days = 345600 Seconds
  premium_queue_dlq_receive_wait_time_seconds  = 0
  premium_queue_dlq_max_nessage_size           = 262144
  premium_queue_dlq_delay_seconds              = 0

}

# workers task definitation configuration
locals {
  # task manager configuration
  task_manager_docker_image       = ""      # NOTICE: FILL
  task_manager_cmd                = ""      # NOTICE: FILL
  task_manager_cpu                = ""      # NOTICE: FILL
  task_manager_memory             = ""      # NOTICE: FILL
  task_manager_memory_reservation = ""      # NOTICE: FILL

  # worker configuration
  worker_docker_image          = ""         # NOTICE: FILL
  worker_cmd                   = ""         # NOTICE: FILL
  worker_cpu                   = ""         # NOTICE: FILL
  worker_memory                = ""         # NOTICE: FILL
  worker_memory_reservation    = ""         # NOTICE: FILL
  worker_gpu_requirement_count = 1

  # efs configuration
  efs_filesystem_id         = ""    # NOTICE: FILL
  efs_root_directory        = "/"
  efs_container_mount_point = ""    # NOTICE: FILL

  # ecs task limits
  ecs_task_cpu_hard_limit    = ""   # NOTICE: FILL
  ecs_task_memory_hard_limit = ""   # NOTICE: FILL
}

# redis configuration
locals {
  redis_node_type = "cache.t3.medium"
  redis_num_cache_nodes = 1

  redis_engine_version = "7.0"
  redis_auto_minor_version_upgrade = true
  redis_apply_immediately = true

  redis_snapshot_retention_limit = 5
}
