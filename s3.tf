resource "random_pet" "lambda_bucket_name" {
  prefix = "crc-backend"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_hitcounter" {
  type = "zip"

  source_file  = "${path.root}/code/hitcount.py"
  output_path = "${path.root}/hitcounter.zip"
}

resource "aws_s3_object" "lambda_hitcounter" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hitcounter.zip"
  source = data.archive_file.lambda_hitcounter.output_path

  etag = filemd5(data.archive_file.lambda_hitcounter.output_path)
}
