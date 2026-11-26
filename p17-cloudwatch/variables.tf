variable "aws_region" {
  description = "AWS Region in which to deploy Project 17."
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "log_group_name" {
  description = "Dedicated CloudWatch Logs log group."
  type        = string
  default     = "/project17/ec2/boot"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period."
  type        = number
  default     = 7
}
