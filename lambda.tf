resource "aws_s3_bucket" "bucket2" {
  bucket = "lambda-file-storage"
}

resource "aws_iam_role" "test_role" {
  name = "lambda-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "test_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda Execution"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = [
          "logs:CreateLogGroup", 
          "logs:CreateLogStream", 
          "logs:PutLogEvents"
          ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "*",
      },
      {
        Sid     = "EventBridgeActions",
        Effect  = "Allow",
        Action  = [
          "events:*", 
          "schemas:*", 
          "scheduler:*", 
          "pipes:*"
          ],
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:*", 
          "s3-object-lambda:*"
          ],
        Resource = "*",
      },
      {
        Action = [
          "dynamodb:*",
          "dax:*",
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DeregisterScalableTarget",
          # ... (other actions)
          "kinesis:DescribeStreamSummary",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "cloudwatch:GetInsightRuleReport",
        Effect   = "Allow",
        Resource = "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*",
      },
      {
        Action = [
                "sns:*"
            ],
            Effect   = "Allow",
            Resource = "*"
      },
      {
      Effect = "Allow",
      Action = "lambda:InvokeFunction",
      Resource = "${aws_lambda_function.test_lambda.arn}"
      },
      {
      Effect = "Allow",
      Action = [
        "s3:HeadObject",
        "s3:GetObject"
      ],
      Resource = [
        "arn:aws:s3:::projectbucket001/*"
      ]
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "test-attach" {  
  policy_arn = aws_iam_policy.test_policy.arn
  role       = aws_iam_role.test_role.name
  depends_on = [
    aws_iam_role.test_role,
    aws_iam_policy.test_policy,
  ]
 }
 
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "Outputs/lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "Outputs/lambda.zip"
  function_name = "lambda-function"
  role          = aws_iam_role.test_role.arn
  handler       = "lambda.lambda_handler"
  source_code_hash = "${base64sha256(file("lambda.py"))}"
  runtime = "python3.8" 
  environment {
    variables = {
      KEY1 = "VALUE1",
      KEY2 = "VALUE2",
    }
  }
}

resource "aws_lambda_permission" "s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

# resource "aws_s3_bucket_notification" "trigger_notification" {
#   bucket = aws_s3_bucket.bucket.id

#   lambda_function {
#     lambda_function_arn = aws_lambda_function.test_lambda.arn
#     events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
#   }
#   depends_on = [ aws_lambda_permission.s3_bucket ]
# }