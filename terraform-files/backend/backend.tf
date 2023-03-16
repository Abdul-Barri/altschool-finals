provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-state-08174509694"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Create Dynamo DB table for backend statefile locking

resource "aws_dynamodb_table" "terraform-state-lock" {
  name             = "terraform-state-lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}