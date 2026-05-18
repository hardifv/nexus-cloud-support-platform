locals {
  name_prefix = "${var.project_name}-${var.environment}"

  ssm_services = [
    "ssm",
    "ssmmessages",
    "ec2messages"
  ]
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = toset(local.ssm_services)

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "${local.name_prefix}-${each.key}-endpoint"
    Environment = var.environment
    Project     = var.project_name
  }
}