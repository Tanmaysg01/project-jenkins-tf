import json
import boto3
import csv
import os
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Load environment variables
S3_BUCKET = os.environ.get('S3_BUCKET', 'projectbucket001')
S3_KEY = os.environ.get('S3_KEY', 'Book1.csv')
DYNAMODB_TABLE = os.environ.get('DYNAMODB_TABLE', 'Database')
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN', 'arn:aws:sns:us-east-1:875716031392:sns_topic')
EMAIL_ADDRESS = os.environ.get('EMAIL_ADDRESS', 'tanmaygarge@gmail.com')

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYNAMODB_TABLE)
sns = boto3.client('sns')

def lambda_handler(event, context):
    try:
        # Assume the CSV file is in the Lambda deployment package
        csv_file_path = '/tmp/your-file.csv'

        # Download the CSV file
        s3 = boto3.client('s3')
        s3.download_file(S3_BUCKET, S3_KEY, csv_file_path)

        # Read the CSV file
        with open(csv_file_path, 'r') as file:
            csv_data = file.read().splitlines()

        # Convert CSV to JSON
        json_data = csv_to_json(csv_data)

        # Insert data into DynamoDB
        for item in json_data:
            table.put_item(Item=item)

        # Send email through SNS
        message = "Data processed successfully!"
        sns.publish(TopicArn=SNS_TOPIC_ARN, Message=message, Subject="Data Processing Notification")

        return {
            'statusCode': 200,
            'body': json.dumps('Function executed successfully!')
        }
    except Exception as e:
        logger.error(f"Error processing data: {str(e)}")
        raise

def csv_to_json(csv_data):
    # Assuming the CSV has headers and the first row contains field names
    reader = csv.DictReader(csv_data)
    json_data = []

    for row in reader:
        item = {
            'UserId': row['UserId'],
            'Name': row['Name'],
            # Add other attributes as needed 
        }
        json_data.append(item)

    return json_data
