data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

locals {
  subnet_ids = slice(sort(data.aws_subnets.default.ids), 0, 2)
}

data "aws_subnet" "selected" {
  count = 2
  id    = local.subnet_ids[count.index]
}
