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
}