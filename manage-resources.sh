#!/bin/bash

# Configuration
S3_BUCKET_NAME="chris-devopsdemo2024-terraform-state"
S3_BUCKET_REGION="us-east-1"
DYNAMODB_TABLE_NAME="my-terraform-locks"

# Function to create resources
create_resources() {
  echo "Creating S3 bucket..."
  aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $REGION > /dev/null 2>&1
  
  echo "Enabling versioning on S3 bucket..."
  aws s3api put-bucket-versioning --bucket $S3_BUCKET_NAME --versioning-configuration Status=Enabled > /dev/null 2>&1

  echo "Creating DynamoDB table..."
  aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --billing-mode PROVISIONED \
    --region $REGION > /dev/null 2>&1

  echo "Resources created successfully."
}

# Function to rollback (delete) resources
rollback_resources() {
  echo "Deleting DynamoDB table..."
  aws dynamodb delete-table --table-name $DYNAMODB_TABLE_NAME --region $REGION > /dev/null 2>&1

  echo "Deleting all versions in S3 bucket..."
  # List and delete all object versions
  aws s3api list-object-versions --bucket $S3_BUCKET_NAME --query 'Versions[].{ID:VersionId,Key:Key}' --output text | while read -r versionId key; do
    aws s3api delete-object --bucket $S3_BUCKET_NAME --key "$key" --version-id "$versionId" > /dev/null 2>&1
  done
  
  # List and delete all delete markers (needed for versioned deletes)
  aws s3api list-object-versions --bucket $S3_BUCKET_NAME --query 'DeleteMarkers[].{ID:VersionId,Key:Key}' --output text | while read -r versionId key; do
    aws s3api delete-object --bucket $S3_BUCKET_NAME --key "$key" --version-id "$versionId" > /dev/null 2>&1
  done

  echo "Deleting S3 bucket..."
  aws s3api delete-bucket --bucket $S3_BUCKET_NAME --region $REGION > /dev/null 2>&1
  
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
