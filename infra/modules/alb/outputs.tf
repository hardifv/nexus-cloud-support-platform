output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "nexus_target_group_arn" {
  description = "Nexus target group ARN"
  value       = aws_lb_target_group.nexus.arn
}

output "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  description = "Target Group ARN suffix for CloudWatch metrics"
  value       = aws_lb_target_group.nexus.arn_suffix
}