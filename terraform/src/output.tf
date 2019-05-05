output "rest_id" {
  value = "${aws_api_gateway_rest_api.ipa_api.id}"
}

output "rest_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}"
}
