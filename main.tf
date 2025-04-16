terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create S3 bucket for storing API data
resource "aws_s3_bucket" "api_data_bucket" {
  bucket = "your-bucket-name"  # Replace with your desired bucket name
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "api_to_s3_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "s3_access" {
  name = "s3_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.api_data_bucket.arn}/*"
      }
    ]
  })
}

# Create Lambda function
resource "aws_lambda_function" "api_to_s3" {
  filename         = "lambda_function.zip"
  function_name    = "api_to_s3_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.api_data_bucket.id
    }
  }
}

# Create CloudWatch event rule to trigger Lambda periodically
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "api_to_s3_schedule"
  description         = "Schedule for API to S3 Lambda function"
  schedule_expression = "rate(1 hour)"  # Adjust the schedule as needed
}

# Add permission for CloudWatch to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_to_s3.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

# Create CloudWatch event target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.api_to_s3.arn
} 