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
  bucket = "projectbucket001"
  key    = "new_object_key"
  acl    = "private"
  source = "C:/Users/Tanmay Garge/Desktop/New folder (2)/file.txt"
}