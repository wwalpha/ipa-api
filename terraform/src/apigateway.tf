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
  depends_on = ["aws_api_gateway_integration.integration"]

  rest_api_id = "${aws_api_gateway_rest_api.ipa_api.id}"
  stage_name  = "v1"
}
