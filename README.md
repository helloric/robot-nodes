# Docker Environment for the Robots
This Repo holds the code to the docker containers that should run on the Raspberry PI.
These Images need to build for the ARM64 platform.
Additionally the code to the teleop container is here for debugging but could possibly be moved to its own repo in the future.

## Kobuki Base Driver
The Image for the kobuki base driver node is named `d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64`. If you want to start the Container you need to
1. ssh in the robot `ssh ricbot@<robot ip>` 
2. start the container with `docker run -it -d --network host --device=/dev/ttyUSB0 d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64` 
If you want to see the output of the node omit the `-d` option.

A start up sound should be played and you should be able to see the following topics with `ros2 topic list`:
```
/commands/controller_info
/commands/digital_output
/commands/external_power
/commands/led1
/commands/led2
/commands/motor_power
/commands/reset_odometry
/commands/sound
/commands/velocity
/controller_info
/debug/raw_control_command
/debug/raw_data_command
/debug/raw_data_stream
/diagnostics
/events/bumper
/events/button
/events/cliff
/events/digital_input
/events/power_system
/events/robot_state
/events/wheel_drop
/joint_states
/odom
/parameter_events
/rosout
/sensors/battery_state
/sensors/core
/sensors/dock_ir
/sensors/imu_data
/sensors/imu_data_raw
/tf
/version_info
```

To build the image you have 2 options:
1. build on the PI

    - 1.1. ssh in the robot `ssh ricbot@<robot ip>` 
    - 1.2. clone this repo `git clone https://git.hb.dfki.de/helloric/docker-env-robot.git`
    - 1.3. build the image with `docker build -t d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64 -f docker/Dockerfile-kobuki_driver --build-arg="ROS_DISTRO=humble" .` *(This might take a while or the pi crashes - never tried to build on the PI)*
2. build on a PC (preferably with a lot of CPU cores and RAM)
    - 2.1. clone this repo `git clone https://git.hb.dfki.de/helloric/docker-env-robot.git`
    - 2.2. Create dockerx multiplatform `docker buildx create --name multiplatform --driver=docker-container`
    - 2.3. build the image with `docker buildx build -t d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64 --load --builder=multiplatform --platform=linux/arm64 -f docker/Dockerfile-kobuki_driver --build-arg="ROS_DISTRO=humble" .`

You should then push the image to the registry with `docker push d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64`. *(You need to be logged in to the Registry for that + The Registry is only reachable from within the DFKI Network or using the VPN)*


## Teleop Node
The Teleop Node can be used for debugging to move the robot around using the keyboard.
The image is named `d-reg.hb.dfki.de/helloric/kobuki_teleop:humble` and can be started on you local machine (in the same network as the robot) with `docker run -it --network host d-reg.hb.dfki.de/helloric/kobuki_teleop:humble`.
To build the image run `docker build -t d-reg.hb.dfki.de/helloric/kobuki_teleop:humble -f docker/Dockerfile-teleop --build-arg="ROS_DISTRO=humble" .`

**Communication between Nodes does not work if you are using the VPN.**


## Installation

1. Install docker-ce
1. ssh into the robot with agent forwarding: `ssh -A ricbot@10.250.219.229`
1. checkout this repository with all submodules: `git submodule update --init --recursive`
1. sync with the robot or update on robot directly: `rsync -r docker-env-robot/ ricbot@10.250.219.229:docker-env-robot/`

## Run Docker locally for building

1. Create dockerx multiplatform `docker buildx create --name multiplatform --driver=docker-container`
1. Build using docker compose: `docker compose build` or `docker buildx build -t ricbot:humble --load --builder=multiplatform --platform=linux/arm64 -f docker/Dockerfile-robot --build-arg="ROS_DISTRO=humble" .`
