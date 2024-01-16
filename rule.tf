resource "aws_cloudwatch_event_rule" "s3eventrule" {
  name        = "s3eventrule"
  description = "Event rule for CSV file uploaded to S3 bucket"
  event_pattern = <<EOF
{
  "detail": {
    "object": {
      "key": [
        {
          "suffix": ".csv"
        }
      ]
    },
    "bucket": {
      "name": ["${aws_s3_bucket.bucket.id}"]
    }
  },
  "detail-type": ["Object Created"],
  "source": ["aws.s3"]
}
EOF
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.s3eventrule.name
  target_id = "test_lambda"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "lambdapermission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3eventrule.arn
}
