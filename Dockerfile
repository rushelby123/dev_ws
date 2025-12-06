FROM osrf/ros:jazzy-desktop-full

ARG USER_NAME=developer
ARG ROS_DOMAIN_ID=83

# User configuration
RUN usermod -l ${USER_NAME} ubuntu && \
    groupmod -n ${USER_NAME} ubuntu && \
    usermod -d /home/${USER_NAME} -m ${USER_NAME} && \
    usermod -aG sudo ${USER_NAME} && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME}

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    ros-jazzy-ros-gz* \
    ros-jazzy-twist-mux \
    ros-jazzy-ros2-control \
    ros-jazzy-ros2-controllers
    
# Switch to normal user
USER ${USER_NAME}

# Install repos
WORKDIR /home/${USER_NAME}/ros2_ws
RUN mkdir -p src
COPY source.repos .
RUN cat source.repos && \
    vcs import src < source.repos --debug 

# Setup user environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/${USER_NAME}/.bashrc && \
    echo "[ -f /etc/bash_completion ] && . /etc/bash_completion" >> /home/${USER_NAME}/.bashrc
