output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "nexus_security_group_id" {
  description = "Nexus EC2 security group ID"
  value       = aws_security_group.nexus.id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "ssm_endpoints_security_group_id" {
  description = "Security group ID for SSM VPC endpoints"
  value       = aws_security_group.ssm_endpoints.id
}