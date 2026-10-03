resource "aws_lambda_function" "data_extraction_lambda_handler" {
    function_name = "data_extraction_lambda_handler"
    role          = aws_iam_role.lambda_execution_role.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.9"
    filename      = "lambda_function.zip"
    timeout       = 120
}