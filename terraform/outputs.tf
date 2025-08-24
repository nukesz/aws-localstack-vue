output "api_url" {
  value = "http://${aws_api_gateway_rest_api.news_api.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_stage.stage.stage_name}/news"
}

output "frontend_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.s3-website.localhost.localstack.cloud:4566"
}
