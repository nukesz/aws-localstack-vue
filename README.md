# Vue.js + AWS Lambda News API (LocalStack + Terraform)

## Overview

This demo shows a setup:

- **Backend:** Lambda returns 10 dummy news items.
- **API Gateway:** REST endpoint `/news`.
- **Frontend:** Vue.js app fetching the API, served from S3.
- **Infrastructure:** Managed with Terraform, testable locally via LocalStack.

The frontend reads the API URL from an environment variable (`VITE_API_URL`).

## Project Structure

```
app/
├── terraform/ # Terraform infra (Lambda, API Gateway, S3)
├── frontend/ # Vue.js frontend app
```


## Running the App

### 1. Start LocalStack

```bash
localstack start -d
```

### 2. Deploy infra & frontend

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 3. Access endpoints

The outputs will show the endpoints:

```
api_url = "http://<news-api-id>.execute-api.localhost.localstack.cloud:4566/dev/news"
frontend_url = "http://vue-frontend-demo.s3-website.localhost.localstack.cloud:4566"
```

## Notes

- LocalStack CE does not support CloudFront; S3 website hosting is used.
- Only REST API v1 (API Gateway) is supported.