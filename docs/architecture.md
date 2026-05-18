# Architecture

## Overview

This project deploys Nexus Repository Manager on AWS using Terraform.

Nexus runs as a Docker container on a private EC2 instance behind an Application Load Balancer.

The platform is designed for cloud operations, troubleshooting, secure access, monitoring, and controlled infrastructure changes.

## High-Level Flow

Internet
  -> Application Load Balancer :80
  -> Target Group :8081
  -> Private EC2 Instance
  -> Docker
  -> Nexus Repository Manager

## Operational Access

The EC2 instance does not have a public IP and does not use SSH keys.

Access is handled through AWS Systems Manager Session Manager.

Engineer
  -> AWS CLI
  -> SSM Session Manager
  -> Private EC2

## Main AWS Components

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- Application Load Balancer
- Target Group
- EC2
- Dedicated EBS volume for Nexus data
- IAM Role
- SSM VPC Endpoints
- CloudWatch Alarms
- SNS Topic

## Storage

Nexus data is stored on a dedicated EBS volume mounted at:

/opt/nexus-data

The root volume is used for the operating system and Docker.

## Monitoring

CloudWatch alarms monitor:

- ALB 5XX errors
- Target Group unhealthy hosts
- EC2 high CPU
- EC2 status check failures

Alerts are sent through SNS.
