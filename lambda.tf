resource "aws_lambda_function" "hitcounter" {
  function_name = "HitCounter"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hitcounter.key

  runtime = "python3.12"
  handler = "hitcount.lambda_handler"

  source_code_hash = data.archive_file.lambda_hitcounter.output_base64sha256

  role = aws_iam_role.hitcounter_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hitcounter" {
  name = "/aws/lambda/${aws_lambda_function.hitcounter.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "hitcounter_lambda_exec" {
  name = "hitcounter_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hitcounter_lambda_policy" {
  role       = aws_iam_role.hitcounter_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "hitcounter-lambda-policy" {
    name = "hitcounter_lambda_policy" 
    role = aws_iam_role.hitcounter_lambda_exec.id
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
           "Effect" : "Allow",
           "Action" : ["dynamodb:*"],
           "Resource" : "${aws_dynamodb_table.hitcounter-table.arn}"
        }
      ]
   })
}