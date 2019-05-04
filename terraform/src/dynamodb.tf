resource "aws_dynamodb_table" "england" {
  name         = "ipa-england"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "word"

  attribute {
    name = "word"
    type = "S"
  }
}

resource "aws_dynamodb_table" "america" {
  name         = "ipa-america"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "word"

  attribute {
    name = "word"
    type = "S"
  }
}

resource "aws_dynamodb_table" "symbol" {
  name         = "ipa-symbol"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
