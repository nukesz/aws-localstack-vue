resource "aws_s3_bucket" "frontend" {
  bucket = "vue-frontend-demo"
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.bucket

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject"],
      Resource  = "${aws_s3_bucket.frontend.arn}/*"
    }]
  })
}

resource "null_resource" "build_frontend" {
  provisioner "local-exec" {
    command = <<EOT
      cd ../frontend
      echo "VITE_API_URL=http://${aws_api_gateway_rest_api.news_api.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_stage.stage.stage_name}/news" > .env
      npm install
      npm run build
      aws --endpoint-url=http://localhost:4566 s3 sync dist/ s3://${aws_s3_bucket.frontend.bucket}/
    EOT
  }

  depends_on = [
    aws_api_gateway_rest_api.news_api,
    aws_s3_bucket_website_configuration.frontend
  ]
}