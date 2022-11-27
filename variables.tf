variable "account_id" {
  description = "Allowed AWS account IDs"
  type = string
}

variable "current_region" {
  type = string
}

variable "current_id" {
  type = string
}

variable "region" {
    type = string
}

variable "prefix" {
    type = string
}

variable "trail_name" {
    type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "s3_key_prefix" {
    type = string
}

variable "include_global_service_events" {
    type = bool
}

variable "kms_key_id" {
    type = string
}

variable "enable_log_file_validation" {
    type = bool
}

variable "sns_topic_name" {
    type = string
}

variable "cloud_watch_logs_group_arn" {
    type = string
}

variable "cloud_watch_logs_role_arn" {
    type = string
}

variable "selector_data" {
    type = map(any)
}

# variable "insight_type" {
#     type = string
# }

variable "tags" {
  type = map(string)
}
