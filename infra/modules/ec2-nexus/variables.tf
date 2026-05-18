variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID for Nexus EC2"
}

variable "nexus_security_group_id" {
  type        = string
  description = "Security group ID for Nexus EC2"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
}

variable "target_group_arn" {
  type        = string
  description = "ALB Target Group ARN"
}

variable "nexus_data_volume_size" {
  type        = number
  description = "Size of the dedicated EBS volume for Nexus data in GB"
  default     = 30
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the Nexus EC2 instance"
}