resource "aws_iam_role" "event_role" {
  name = "eventbridge_invoke_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      }
    }
  ]
}
EOF
}
resource "aws_iam_policy" "event_policy" {
  name        = "event_rule_policy"
  description = "IAM policy for EventBridge rule to invoke Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
        ],
        Effect   = "Allow",
        Resource = aws_lambda_function.test_lambda.arn,
      },
    ],
  })
}
resource "aws_iam_role_policy_attachment" "event-attach" {  
  policy_arn = aws_iam_policy.event_policy.arn
  role       = aws_iam_role.event_role.name
  depends_on = [
    aws_iam_role.event_role,
    aws_iam_policy.event_policy,
  ]
 }
resource "aws_cloudwatch_event_rule" "s3eventrule" {
  name        = "project_rule"
  description = "CloudWatch Event Rule for S3 API Calls"
  role_arn = aws_iam_role.event_role.arn

event_pattern = <<EOF
{
  "source": ["aws.s3"]
}
EOF
}
# resource "aws_cloudwatch_event_rule" "s3eventrule" {
#   name        = "s3eventrule"
#   description = "Capture each AWS Console Sign In"

#   event_pattern = jsonencode({
#   detail_type = ["Object Created", "Object Deleted"],
#   source = ["aws.s3"],
#   detail = {
#     bucket = {
#     bucketName = [aws_s3_bucket.bucket.bucket],  
#     },
#    },
# })
# }


# resource "aws_cloudwatch_event_target" "lambda_target" {
#   rule = aws_cloudwatch_event_rule.s3eventrule.name
#   arn  = aws_lambda_function.test_lambda.arn
#   role_arn = aws_iam_role.event_role.arn

# }

resource "aws_cloudwatch_event_target" "event_target" {
    rule = aws_cloudwatch_event_rule.s3eventrule.name
    target_id = "test_lambda"
    arn = aws_lambda_function.test_lambda.arn
    

}

resource "aws_lambda_permission" "lambdapermission" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.test_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.s3eventrule.arn
}