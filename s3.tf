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

resource "aws_s3_bucket_object" "object" {
  bucket = "event-pipeline-trigger-bucket"
  key    = "Book1.csv"
  acl    = "private"
  source = "https://event-pipeline-trigger-bucket.s3.amazonaws.com/Book1.csv"
}