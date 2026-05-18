#!/bin/bash
set -e

dnf update -y

# Ensure SSM Agent is installed and running
dnf install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# Install Docker
dnf install -y docker
systemctl enable docker
systemctl start docker

# Wait for the EBS volume to be attached
DEVICE="/dev/xvdf"
ALT_DEVICE="/dev/nvme1n1"

for i in {1..30}; do
  if [ -b "$DEVICE" ]; then
    DATA_DEVICE="$DEVICE"
    break
  elif [ -b "$ALT_DEVICE" ]; then
    DATA_DEVICE="$ALT_DEVICE"
    break
  fi

  echo "Waiting for EBS data volume..."
  sleep 5
done

if [ -z "$DATA_DEVICE" ]; then
  echo "EBS data volume not found"
  exit 1
fi

# Format only if the volume has no filesystem
if ! blkid "$DATA_DEVICE"; then
  mkfs -t xfs "$DATA_DEVICE"
fi

mkdir -p /opt/nexus-data

# Add to fstab if not already present
UUID=$(blkid -s UUID -o value "$DATA_DEVICE")

if ! grep -q "$UUID" /etc/fstab; then
  echo "UUID=$UUID /opt/nexus-data xfs defaults,nofail 0 2" >> /etc/fstab
fi

mount -a

chown -R 200:200 /opt/nexus-data

# Run Nexus container
docker run -d \
  --name nexus \
  --restart unless-stopped \
  -p 8081:8081 \
  -v /opt/nexus-data:/nexus-data \
  sonatype/nexus3:3.68.1

docker ps