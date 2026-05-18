data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_instance" "nexus" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.medium"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.nexus_security_group_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = false

  user_data = file("${path.module}/install-docker-nexus.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "${local.name_prefix}-nexus-ec2"
    Environment = var.environment
    Project     = var.project_name
    App         = "nexus"
    Version     = "3.68.1"
  }
}

resource "aws_lb_target_group_attachment" "nexus" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.nexus.id
  port             = 8081
}

