output "account_id" {
  description = "AWS Account ID"
  value       = var.account_id
}

output "name" {
  value       = aws_cloudtrail.this.name
}

output "arn" {
  value       = aws_cloudtrail.this.arn
}

output "enable_log_file_validation" {
  value       = aws_cloudtrail.this.enable_log_file_validation
}

output "kms_key_id" {
  value       = aws_cloudtrail.this.kms_key_id
}
