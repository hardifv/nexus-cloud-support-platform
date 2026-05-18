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

