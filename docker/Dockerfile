# This file should work for both amd64 and arm64 builds. Because segway did not release some source code we must copy some binaries for the specific architectures.
# That is why we must use some conditional statements to copy over the correct files during build process.
# Variable TARGETPLATFORM should be auomatically created during build process by docker.
ARG ROS_DISTRO
ARG UNDERLAY_WS

########################################
# Base Image for GO1 republisher       #
########################################
ARG ROS_DISTRO

FROM ros:${ROS_DISTRO} AS base

ARG ROS_DISTRO
ARG UNDERLAY_WS
ARG TARGETPLATFORM
ARG TARGETARCH

ENV ROS_DISTRO=${ROS_DISTRO}
ENV UNDERLAY_WS=${UNDERLAY_WS}
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    unzip \
    pkg-config \
    git \
    pkg-config \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    python3-dev \
    python3-numpy \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# install make install dependencies (are those needed?)
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    cmake

SHELL ["/bin/bash", "-c"]

# Create catkin workspace with external dependencies

RUN mkdir -p ${UNDERLAY_WS}/src
WORKDIR ${UNDERLAY_WS}/src
COPY dependencies.arm64.repos .
COPY dependencies.amd64.repos .

# Choose correct sources for architecture:
# Copy platform-specific files
# Use if condition to copy different files for different platforms
RUN echo "Hardware platform is: $(uname -m)"
RUN uname -a

RUN if [ "$(uname -m)" = "x86_64" ]; then \
  echo "Copying files for linux/amd64"; \
  mv dependencies.amd64.repos dependencies.repos; \
  else \
  echo "Copying files for linux/arm64"; \
  mv dependencies.arm64.repos dependencies.repos; \
  fi

RUN apt update && apt install -y \
      python3-vcstool \
      git

#RUN vcs import < dependencies.repos
RUN vcs import < dependencies.repos

# RUN chmod +x go1_republisher/scripts/mono.py \
#     && chmod +x go1_republisher/scripts/stereo.py

# Build the base catkin workspace, installing dependencies first.
WORKDIR ${UNDERLAY_WS}
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
  && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-camera-info-manager \
    python3-pip \
    python3-rosdep \
    # python-pip \
    # python-rospkg
    python3-rospkg \
    liblcm-dev \
    ros-${ROS_DISTRO}-controller-interface \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-effort-controllers \
    ros-${ROS_DISTRO}-joint-trajectory-controller \
    ros-${ROS_DISTRO}-amcl \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-slam-gmapping \
    ros-${ROS_DISTRO}-hector-slam \
    ros-${ROS_DISTRO}-map-server \
    ros-${ROS_DISTRO}-global-planner \
    ros-${ROS_DISTRO}-dwa-local-planner

RUN rosdep update && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -r -y
# rosdep problem?

ENV MAKEFLAGS="-j$(nproc)"

RUN pip3 install --upgrade pip \
    && pip3 install \ 
      opencv-python \
    #  pyyaml==5.4.1 \
      rospkg

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
  # && catkin_make -DCATKIN_BLACKLIST_PACKAGES="go1_republisher" install \
  && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_BLACKLIST_PACKAGES="go1_republisher" \
  # && source ${UNDERLAY_WS}/install/setup.bash \
  # && catkin_make
  && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && catkin_make -DCATKIN_WHITELIST_PACKAGES="go1_description"

# Set up the entrypoint
COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Command to run when the container is started
CMD ["bash"]

LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros

###########################################
# Overlay Image for GO1 Control           #
###########################################
FROM base AS overlay

ARG ROS_DISTRO
ARG UNDERLAY_WS
ARG OVERLAY_WS
ARG TARGETPLATFORM
ARG TARGETARCH

# Create an overlay workspace
RUN mkdir -p ${OVERLAY_WS}/src
WORKDIR ${OVERLAY_WS}/src
COPY overlay.repos .
RUN vcs import < overlay.repos

WORKDIR ${OVERLAY_WS}

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update \
    && apt-get install -y \
        nano \
        ros-${ROS_DISTRO}-foxglove-bridge \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/entrypoint.sh" ]

# Command to run when the container is started
CMD ["bash"]

LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros

###########################################
# GUI Additions for ROS                   #
###########################################
FROM overlay AS guis

ARG ROS_DISTRO
ARG UNDERLAY_WS
ARG OVERLAY_WS
ARG TARGETPLATFORM
ARG TARGETARCH

