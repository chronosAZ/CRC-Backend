output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hitcounter.function_name
}

output "module_path" {
   value = path.module

} 

output "root_path" {
   value = path.root

}
