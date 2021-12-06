#!/bin/bash
source aws_credentials.sh

STACK_NAME=awsbootstrap
REGION=us-west-2
CLI_PROFILE=awsbootstrap
TEMPLATE_FILE=man.yaml
EC2_INSTANCE_TYPE=t2.micro

# define the S3 bucket name for our CodePipeline
AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile awsbootstrap \
  --query "Account" --output text`
# adding our account ID ensures a globally unique s3 bucket across AWS
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

# Deploy the setup.yaml file just beofre deploying man.yml
echo -e "\n\n========= Deploying setup.yaml ==========="
aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME-setup \
	--template-file setup.yaml \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-overrides \
	CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the cloudformation template 
echo -e "\n\n================= Deploying man.yml ===================="
aws cloudformation deploy \
 	--region $REGION \
  	--profile $CLI_PROFILE \
  	--stack-name $STACK_NAME \
  	--template-file $TEMPLATE_FILE \
  	--no-fail-on-empty-changeset \
  	--capabilities CAPABILITY_NAMED_IAM \
  	--parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE
echo -e "\n\n================= Executed"
echo -e $TEMPLATE_FILE
echo -e "=====================" 

# on successful deploy, show the DNS name of the created instance
if [ $? -eq 0 ]; then
	aws cloudformation list-exports \
		--profile awsbootstrap \
		--query "Exports[?Name=='InstanceDNS'].Value"
fi