resource "null_resource" "validate_account" {
  count = var.current_id == var.account_id ? 0 : "Please check that you are using the AWS account"
}

resource "null_resource" "validate_module_name" {
  count = local.module_name == var.tags["TerraformModuleName"] ? 0 : "Please check that you are using the Terraform module"
}

resource "null_resource" "validate_module_version" {
  count = local.module_version == var.tags["TerraformModuleVersion"] ? 0 : "Please check that you are using the Terraform module"
}

################

resource "aws_cloudtrail" "this" {
  name                          = format("%s-%s-cloud-trail", var.prefix, var.trail_name)
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  include_global_service_events = var.include_global_service_events

  kms_key_id                    = var.kms_key_id

  enable_log_file_validation    = var.enable_log_file_validation
  
  sns_topic_name                = var.sns_topic_name

  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn

  tags                          = var.tags

  dynamic "advanced_event_selector" {
    for_each = var.selector_data
    content {
      name = format("%s-%s-%s-selector", var.prefix, var.trail_name, advanced_event_selector.key)
      dynamic "field_selector" {
        for_each = advanced_event_selector.value
        content {
          field = field_selector.key == "resources_arn" ? "resources.ARN":(field_selector.key=="resources_type"?"resources.type":field_selector.key)
          equals          = lookup(field_selector.value, "equals", null)
          not_equals      = lookup(field_selector.value, "not_equals", null)
          starts_with     = lookup(field_selector.value, "starts_with", null)
          not_starts_with = lookup(field_selector.value, "not_starts_with", null)
          ends_with       = lookup(field_selector.value, "ends_with", null)
          not_ends_with   = lookup(field_selector.value, "not_ends_with", null)
        }
      }
    }
  }
  # insight_selector {
  #   insight_type = var.insight_type
  # }
}
