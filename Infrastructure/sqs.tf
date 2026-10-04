resource "aws_sqs_queue" "data_extraction_dead_letter_queue" {
  name = "data_extraction_dead_letter_queue"
  fifo_queue = true
}

resource "aws_sqs_queue" "data_extraction_queue" {
  name = "data_extraction_queue"
  delay_seconds = 0
  visibility_timeout_seconds = 30
  fifo_queue = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.data_extraction_dead_letter_queue.arn
    maxReceiveCount     = 5
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "data_extraction_redrive_policy" {
  queue_url = aws_sqs_queue.data_extraction_queue.id
  redrive_allow_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.data_extraction_dead_letter_queue.arn
    maxReceiveCount     = 5
  })
}