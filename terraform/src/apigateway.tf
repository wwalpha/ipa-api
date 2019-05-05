# --------------------------------------------------------------------------------
# Amazon API Gateway
# --------------------------------------------------------------------------------
resource "aws_api_gateway_rest_api" "ipa_api" {
  name = "ipa-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# --------------------------------------------------------------------------------
# Amazon API Gateway Deployment
# --------------------------------------------------------------------------------
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.ipa_api.id}"
  stage_name  = "v1"
}

module "ipa" {
  # source        = "github.com/wwalpha/terraform-modules-api-lambda"
  source        = "./terraform-modules-api-lambda"
  region        = "${var.region}"
  rest_api_id   = "${aws_api_gateway_rest_api.ipa_api.id}"
  http_method   = "GET"
  resource_id   = "${aws_api_gateway_rest_api.ipa_api.root_resource_id}"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.word" = true
    "method.request.querystring.lang" = false
  }

  integration_type        = "AWS_PROXY"
  integration_http_method = "POST"

  lambda_fileName      = "dummy.zip"
  lambda_function_name = "ipa-converter"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs8.10"
  lambda_timeout       = 5

  lambda_envs = {
    AmericaTable = "${aws_dynamodb_table.america.id}"
    EnglandTable = "${aws_dynamodb_table.england.id}"
    SymbolTable  = "${aws_dynamodb_table.symbol.id}"
  }

  lambda_log_retention_in_days = 14
  lambda_role_policy_json      = "${data.aws_iam_policy_document.dynamodb_access_policy.json}"
}
