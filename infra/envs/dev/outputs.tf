output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "nexus_target_group_arn" {
  description = "Nexus target group ARN"
  value       = module.alb.nexus_target_group_arn
}

output "nexus_instance_id" {
  description = "Nexus EC2 instance ID"
  value       = module.ec2_nexus.nexus_instance_id
}

output "nexus_private_ip" {
  description = "Nexus private IP"
  value       = module.ec2_nexus.nexus_private_ip
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = module.monitoring.sns_topic_arn
}

output "cloudwatch_alarm_names" {
  description = "CloudWatch alarm names"
  value       = module.monitoring.alarm_names
}