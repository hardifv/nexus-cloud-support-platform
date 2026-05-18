output "nexus_instance_profile_name" {
  description = "Instance profile name for Nexus EC2"
  value       = aws_iam_instance_profile.nexus.name
}