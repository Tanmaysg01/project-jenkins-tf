resource "aws_s3_bucket" "bucket" {
  bucket = "projectbucket001"
}

resource "aws_s3_bucket_notification" "s3_bucket_eventbridge" {
  bucket      = "projectbucket001"
  eventbridge = true
}


resource "aws_s3_bucket" "example2" {
  bucket = "event-project-bucket"
}

resource "aws_s3_bucket" "example1" {
  bucket = "webhook-bucket-try"
}