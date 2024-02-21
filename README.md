# Docker Environment for the Robots
## Installation
1. Install docker-ce
1. ssh into the robot with agent forwarding: `ssh -A ricbot@10.250.219.229`
1. checkout this repository with all submodules: `git submodule update --init --recursive`
1. sync with the robot or update on robot directly: `rsync -r docker-env-robot/ ricbot@10.250.219.229:docker-env-robot/`