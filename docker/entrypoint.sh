#!/bin/bash
# Basic entrypoint for ROS / Colcon Docker containers

# Ensure the required environment variables are set
: "${ROS_DISTRO:?Environment variable ROS_DISTRO not set or empty}"
: "${UNDERLAY_WS:?Environment variable UNDERLAY_WS not set or empty}"
: "${OVERLAY_WS:?Environment variable OVERLAY_WS not set or empty}"

# Source ROS
source /opt/ros/${ROS_DISTRO}/setup.bash
echo "Sourced ROS ${ROS_DISTRO}"

# Source the base workspace, if built
if [ -f ${UNDERLAY_WS}/devel/setup.bash ]
then
  source ${UNDERLAY_WS}/develop/setup.bash
  echo "Sourced GO1 ${UNDERLAY_WS} workspace"
fi

# Source the overlay workspace, if built
if [ -f ${OVERLAY_WS}/devel/setup.bash ]
then
  source ${OVERLAY_WS}/develop/setup.bash
  echo "Sourced GO1 ${OVERLAY_WS} workspace"
fi

# Source the bridge workspace, if built
if [ -f /opt/ros/melodic/local_setup.bash ]
then
  source /opt/ros/melodic/local_setup.bash
  echo "Sourced melodic distribution for ROS2 bridge"
fi

if [ -f /opt/ros/eloquent/local_setup.bash ]
then
  source /opt/ros/eloquent/local_setup.bash
  echo "Sourced eloquent distribution for ROS2 bridge"
fi

# Execute the command passed into this entrypoint
exec "$@"