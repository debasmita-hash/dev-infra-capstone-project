terraform {
  required_version = ">= 1.0"
}
resource "null_resource" "example" {
  triggers = {
    project = "project7"
  }
}
