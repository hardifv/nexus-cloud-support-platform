# Operational Runbook

## Purpose

This runbook explains how to operate and support the Nexus Cloud Support Platform.

## Check Nexus URL

Get the ALB DNS name:

cd infra/envs/dev
terraform output -raw alb_dns_name

Open in the browser:

http://\<alb_dns_name\>

## Check Target Health

aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw nexus_target_group_arn) \
  --region us-east-1

Expected state:

healthy

## Connect to EC2 Using SSM

aws ssm start-session \
  --target $(terraform output -raw nexus_instance_id) \
  --region us-east-1

## Check Docker Container

Inside the EC2:

sudo docker ps

Check Nexus logs:

sudo docker logs nexus --tail 100

Restart Nexus:

sudo docker restart nexus

## Check Nexus Data Volume

df -h
lsblk
mount | grep nexus

Expected mount:

/opt/nexus-data

## Check CloudWatch Alarms

aws cloudwatch describe-alarms \
  --region us-east-1 \
  --query "MetricAlarms[*].[AlarmName,StateValue,MetricName]" \
  --output table

## Check SNS Subscription

aws sns list-subscriptions-by-topic \
  --topic-arn $(terraform output -raw sns_topic_arn) \
  --region us-east-1 \
  --output table

## Terraform Workflow

cd infra/envs/dev
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

## Safe Change Rule

Do not run terraform apply before reviewing the plan.

For risky changes, save the plan first:

terraform plan -out=tfplan
terraform apply tfplan
