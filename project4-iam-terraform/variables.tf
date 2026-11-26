variable "aws_region" {
  description = "AWS region used by the provider."
  type        = string
  default     = "ap-south-1"
}

variable "iam_user_name" {
  description = "Name of the IAM user created by Terraform."
  type        = string
  default     = "project4-s3-readonly-user"
}

variable "iam_policy_name" {
  description = "Name of the customer-managed IAM policy."
  type        = string
  default     = "project4-s3-readonly-policy"
}

variable "iam_policy_description" {
  description = "Description for the customer-managed IAM policy."
  type        = string
  default     = "Allows read-only access to Amazon S3 resources."
}

variable "policy_statements" {
  description = "IAM policy statements used to build the S3 read-only policy."

  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition = alltrue([
      for statement in var.policy_statements :
      contains(["Allow", "Deny"], statement.effect)
    ])

    error_message = "Each policy statement effect must be Allow or Deny."
  }
}

variable "common_tags" {
  description = "Common tags applied to supported AWS resources."
  type        = map(string)

  default = {
    Project   = "Project-4"
    ManagedBy = "Terraform"
  }
}
