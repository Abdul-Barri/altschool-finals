# This "s3" backend is no longer in use. Statefile has been migrated to Terraform Cloud "eks-workspace"

# terraform {
#   backend "s3" {
#     bucket = "terraform-state-08174509694"
#     key = "global/s3/terraform.tfstate"
#     region     = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt = true
#   }
# }

# provider "aws" {
#   region     = var.region
#   access_key = var.accesskey
#   secret_key = var.secretkey

# }

# Create S3 Bucket for backend statefile

# resource "aws_s3_bucket" "terraform-state-bucket" {
#   bucket = var.backend-bucket-name
  
#   lifecycle {
#     prevent_destroy = true
#   }

#   versioning {
#     enabled = true
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

# # Create Dynamo DB table for backend statefile locking

# resource "aws_dynamodb_table" "terraform-state-lock" {
#   name             = var.backend-lock-name
#   hash_key         = "LockID"
#   billing_mode     = "PAY_PER_REQUEST"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
