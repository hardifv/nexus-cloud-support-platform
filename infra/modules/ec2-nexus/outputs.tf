output "nexus_instance_id" {
  description = "Nexus EC2 instance ID"
  value       = aws_instance.nexus.id
}

output "nexus_private_ip" {
  description = "Nexus EC2 private IP"
  value       = aws_instance.nexus.private_ip
}