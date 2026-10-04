data "archive_file" "lambda_function_zip" {
    type = "zip"
    source_dir = "${path.module}/../Data_Extraction"
    output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "data_extraction_lambda_handler" {
    function_name = "data_extraction_lambda_handler"
    role          = aws_iam_role.lambda_execution_role.arn
    handler       = "data_extraction_handler.lambda_handler"
    runtime       = "python3.14"
    filename      = data.archive_file.lambda_function_zip.output_path
    source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
    timeout       = 120
    environment {
        variables = {
            SECRET_NAME = aws_secretsmanager_secret.marketpulse_api_key.name,
            S3_BUCKET_NAME = aws_s3_bucket.marketpulse_stock_data_bucket.bucket
        }
    }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
    event_source_arn = aws_sqs_queue.data_extraction_queue
    function_name = aws_lambda_function.data_extraction_lambda_handler.arn
    batch_size = 1
}