variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "alarm_email" {
  type        = string
  description = "Email address for alarm notifications"
}

variable "alb_arn_suffix" {
  type        = string
  description = "ALB ARN suffix used by CloudWatch metrics"
}

variable "target_group_arn_suffix" {
  type        = string
  description = "Target Group ARN suffix used by CloudWatch metrics"
}

variable "nexus_instance_id" {
  type        = string
  description = "Nexus EC2 instance ID"
}