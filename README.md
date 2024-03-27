# Docker Environment for the Robots

## Installation

1. Install docker-ce
1. ssh into the robot with agent forwarding: `ssh -A ricbot@10.250.219.229`
1. checkout this repository with all submodules: `git submodule update --init --recursive`
1. sync with the robot or update on robot directly: `rsync -r docker-env-robot/ ricbot@10.250.219.229:docker-env-robot/`

## Run Docker locally for building

1. Create dockerx multiplatform `docker buildx create --name multiplatform --driver=docker-container`
1. Build using docker compose: `docker compose build` or `docker buildx build -t ricbot:humble --load --builder=multiplatform --platform=linux/arm64 -f docker/Dockerfile-robot --build-arg="ROS_DISTRO=humble" .`
