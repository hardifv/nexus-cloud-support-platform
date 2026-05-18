output "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarms"
  value       = aws_sns_topic.alerts.arn
}

output "alarm_names" {
  description = "CloudWatch alarm names"
  value = [
    aws_cloudwatch_metric_alarm.alb_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.unhealthy_targets.alarm_name,
    aws_cloudwatch_metric_alarm.ec2_high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.ec2_status_check_failed.alarm_name
  ]
}