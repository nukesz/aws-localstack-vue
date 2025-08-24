resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "news_lambda" {
  function_name = "newsLambda"
  handler       = "handler.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/lambda/lambda.zip"
}

resource "aws_api_gateway_rest_api" "news_api" {
  name        = "newsApi"
  description = "API Gateway for news Lambda"
}

resource "aws_api_gateway_resource" "news_resource" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_rest_api.news_api.root_resource_id
  path_part   = "news"
}

resource "aws_api_gateway_method" "news_method" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.news_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "news_integration" {
  rest_api_id             = aws_api_gateway_rest_api.news_api.id
  resource_id             = aws_api_gateway_resource.news_resource.id
  http_method             = aws_api_gateway_method.news_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.news_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "news_deployment" {
  depends_on  = [aws_api_gateway_integration.news_integration]
  rest_api_id = aws_api_gateway_rest_api.news_api.id

}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  deployment_id = aws_api_gateway_deployment.news_deployment.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.news_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.news_api.execution_arn}/*/*"
}