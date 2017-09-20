resource "aws_s3_bucket" "exchange" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags {
    Name        = "Exchange"
    Environment = "Dev"
  }
}
