#!/bin/bash
set -e

dnf update -y

# Ensure SSM Agent is installed and running
dnf install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent


# Install Docker
dnf install -y docker

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Create Nexus data directory
mkdir -p /opt/nexus-data
chown -R 200:200 /opt/nexus-data

# Run Nexus as Docker container
docker run -d \
  --name nexus \
  --restart unless-stopped \
  -p 8081:8081 \
  -v /opt/nexus-data:/nexus-data \
  sonatype/nexus3:3.68.1

# Basic status output for troubleshooting
docker ps