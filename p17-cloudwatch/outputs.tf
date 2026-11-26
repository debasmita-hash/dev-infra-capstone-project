output "instance_id" {
  value = aws_instance.log_forwarder.id
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.boot.name
}

output "boot_summary_stream" {
  value = "${aws_instance.log_forwarder.id}-boot-summary"
}

output "cloud_init_stream" {
  value = "${aws_instance.log_forwarder.id}-cloud-init"
}

output "console_url" {
  value = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group/${replace(replace(var.log_group_name, "/", "$252F"), "-", "$252D")}"
}
