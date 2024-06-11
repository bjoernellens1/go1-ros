# GO1-ROS-MELODIC
## CPS Docker workspace for Unitree GO1 ROS development

### Introduction
This repository houses all code needed for starting developing ROS packages for the Unitree GO1 quadruped robot.

We are using Docker because it makes it easier to run different ROS environments even on most recent operating systems. Also, it provides a safe way to run our code on the GO1 implemented hardware (Jetson Nano, Raspberry Pi), without interfering with the base system too much. Btw. they use arm64 architecture.

### Build process
For the build with docker buildx bake you will need binfmt dependencies for arm64 architecture, as we are doing a multiplatform build (Works on normal PCs as well as Jetson Nano, Raspberry Pi, Apple Silicon Devices).

For Robot:
```
docker buildx bake overlay --load
docker buildx bake overlay --push
```
e.g.:
```
docker compose up -d controller
```
For PC:
```
docker buildx bake guis --load
docker buildx bake guis --push
```
--> get into container shell:
```
docker compose run guis
```
or
```
docker compose up rviz2
```


### Detailed description

# ROS Melodic Docker Compose Project

This project sets up a ROS Melodic environment with GUI support, utilizing Docker Compose. The setup includes services for base dependencies, project-specific overlay, GUI applications, and ROS1 bridge with roscore.

## Prerequisites

- Docker
- Docker Compose
- An Intel or NVIDIA GPU (optional, for GPU support)
- X11 server running on your host machine

## Services Overview

### Base Service (`base`)

The `base` service is the foundational image that contains all necessary dependencies for running ROS Melodic. It includes the following features:

- ROS Melodic installation
- Networking and IPC settings for ROS communication
- X11 configuration for displaying graphical applications
- NVIDIA GPU support configuration

### Overlay Service (`overlay`)

The `overlay` service extends the base service to include project-specific source code. This allows you to build and run your ROS projects within the Docker environment.

### GUI Service (`guis`)

The `guis` service extends the overlay service to include additional dependencies for GUI applications. This is particularly useful for running ROS tools with graphical interfaces.

### ROS1 Bridge Service (`ros1bridge`)

The `ros1bridge` service sets up a bridge between ROS1 and ROS2, enabling communication between ROS1 and ROS2 nodes.

### ROS1 Roscore Service (`roscore`)

The `roscore` service runs the `roscore`, which is the central node in a ROS1 system. It handles naming and registration of ROS nodes.

## Docker Compose Configuration

### Dockerfile

The `Dockerfile` defines the images for each service. It sets up the base dependencies, project overlay, and GUI dependencies.

```Dockerfile
FROM osrf/ros:melodic-desktop-full

# Set environment variable to suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    mesa-utils \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC server
RUN mkdir -p ~/.vnc \
    && echo "password" | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 ~/.vnc/passwd

# Set up startup script for VNC server
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > ~/.vnc/xstartup \
    && chmod +x ~/.vnc/xstartup

# Set up supervisord to run both VNC server and noVNC
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the VNC and noVNC ports
EXPOSE 5901 6080

# Start supervisord
CMD ["/usr/bin/supervisord"]
