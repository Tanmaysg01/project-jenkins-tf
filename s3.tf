resource "aws_s3_bucket" "bucket" {
  bucket = "projectbucket001"
}

resource "aws_s3_bucket_notification" "s3_bucket_eventbridge" {
  bucket      = "projectbucket001"
  eventbridge = true
}

resource "aws_s3_bucket" "example" {
  bucket = "my-jenkins-test-bucket"
}

resource "aws_s3_bucket" "example2" {
  bucket = "automation-test-bucket"
}