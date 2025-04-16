# Lambda API Query to S3

This project implements an AWS Lambda function that queries an API endpoint and stores the results in an S3 bucket. The infrastructure is managed using Terraform.

## Project Structure

```
.
├── lambda_function.py    # Lambda function code
├── main.tf              # Terraform configuration
├── requirements.txt     # Python dependencies
└── README.md           # Project documentation
```

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured with credentials
- Terraform installed
- Python 3.9 or later
- Git

## Features

- Automated API data collection
- Secure S3 storage of API responses
- Scheduled execution using CloudWatch Events
- Infrastructure as Code with Terraform
- Error handling and logging

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/MMGehrke/LambdaAPIQuery.git
   cd LambdaAPIQuery
   ```

2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Update the following in `lambda_function.py`:
   - Replace `https://api.example.com/data` with your actual API endpoint
   - Update the bucket name in the S3 put_object call

4. Update the following in `main.tf`:
   - Replace `your-bucket-name` with your desired S3 bucket name
   - Update the AWS region if needed

5. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

### Lambda Function
- Runtime: Python 3.9
- Memory: 128MB
- Timeout: 30 seconds
- Scheduled to run hourly (configurable in `main.tf`)

### S3 Bucket
- Stores API responses in JSON format
- Files are named with timestamp: `api_data_YYYYMMDD_HHMMSS.json`
- Files are stored under the `api_data/` prefix

## Security

- IAM roles with least privilege principle
- S3 bucket access restricted to Lambda function
- CloudWatch Logs for monitoring and debugging

## Monitoring

The Lambda function logs to CloudWatch Logs. You can monitor:
- Successful API calls and S3 uploads
- API errors and exceptions
- S3 upload failures

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

- Macoy Gehrke
- GitHub: [MMGehrke](https://github.com/MMGehrke)

## Acknowledgments

- AWS Lambda
- Terraform
- Python requests library
- Boto3 AWS SDK 