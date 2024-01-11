resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Database"
  billing_mode   = "PROVISIONED"
  read_capacity  = 100
  write_capacity = 100
  hash_key       = "UserId"
  range_key      = "Name"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Name"
    type = "S"
  }

  global_secondary_index {
    name               = "Database"
    hash_key           = "UserId"
    range_key          = "Name"
    write_capacity     = 100
    read_capacity      = 100
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
  }
}