resource "aws_sqs_queue" "data_extraction_dead_letter_queue" {
  name = "data-extraction-lambda-dead-letter-queue"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns = [
        aws_sqs_queue.data_extraction_queue.arn
    ]
  })
}

resource "aws_sqs_queue" "data_extraction_queue" {
  name = "data-extraction-lambda-queue"
  delay_seconds = 0
  visibility_timeout_seconds = 360
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.data_extraction_dead_letter_queue.arn
    maxReceiveCount     = 5
  })
}
