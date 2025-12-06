#!/bin/bash

CONTAINER_NAME="forklift_dev_container"
IMAGE_NAME="forklift_dev_image"
USER_NAME="rushelby"
HOST_WS_DIR="${PWD}/ros2_ws"    # Directory per il workspace ros2

# Function to copy workspace from image to host
copy_workspace() {
    echo "🔄 Copying ros2 workspace from Docker image to host..."
    
    # Create temporary container to copy workspace
    TEMP_CONTAINER="${CONTAINER_NAME}_temp"
    docker create --name $TEMP_CONTAINER $IMAGE_NAME
    
    # Create host directory if it doesn't exist
    mkdir -p $HOST_WS_DIR
    
    # Copy workspace CONTENTS from container to host (note the /. at the end)
    docker cp $TEMP_CONTAINER:/home/$USER_NAME/ros2_ws/. $HOST_WS_DIR/
    
    # Remove temporary container
    docker rm $TEMP_CONTAINER
    
    # Fix permissions
    sudo chown -R $(id -u):$(id -g) $HOST_WS_DIR
    
    echo "✅ Workspace copied successfully to $HOST_WS_DIR"
}

# Allow Docker to access the X server
xhost +local:docker

# Check if the container already exists and is running
if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "🔄 Attaching to running container"
    docker exec -it "$CONTAINER_NAME" bash
elif [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "🚀 Starting stopped container"
    docker start -ai "$CONTAINER_NAME"
else
    echo "📋 Copying fresh workspace from image..."
    copy_workspace
    echo "🆕 Creating and starting new container"
    docker run -it \
        --ipc=host \
        --pid=host \
        --net=host \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume="/dev:/dev" \
        --group-add audio \
        --group-add video \
        --env PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native \
        --volume /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
        --volume /dev/shm:/dev/shm \
        --volume $HOST_WS_DIR:/home/$USER_NAME/ros2_ws \
        --name $CONTAINER_NAME \
        $IMAGE_NAME 
fi

# Revoke X access after container usage
xhost -local:docker
