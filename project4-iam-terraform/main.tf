data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_read_only" {
  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_user" "s3_read_only_user" {
  name = var.iam_user_name
  path = "/project4/"

  tags = {
    Name       = var.iam_user_name
    Permission = "S3ReadOnly"
  }
}

resource "aws_iam_policy" "s3_read_only" {
  name        = var.iam_policy_name
  path        = "/project4/"
  description = var.iam_policy_description
  policy      = data.aws_iam_policy_document.s3_read_only.json

  tags = {
    Name = var.iam_policy_name
  }
}

resource "aws_iam_user_policy_attachment" "s3_read_only" {
  user       = aws_iam_user.s3_read_only_user.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}
