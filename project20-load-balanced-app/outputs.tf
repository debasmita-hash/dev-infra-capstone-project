output "alb_dns_name" {
  description = "Public DNS name of the ALB."
  value       = aws_lb.app.dns_name
}

output "application_url" {
  description = "Open this URL to test the application."
  value       = "http://${aws_lb.app.dns_name}"
}

output "instance_ids" {
  description = "IDs of the two EC2 web instances."
  value       = aws_instance.web[*].id
}

output "target_group_arn" {
  description = "Target group ARN used by verification commands."
  value       = aws_lb_target_group.web.arn
}

output "selected_availability_zones" {
  description = "Availability Zones containing the selected default subnets."
  value       = data.aws_subnet.selected[*].availability_zone
}
