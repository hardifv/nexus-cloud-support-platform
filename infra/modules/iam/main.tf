locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_iam_role" "nexus_ec2" {
  name = "${local.name_prefix}-nexus-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${local.name_prefix}-nexus-ec2-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.nexus_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nexus" {
  name = "${local.name_prefix}-nexus-instance-profile"
  role = aws_iam_role.nexus_ec2.name
}