output "ssm_endpoint_ids" {
  description = "SSM VPC endpoint IDs"
  value       = { for name, endpoint in aws_vpc_endpoint.ssm : name => endpoint.id }
}