import json
import boto3
import requests
from datetime import datetime

def lambda_handler(event, context):
    # Initialize S3 client
    s3 = boto3.client('s3')
    
    # API endpoint to query (replace with your actual API endpoint)
    api_url = "https://api.example.com/data"
    
    try:
        # Make API request
        response = requests.get(api_url)
        response.raise_for_status()  # Raise exception for bad status codes
        
        # Get the data
        data = response.json()
        
        # Create a timestamp for the filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"api_data_{timestamp}.json"
        
        # Upload to S3
        s3.put_object(
            Bucket='your-bucket-name',  # Replace with your bucket name
            Key=f'api_data/{filename}',
            Body=json.dumps(data),
            ContentType='application/json'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Data successfully stored in S3',
                'filename': filename
            })
        }
        
    except requests.exceptions.RequestException as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': f'API request failed: {str(e)}'
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': f'Error occurred: {str(e)}'
            })
        } 