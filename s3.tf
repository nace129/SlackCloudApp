resource "aws_s3_bucket" "file_storage" {
  bucket = "slack-app-files"
#   acl    = "private"
}

output "aws_s3_bucket" {
  value = aws_s3_bucket.file_storage.bucket
}