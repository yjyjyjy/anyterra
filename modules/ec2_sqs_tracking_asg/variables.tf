variable "resource_prefix"                  { type = string }

variable "min_size"                         { type = string }
variable "max_size"                         { type = string }
variable "target_capacity"                  { type = string }

variable "image_id"                         { type = string }
variable "access_key_name"                  { type = string }
variable "instance_iam_role_name"           { type = string }

variable "instance_types_priority_order"    { type = list(string) }
variable "on_demand_base_number"            { type = string }
variable "on_demand_percentage"             { type = string }

variable "vpc_id"                           { type = string }
variable "subnet_ids_list"                  { type = list(string) }
variable "ssh_ingress_ipv4_ips"             { type = list(string) }

variable "ecs_cluster_name"                 { type = string }
variable "ecs_service_name"                 { type = string }
variable "sqs_queue_name"                   { type = string }

