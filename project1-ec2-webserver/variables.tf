variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "project1-ec2-webserver"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}
variable "subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.20.1.0/24"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "availability_zone" {
  description = "Availability zone for subnet"
  type        = string
  default     = "ap-south-1a"
}
