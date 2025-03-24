#!/bin/bash

# Configuration
IMAGE_NAME="nadinc/guvi_final_prj"
CONTAINER_NAME="jenkins-docker-container"
HOST_PORT=8080
CONTAINER_PORT=80
VERSION=$(date +%Y%m%d_%H%M%S)
TAG="v${VERSION}"

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling
set -e
trap 'log "Error occurred. Deployment failed."' ERR

log "Starting deployment process..."

# Stop and remove any existing container
if docker ps -a | grep -q $CONTAINER_NAME; then
    log "Stopping and removing existing container..."
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Remove old images to clean up space
log "Cleaning up old images..."
docker image prune -f

# Run the new container
log "Starting new container..."
docker run -d \
    --name $CONTAINER_NAME \
    -p ${HOST_PORT}:${CONTAINER_PORT} \
    --restart unless-stopped \
    --health-cmd="curl -f http://localhost:${CONTAINER_PORT} || exit 1" \
    --health-interval=1m \
    --health-timeout=10s \
    --health-retries=3 \
    ${IMAGE_NAME}:${TAG}

# Wait for container to be healthy
log "Waiting for container health check..."
for i in {1..30}; do
    if docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME | grep -q healthy; then
        log "Container is healthy!"
        exit 0
    fi
    sleep 2
done

log "Container health check failed after 60 seconds"
exit 1
