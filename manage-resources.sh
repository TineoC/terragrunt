#!/bin/bash

# Configuration
S3_BUCKET_NAME="chris-devopsdemo2024-terraform-state"
DYNAMODB_TABLE_NAME="my-terraform-locks"
REGION="us-east-1"

# Function to create resources
create_resources() {
  echo "Creating S3 bucket..."
  aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $REGION
  
  echo "Enabling versioning on S3 bucket..."
  aws s3api put-bucket-versioning --bucket $S3_BUCKET_NAME --versioning-configuration Status=Enabled

  echo "Creating DynamoDB table..."
  aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --billing-mode PROVISIONED \
    --region $REGION

  echo "Resources created successfully."
}

# Function to rollback (delete) resources
rollback_resources() {
  echo "Deleting DynamoDB table..."
  aws dynamodb delete-table --table-name $DYNAMODB_TABLE_NAME --region $REGION

  echo "Deleting S3 bucket..."
  # Empty the bucket before deleting
  aws s3 rm s3://$S3_BUCKET_NAME --recursive
  
  # Delete the bucket
  aws s3api delete-bucket --bucket $S3_BUCKET_NAME --region $REGION
  
  echo "Resources deleted successfully."
}

# Main script logic
case "$1" in
  create)
    create_resources
    ;;
  rollback)
    rollback_resources
    ;;
  *)
    echo "Usage: $0 {create|rollback}"
    exit 1
    ;;
esac
