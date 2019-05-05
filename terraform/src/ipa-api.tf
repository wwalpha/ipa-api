resource "aws_api_gateway_method" "method" {
  rest_api_id          = "${aws_api_gateway_rest_api.ipa_api.id}"
  resource_id          = "${aws_api_gateway_rest_api.ipa_api.root_resource_id}"
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = "${aws_api_gateway_request_validator.request_validator.id}"

  request_parameters = {
    "method.request.querystring.word" = true
    "method.request.querystring.lang" = false
  }
}

resource "aws_api_gateway_request_validator" "request_validator" {
  name                        = "request_validator"
  rest_api_id                 = "${aws_api_gateway_rest_api.ipa_api.id}"
  validate_request_parameters = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ipa_api.id}"
  resource_id             = "${aws_api_gateway_rest_api.ipa_api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}
