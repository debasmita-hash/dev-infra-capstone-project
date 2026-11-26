# EC2 Instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}
# EC2 Public IP
output "public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.web.public_ip
}
# EC2 Public DNS
output "public_dns" {
  description = "Public DNS name of EC2"
  value       = aws_instance.web.public_dns
}
# Website URL
output "website_url" {
  description = "URL of the deployed website"
  value       = "http://${aws_instance.web.public_ip}"
}
# VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = data.aws_vpc.main.id
}
# Public Subnet ID
output "subnet_id" {
  description = "ID of the public subnet"
  value       = data.aws_subnet.public.id
}
