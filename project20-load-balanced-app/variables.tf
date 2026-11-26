variable "aws_region" {
  description = "AWS Region in which to deploy the lab."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "project20-alb"
}

variable "instance_type" {
  description = "EC2 instance type for both web servers."
  type        = string
  default     = "t3.micro"
}
