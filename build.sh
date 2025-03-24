#!/bin/bash

# Variables
IMAGE_NAME="nadinc/guvi_final_prj"
VERSION=$(date +%Y%m%d_%H%M%S)
TAG="v${VERSION}"

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling
set -e
trap 'log "Error occurred during build process."' ERR

# Start build process
log "Starting Docker build process..."

# Build Docker image with both version tag and latest
docker build \
    -t ${IMAGE_NAME}:${TAG} \
    -t ${IMAGE_NAME}:latest \
    --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg VERSION="${TAG}" \
    .

# Verify build success
if [ $? -eq 0 ]; then
    log "Docker image built successfully"
    log "Image: ${IMAGE_NAME}:${TAG}"
    log "Image: ${IMAGE_NAME}:latest"
else
    log "Build failed"
    exit 1
fi

# Push images if needed (commented out by default)
# log "Pushing images to registry..."
# docker push ${IMAGE_NAME}:${TAG}
# docker push ${IMAGE_NAME}:latest
