data "aws_iam_policy_document" "dynamodb_access_policy" {
  statement {
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:${var.region}:*:table/*/index/*",
      "arn:aws:dynamodb:${var.region}:*:table/*",
    ]
  }
}
