resource "aws_api_gateway_rest_api" "ipa_api" {
  name = "ipa-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.ipa_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.ipa_api.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ipa_api.id}"
  resource_id             = "${aws_api_gateway_rest_api.ipa_api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.ipa_api.id}/*/${aws_api_gateway_method.method.http_method}/"
}

resource "aws_lambda_function" "lambda" {
  filename      = "dummy.zip"
  function_name = "ipa-converter"
  role          = "${aws_iam_role.role.arn}"
  handler       = "index.hanlder"
  runtime       = "nodejs8.10"

  tags = {
    EnglandTable = "${aws_dynamodb_table.england.id}"
    AmericaTable = "${aws_dynamodb_table.america.id}"
    SymbolTable  = "${aws_dynamodb_table.symbol.id}"
  }

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda.zip"))}"
  # source_code_hash = "${filebase64sha256("dummy.zip")}"
}

# IAM
resource "aws_iam_role" "role" {
  name = "myrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
