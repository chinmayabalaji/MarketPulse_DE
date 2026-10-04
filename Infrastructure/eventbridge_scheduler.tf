resource "aws_scheduler_schedule" "data_extraction_scheduler" {
    name = "data-extraction-scheduler"
    group_name = "default"
    flexible_time_window {
      mode = "OFF"
    }
    schedule_expression = "rate(10 minutes)"
    target {
        arn = aws_lambda_function.data_extraction_initiation_handler.arn
        role_arn = aws_iam_role.lambda_execution_role.arn
    }
}