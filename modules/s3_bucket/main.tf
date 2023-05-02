# variables
variable "bucket_name" { type = string }

# resources
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

# outputs
output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}
