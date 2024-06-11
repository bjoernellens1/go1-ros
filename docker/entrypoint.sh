#!/bin/bash
# Basic entrypoint for ROS / Colcon Docker containers

# Source ROS
source /opt/ros/${ROS_DISTRO}/setup.bash
echo "Sourced ROS ${ROS_DISTRO}"

# Source the base workspace, if built
if [ -f ${UNDERLAY_WS}/develop/setup.bash ]
then
  source ${UNDERLAY_WS}/develop/setup.bash
  echo "Sourced GO1 underlay workspace"
fi

# Source the overlay workspace, if built
if [ -f /overlay_ws/develop/setup.bash ]
then
  source /overlay_ws/develop/setup.bash
  echo "Sourced GO1 Overlay workspace"
fi

# Source the bridge workspace, if built
if [ -f /opt/ros/melodic/local_setup.bash ]
then
  source /opt/ros/melodic/local_setup.bash
  echo "Sourced melodic distribution"
fi

if [ -f /opt/ros/eloquent/local_setup.bash ]
then
  source /opt/ros/eloquent/local_setup.bash
  echo "Sourced eloquent distribution"
fi

# Execute the command passed into this entrypoint
exec "$@"