locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for public Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to Nexus EC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name        = "${local.name_prefix}-alb-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "nexus" {
  name        = "${local.name_prefix}-nexus-sg"
  description = "Security group for Nexus EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Nexus traffic from ALB"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound internet access through NAT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name_prefix}-nexus-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from Nexus EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.nexus.id]
  }

  tags = {
    Name        = "${local.name_prefix}-rds-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "ssm_endpoints" {
  name        = "${local.name_prefix}-ssm-endpoints-sg"
  description = "Security group for SSM VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from VPC to SSM endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound from SSM endpoints"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name_prefix}-ssm-endpoints-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}