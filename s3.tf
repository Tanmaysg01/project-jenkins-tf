resource "aws_s3_bucket" "bucket" {
  bucket = "projectbucket001"
}

resource "aws_s3_bucket_notification" "s3_bucket_eventbridge" {
  bucket      = "projectbucket001"
  eventbridge = true
}

resource "aws_s3_bucket" "webhook" {
  bucket = "webhook-bucket-jenkins-project"
}