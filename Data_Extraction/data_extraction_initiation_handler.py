import os
import json
import boto3
import logging
from datetime import datetime

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

sqs_client = boto3.client("sqs")



def get_date():
    try:
        #date = datetime.now().strftime('%Y-%m-%d')
        date = "2026-10-01"
        logger.info(f"Current date: {date}")
        return date
    except Exception as e:
        logger.error(f"Error getting current date: {e}")
        raise

def send_to_sqs(queue_url, message_body):
    try:
        logger.info(f"Sending message to SQS queue: {queue_url}")
        response = sqs_client.send_message(
            QueueUrl=queue_url,
            MessageBody=message_body
        )
        logger.info(f"Message sent to SQS queue. Message ID: {response['MessageId']}")
    except Exception as e:
        logger.error(f"Error sending message to SQS queue: {e}")
        raise

def lambda_handler(event, context):
    try:
        queue_url = os.getenv("SQS_QUEUE_URL")
        date = get_date()
        message_body = json.dumps({"scheduledDate": date})
        send_to_sqs(queue_url, message_body)
    except Exception as e:
        logger.error(f"Error in lambda_handler: {e}")
        raise