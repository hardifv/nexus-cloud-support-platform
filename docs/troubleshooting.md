# Troubleshooting Guide

## 1. ALB Returns 503

Possible causes:

- No healthy targets
- Nexus container is down
- Security group issue
- Health check path mismatch
- EC2 is not attached to the Target Group

Checks:

cd infra/envs/dev

aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw nexus_target_group_arn) \
  --region us-east-1

If the target is unhealthy, connect to EC2:

aws ssm start-session \
  --target $(terraform output -raw nexus_instance_id) \
  --region us-east-1

Then check:

sudo docker ps
sudo docker logs nexus --tail 100

## 2. SSM TargetNotConnected

Possible causes:

- EC2 IAM Role is missing SSM permissions
- SSM Agent is not running
- VPC Endpoints are missing
- Endpoint Security Group is blocking 443
- Local Session Manager plugin is missing

Checks:

aws ssm describe-instance-information \
  --region us-east-1

Check IAM instance profile:

aws ec2 describe-instances \
  --instance-ids $(terraform output -raw nexus_instance_id) \
  --region us-east-1 \
  --query "Reservations[0].Instances[0].IamInstanceProfile"

Check VPC endpoints:

aws ec2 describe-vpc-endpoints \
  --region us-east-1 \
  --query "VpcEndpoints[*].[VpcEndpointId,ServiceName,State,PrivateDnsEnabled]"

If the error says SessionManagerPlugin is missing, install the plugin locally.

## 3. Nexus Container Is Down

Checks:

sudo docker ps -a
sudo docker logs nexus --tail 100

Common causes:

- EBS volume is not mounted
- Wrong permissions on /opt/nexus-data
- Docker service is not running
- Not enough disk space

Fixes:

sudo systemctl status docker
sudo systemctl restart docker
sudo chown -R 200:200 /opt/nexus-data
sudo docker restart nexus

## 4. EBS Volume Not Mounted

Checks:

df -h
lsblk
cat /etc/fstab

Expected mount:

/opt/nexus-data

Try remount:

sudo mount -a

## 5. Terraform Apply Failed Halfway

Do not immediately re-apply.

First check what was created:

terraform state list
terraform plan

If a resource exists in AWS but not in Terraform state, consider importing it.

If an EC2 instance needs to be recreated:

terraform apply -replace="module.ec2_nexus.aws_instance.nexus"

## 6. CloudWatch Alarm Triggered

ALB 5XX:

- Check Nexus container logs
- Check Target Group health
- Check ALB listener
- Check Security Groups

Unhealthy Target:

- Check EC2 instance status
- Check Docker status
- Check port 8081
- Check health check path

EC2 High CPU:

top
sudo docker stats

EC2 Status Check Failed:

aws ec2 describe-instance-status \
  --instance-ids $(terraform output -raw nexus_instance_id) \
  --region us-east-1
