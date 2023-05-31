variable "resource_prefix"                    { type = string }

variable "queue_visibility_timeout_seconds"   { type = string }
variable "queue_message_retention_seconds"    { type = string }
variable "queue_max_message_size"             { type = string }
variable "queue_receive_wait_time_seconds"    { type = string }
variable "queue_delay_seconds"                { type = string }

variable "dlq_visibility_timeout_seconds"     { type = string }
variable "dlq_message_retention_seconds"      { type = string }
variable "dlq_max_message_size"               { type = string }
variable "dlq_receive_wait_time_seconds"      { type = string }
variable "dlq_delay_seconds"                  { type = string }
