# Nexus Cloud Support Platform

This project simulates a real-world cloud support environment for operating an internal artifact repository platform on AWS.

The goal is to demonstrate operational support, infrastructure automation, CI/CD reliability, troubleshooting, documentation, and safe cloud change practices using AWS, Terraform, and Jenkins.

## Role Alignment

This project is designed around a Cloud Support Engineer role focused on:

- AWS cloud infrastructure support
- Jenkins pipeline execution and troubleshooting
- Terraform-based infrastructure deployments
- Cloud networking, compute, and IAM operations
- Incident response and root cause analysis
- Operational runbooks and support documentation
- Safe change management and blue/green upgrade practices

## Architecture Overview

Nexus Repository Manager will run on a private EC2 instance behind an Application Load Balancer.

The application will use RDS PostgreSQL as the database backend.

```text
Internet
   |
Application Load Balancer
   |
Target Group
   |
Private EC2 Instance
   |
RDS PostgreSQL