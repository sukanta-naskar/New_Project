provider "aws" {
  region = "us-east-1"
}

# Create an ECR repository
resource "aws_ecr_repository" "my_ecr_repo" {
  name = "my-lambda-repo-patient"
}

# Allow Lambda to pull images from ECR
resource "aws_ecr_repository_policy" "my_ecr_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "ecr:GetDownloadUrlForLayer"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
POLICY
}

# Create IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
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
EOF
}

# Attach IAM policy to the Lambda role
resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda function using an image from ECR
resource "aws_lambda_function" "my_lambda" {
  function_name = "my-ecr-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.my_ecr_repo.repository_url}:latest"

  timeout = 30
  memory_size = 128

  depends_on = [aws_iam_policy_attachment.lambda_policy_attach]
}
