# Change Control

## Purpose

This document defines how infrastructure and platform changes should be reviewed and applied safely.

## Standard Terraform Change Flow

1. Create a branch.
2. Make Terraform changes.
3. Format the code.
4. Validate the configuration.
5. Review the Terraform plan.
6. Apply only after review.

## Commands

Go to the Terraform environment:

cd infra/envs/dev

Format:

terraform fmt -recursive

Validate:

terraform validate

Review plan:

terraform plan

Apply:

terraform apply

## Safer Apply

For controlled changes, save the plan first:

terraform plan -out=tfplan
terraform apply tfplan

## High-Risk Changes

These changes require extra review:

- Replacing the EC2 instance
- Changing the AMI ID
- Changing security groups
- Changing ALB or Target Group settings
- Changing VPC routes
- Replacing the EBS data volume
- Modifying IAM permissions
- Changing CloudWatch alarms
- Changing SNS notification settings

## Rollback Options

### Terraform Code Change

Revert the commit and apply again:

git revert <commit>
terraform plan
terraform apply

### EC2 Issue

Recreate the EC2 instance if needed:

terraform apply -replace="module.ec2_nexus.aws_instance.nexus"

### Nexus Container Issue

Connect through SSM and restart the container:

aws ssm start-session \
  --target $(terraform output -raw nexus_instance_id) \
  --region us-east-1

sudo docker restart nexus

### Bad AMI Upgrade

Pin the previous AMI ID and replace the EC2 instance.

### EBS Issue

Do not delete or replace the EBS volume without confirming the impact to Nexus data.

Check first:

df -h
lsblk
mount | grep nexus

## Drift Handling

If AWS was changed manually, run:

terraform plan

Then decide:

Option 1: Revert the manual change with Terraform.
Option 2: Update Terraform code to accept the change.
Option 3: Import the resource if it exists in AWS but not in Terraform state.

Do not blindly run terraform apply before understanding the drift.

## Change Approval Checklist

Before applying a change, confirm:

- The Terraform plan was reviewed.
- The resources being replaced are expected.
- No sensitive values are exposed.
- The impact to Nexus availability is understood.
- A rollback option exists.
- The change is documented.
