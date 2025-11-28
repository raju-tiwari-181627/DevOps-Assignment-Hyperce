#!/bin/bash

set -e

echo "Starting deployment process..."

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker not found. Please install Docker first."
    exit 1
fi

# Check docker compose installation (newer plugin format)
if ! command -v docker compose &> /dev/null; then
    echo "ERROR: docker compose not found. Please install docker compose first."
    exit 1
fi

echo "Building Docker image..."
docker build -f .docker/server/Dockerfile -t rajutiwari181627/raju-hyperce:v1 .

echo "Starting containers..."
docker compose -f .docker/server/docker-compose-script.yml up -d

echo "Waiting for containers to start..."
sleep 10

# Check container status using your specific container name
if [ "$(docker ps -q -f name=raju-app)" ]; then
    echo "SUCCESS: App is running successfully!"
    docker compose -f .docker/server/docker-compose-script.yml ps
else
    echo "ERROR: App failed to start!"
    docker compose -f .docker/server/docker-compose-script.yml ps -a
    docker compose -f .docker/server/docker-compose-script.yml logs
    exit 1
fi