# Install additional GUI tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ros-${ROS_DISTRO}-rviz \
      ros-${ROS_DISTRO}-gazebo-ros-pkgs \
      ros-${ROS_DISTRO}-gazebo-ros-control \
      ros-${ROS_DISTRO}-rqt \
      ros-${ROS_DISTRO}-rqt-common-plugins \
      ros-${ROS_DISTRO}-rqt-robot-plugins \
      ros-${ROS_DISTRO}-rqt-rviz \
      ros-${ROS_DISTRO}-rqt-tf-tree \
      ros-${ROS_DISTRO}-rqt-web \
      ros-${ROS_DISTRO}-rqt-plot \
      ros-${ROS_DISTRO}-rqt-graph \
      ros-${ROS_DISTRO}-rqt-bag \
      ros-${ROS_DISTRO}-rqt-bag-plugins \
      ros-${ROS_DISTRO}-rqt-controller-manager \
      ros-${ROS_DISTRO}-rqt-moveit \
      ros-${ROS_DISTRO}-rqt-msg \
      ros-${ROS_DISTRO}-rqt-nav-view \
      ros-${ROS_DISTRO}-rqt-robot-monitor \
      ros-${ROS_DISTRO}-rqt-robot-steering \
      ros-${ROS_DISTRO}-rqt-robot-dashboard \
      ros-${ROS_DISTRO}-rqt-robot-plugins \
      ros-${ROS_DISTRO}-rqt-runtime-monitor \
      ros-${ROS_DISTRO}-rqt-shell \
      ros-${ROS_DISTRO}-rqt-srv \
  && rm -rf /var/lib/apt/lists/*

# Set up the entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command to run when the container is started
CMD ["bash"]

LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros

# This is an auto generated Dockerfile for ros:ros1-bridge
# generated from docker_images_ros2/ros1_bridge/create_ros_ros1_bridge_image.Dockerfile.em
FROM ros:eloquent-ros-base-bionic AS bridge

ARG ROS1_DISTRO
ARG ROS2_DISTRO

RUN apt update && apt install -y \
      curl \
      gnupg2 \
      lsb-release

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

ENV ROS1_DISTRO noetic
ENV ROS2_DISTRO eloquent

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS1_DISTRO}-ros-comm \
    ros-${ROS1_DISTRO}-roscpp-tutorials \
    ros-${ROS1_DISTRO}-rospy-tutorials \
    && rm -rf /var/lib/apt/lists/*

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS2_DISTRO}-ros1-bridge \
    ros-${ROS2_DISTRO}-demo-nodes-cpp \
    ros-${ROS2_DISTRO}-demo-nodes-py \
    ros-${ROS2_DISTRO}-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

# install downstream packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set up the entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command to run when the container is started
CMD ["bash"]

LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros

###########################################
# OUSTER Driver                           #
###########################################
FROM ros:noetic AS ouster

ARG UNDERLAY_WS
ARG OVERLAY_WS
ARG TARGETPLATFORM
ARG TARGETARCH

# Use bash shell
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
      ros-$ROS_DISTRO-pcl-ros \
      ros-$ROS_DISTRO-rviz \
      build-essential \
      libeigen3-dev \
      libjsoncpp-dev \
      libspdlog-dev \
      libcurl4-openssl-dev \
      cmake \
      inetutils-ping \
      avahi-utils \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    git \
  && rm -rf /var/lib/apt/lists/*    
# Create an overlay workspace
RUN mkdir -p ${OVERLAY_WS}/src
WORKDIR ${OVERLAY_WS}/src
RUN git clone --branch v0.10.0 --recurse-submodules https://github.com/ouster-lidar/ouster-ros.git

WORKDIR ${OVERLAY_WS}
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release

# setup entrypoint
COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set up the entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros

################################################################################################################################
# Intel Realsense Driver                                                                                                       #
################################################################################################################################
FROM base AS realsense

RUN apt-get update && apt-get install -y \
    ros-$ROS_DISTRO-realsense2-camera \
    ros-$ROS_DISTRO-realsense2-description \
    ros-$ROS_DISTRO-rgbd-launch \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set up the entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]

# Command to run when the container is started
CMD ["bash"]

LABEL org.opencontainers.image.source=https://github.com/bjoernellens1/go1-ros