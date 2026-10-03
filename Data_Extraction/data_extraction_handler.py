import os
import json
import boto3
import logging
import requests
from datetime import datetime

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

secrets_client = boto3.client("secretsmanager", region_name="eu-north-1")
s3_client = boto3.client("s3", region_name = "eu-north-1")

def get_secret(secret_name):
    try:
        logger.info(f"Fetching secret: {secret_name}")
        response = secrets_client.get_secret_value(SecretId=secret_name)
        API_KEY = json.loads(response["SecretString"])["MASSIVE_API_KEY"]
        return API_KEY
    except Exception as e:
        logger.error(f"Error fetching secret: {e}")
        raise

def get_stock_data(API_KEY, req_date):
    try:
        logger.info("Fetching stock data...")
        url = f"https://api.massive.com/v2/aggs/grouped/locale/us/market/stocks/{req_date}"
        params = {
            "adjusted": "true",
            "apiKey": API_KEY
        }

        response = requests.get(url, params=params, timeout=60)
        if response.status_code != 200:
            logger.error(f"Error fetching stock data: {response.status_code} - {response.text}")
            response.raise_for_status()
        return response.json()
    except Exception as e:
        logger.error(f"Error fetching stock data: {e}")
        raise

def write_to_s3(data, bucket_name):
    try:
        logger.info("Writing data to S3...")
        date = datetime.now().strftime('%Y-%m-%d')
        file_name = f"us_stocks_ohlcv_{date}.json"
        s3_client.put_object(Bucket=bucket_name, Key=f"{date.strftime('%Y')}/{date.strftime('%m')}/{date.strftime('%d')}/{file_name}", Body=json.dumps(data).encode("utf-8"))
        logger.info(f"Data written to S3 bucket: {bucket_name}, file: {file_name}")
    except Exception as e:
        logger.error(f"Error writing to S3 bucket: {e}")
        raise

def lambda_handler(event, context):
    try:
        req_date = event.get("date")
        logger.info("Fetching stock data...")
        secret_name = os.environ.get("API_KEY_SECRET_NAME")
        bucket_name = os.environ.get("S3_BUCKET_NAME")
        API_KEY = get_secret(secret_name)
        data = get_stock_data(API_KEY, req_date)
        if data:
            write_to_s3(data, bucket_name)
    except Exception as e:
        logger.error(f"Error fetching stock data: {e}")
        raise
