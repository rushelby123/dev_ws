#!/bin/bash

# Configuration
USERNAME="rushelby"
ROS_DOMAIN_ID="83"
IMAGE_NAME="forklift_dev_image"

# Build Docker image
docker build \
    --network=host \
    --build-arg USER_NAME="$USERNAME" \
    --build-arg USER_UID=$(id -u) \
    --build-arg USER_GID=$(id -g) \
    --build-arg ROS_DOMAIN_ID="$ROS_DOMAIN_ID" \
    --tag "$IMAGE_NAME" \
    --no-cache \
    .
