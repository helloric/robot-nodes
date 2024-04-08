# Docker Environment for the Robots
This Repo holds the code to the docker images that should run on the Raspberry PI.
These Images need to build for the ARM64 platform.
Additionally the code for teleop images is here for debugging but could possibly be moved to its own repo in the future.

**Communication between Nodes does not work if you are using the VPN.**
*Containers where tested on Linux only*

## Prerequisites
Docker needs to be installed.
If you want to use / push images from / to the DFKI Distribution (Registry) you need to be in the DFKI network or connected to the DFKI VPN.
You need to be logged into the DFKI Distribution (Registry). *Normally this needs to be done only once*


## Ricbot Image
This Image contains the kobuki driver, the robot description, navigation including a map and drivers for camera and laser sensor.
The ricbot image is named `d-reg.hb.dfki.de/helloric/ricbot:humble_arm64`. 
**TODO: how to start**
To build the image you have 2 options:
1. build on the PI

    - 1.1. ssh in the robot `ssh ricbot@<robot ip>` 
    - 1.2. clone this repo `git clone https://git.hb.dfki.de/helloric/docker-env-robot.git`
    - 1.3. build the image with `docker build -t d-reg.hb.dfki.de/helloric/ricbot:humble_arm64 -f docker/Dockerfile-robot --build-arg="ROS_DISTRO=humble" .` *(This might take a while or the pi crashes - never tried to build on the PI)*
2. build on a PC (preferably with a lot of CPU cores and RAM)
    - 2.1. clone this repo `git clone https://git.hb.dfki.de/helloric/docker-env-robot.git`
    - 2.2. Create dockerx multiplatform `docker buildx create --name multiplatform --driver=docker-container`
    - 2.3. build the image with `docker buildx build -t d-reg.hb.dfki.de/helloric/ricbot:humble_arm64 --load --builder=multiplatform --platform=linux/arm64 -f docker/Dockerfile-robot --build-arg="ROS_DISTRO=humble" .`

You should then push the image to the registry with `docker push d-reg.hb.dfki.de/helloric/kobuki_driver:humble_arm64`. *(You need to be logged in to the Registry for that + The Registry is only reachable from within the DFKI Network or using the VPN)*


## Kobuki Base Driver
This Image only holds the driver for the kobuki base and is a stripped down version of the Ricbot image
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


## Teleop Image
The Teleop Image can be used for debugging to move the robot around using the keyboard.
The image is named `d-reg.hb.dfki.de/helloric/kobuki_teleop:humble` and can be started on you local machine (in the same network as the robot) with `docker run -it --network host d-reg.hb.dfki.de/helloric/kobuki_teleop:humble`.
To build the image run `docker build -t d-reg.hb.dfki.de/helloric/kobuki_teleop:humble -f docker/Dockerfile-teleop --build-arg="ROS_DISTRO=humble" .`

## DS4 Image
**!!!Using the Gamepad will tip the robot over!!!**
**It can only be used with extreme caution!**
The DS4 Image can be used for debugging to move the robot around using a dualshock 4 controller.
The image is named `d-reg.hb.dfki.de/helloric/kobuki_teleop_ds4:humble` and can be started on you local machine (in the same network as the robot) with `docker run -it --network host d-reg.hb.dfki.de/helloric/kobuki_teleop_ds4:humble`.
To build the image run `docker build -t d-reg.hb.dfki.de/helloric/kobuki_teleop_ds4:humble -f docker/Dockerfile-ds4 --build-arg="ROS_DISTRO=humble" .`