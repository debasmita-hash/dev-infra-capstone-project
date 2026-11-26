output "aws_account_id" {
  description = "AWS account in which the resources were created."
  value       = data.aws_caller_identity.current.account_id
}

output "iam_user_name" {
  description = "Name of the IAM user."
  value       = aws_iam_user.s3_read_only_user.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user."
  value       = aws_iam_user.s3_read_only_user.arn
}

output "iam_policy_name" {
  description = "Name of the S3 read-only policy."
  value       = aws_iam_policy.s3_read_only.name
}

output "iam_policy_arn" {
  description = "ARN of the S3 read-only policy."
  value       = aws_iam_policy.s3_read_only.arn
}

output "policy_json" {
  description = "Generated S3 read-only IAM policy document."
  value       = jsondecode(data.aws_iam_policy_document.s3_read_only.json)
}
