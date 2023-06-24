locals {
  resource_prefix               = "rpg"
  sqs_queue_prefix              = "rpg_queue"
  free_queues_resource_prefix   = "rpg_queue_free"
  premium_queue_resource_prefix = "rpg_queue_premium"
  # artifact_bucket_name          = "anydream-gen-storage"
}

locals {
  artifact_bucket_name = "a1-generated"
  artifact_bucket_arn  = "arn:aws:s3:::${local.artifact_bucket_name}"
  access_key_name = "aws"
}

locals {
  global_vpc_id = "vpc-0d151afb4b1f19e05" # NOTICE: Fill
  global_subnet_ids = [
    "subnet-0a73374ec206acaa3",
    "subnet-07ab183b928a5144d",
    "subnet-0b3883ee71e869d8d",
    "subnet-0b6ff9dd7da01e5da",
    "subnet-0930257763db324ff",
    "subnet-0a7a2f217776c31ed",
  ] # NOTICE: FILL
}

# asg configuration
locals {
  asg_min_size = 1
  asg_max_size = 2
  asg_target_capacity = 1 # NOTICE: Calibrate

  asg_instance_type   = "g4dn.xlarge"
  asg_image_id        = "ami-0833412fdba53c144" # please refer to README
  asg_access_key_name = "aws"                      # NOTICE: FILL

  asg_instance_types_order = [
    "g4dn.xlarge",
    "g5.xlarge"
  ]

  asg_base_on_demand_instances = 1
  asg_on_demand_percentage = 20

  asg_ssh_ips = [
	  "0.0.0.0/0"
  ]                       # NOTICE: FILL
}

# free queue configuration
locals {
  free_queue_visibility_timeout_seconds = 90
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
  premium_queue_visibility_timeout_seconds = 90
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
  task_manager_docker_image       = "370137866648.dkr.ecr.us-east-1.amazonaws.com/manager-rpg:v2" # NOTICE: FILL
  task_manager_cmd                = "" # NOTICE: FILL
  task_manager_cpu                = "1024" # NOTICE: FILL 2vCPU
  task_manager_memory             = "2048" # NOTICE: FILL
  task_manager_memory_reservation = "1024" # NOTICE: FILL

  # worker configuration
  worker_docker_image          = "370137866648.dkr.ecr.us-east-1.amazonaws.com/worker-rpg:v2" # NOTICE: FILL
  worker_cmd                   = "" # NOTICE: FILL
  worker_cpu                   = "2048" # NOTICE: FILL
  worker_memory                = "10240" # NOTICE: FILL
  worker_memory_reservation    = "6144" # NOTICE: FILL
  worker_gpu_requirement_count = 1

  # # efs configuration
  # efs_filesystem_id         = "" # NOTICE: FILL
  # efs_root_directory        = "/"
  # efs_container_mount_point = "" # NOTICE: FILL

  # ecs task limits
  ecs_task_cpu_hard_limit    = "" # NOTICE: FILL sum of the two tasks
  ecs_task_memory_hard_limit = "" # NOTICE: FILL
}

# redis configuration
locals {
  redis_node_type       = "cache.t3.medium"
  redis_num_cache_nodes = 1

  redis_engine_version             = "7.0"
  redis_auto_minor_version_upgrade = true
  redis_apply_immediately          = true

  redis_snapshot_retention_limit = 5
}
