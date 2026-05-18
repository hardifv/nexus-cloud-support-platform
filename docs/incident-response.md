# Incident Response

## Purpose

This document defines a simple incident response process for the Nexus Cloud Support Platform.

## Severity Levels

### SEV1

Nexus is unavailable for all users.

Examples:

- ALB returns 503
- No healthy targets
- EC2 status check failed

### SEV2

Nexus is degraded but partially available.

Examples:

- Slow responses
- High CPU
- Intermittent 5XX errors

### SEV3

Non-urgent operational issue.

Examples:

- Alarm misconfiguration
- Documentation update needed
- Minor Terraform drift

## Response Steps

1. Acknowledge the alert.
2. Check CloudWatch alarm details.
3. Check ALB Target Group health.
4. Connect to EC2 using SSM.
5. Check Docker and Nexus logs.
6. Identify recent changes.
7. Apply remediation.
8. Validate service recovery.
9. Document root cause and follow-up actions.

## Useful Commands

Check alarms:

aws cloudwatch describe-alarms \
  --region us-east-1 \
  --query "MetricAlarms[*].[AlarmName,StateValue,MetricName]" \
  --output table

Check Target Group health:

aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw nexus_target_group_arn) \
  --region us-east-1

Connect to EC2:

aws ssm start-session \
  --target $(terraform output -raw nexus_instance_id) \
  --region us-east-1

Check Nexus:

sudo docker ps
sudo docker logs nexus --tail 100

## RCA Template

Incident:
Start time:
End time:
Impact:
Detection method:
Root cause:
Resolution:
What went well:
What could be improved:
Follow-up actions:
