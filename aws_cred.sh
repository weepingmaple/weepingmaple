#!/bin/bash

# Replace with your S3 bucket name
BUCKET="XXXXXXXXX" 

# Replace with the path to the file in S3
FILE="path/to/file"

# Replace with the ARN of the IAM role to assume
ROLE_ARN="arn:aws:iam::123456789012:role/RoleToAssume"

# Assume the IAM role
creds=$(aws sts assume-role --role-arn "$ROLE_ARN" --role-session-name "Session1")

# Extract the temporary credentials
access_key=$(echo $creds | jq -r '.Credentials.AccessKeyId')
secret_key=$(echo $creds | jq -r '.Credentials.SecretAccessKey') 
session_token=$(echo $creds | jq -r '.Credentials.SessionToken')

# Export the credentials as environment variables
export AWS_ACCESS_KEY_ID=$access_key
export AWS_SECRET_ACCESS_KEY=$secret_key
export AWS_SESSION_TOKEN=$session_token

# Download the file
aws s3 cp s3://$BUCKET/$FILE .

# Clean up credentials
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY 
unset AWS_SESSION_TOKEN
