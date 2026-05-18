variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "account_id" {
  type        = string
  description = "AWS account ID used to make the S3 bucket name globally unique"
}
