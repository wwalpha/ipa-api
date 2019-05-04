resource "aws_dynamodb_table" "england" {
  name         = "ipa-England"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "word"

  attribute {
    name = "word"
    type = "S"
  }
}

resource "aws_dynamodb_table" "america" {
  name         = "ipa-America"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "word"

  attribute {
    name = "word"
    type = "S"
  }
}

resource "aws_dynamodb_table" "symbol" {
  name         = "ipa-Symbol"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
