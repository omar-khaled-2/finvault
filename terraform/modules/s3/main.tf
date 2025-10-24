resource "aws_s3_bucket" "artifacts" {




}


resource "aws_s3_bucket_acl" "artifacts" {
  bucket = aws_s3_bucket.artifacts
  acl    = "private"
}
