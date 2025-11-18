# Docker Environment for the Robots
This Repo holds the code to the docker images that should run on the Raspberry PI.
These Images need to build for the ARM64 platform, we cross compile them here.
Additionally the code for teleop images is here for debugging but could possibly be moved to its own repo in the future.

**Communication between Nodes does not work if you are using the VPN.**
*Containers where tested on Linux only*

## Prerequisites
Docker needs to be installed on the robot, only tested with docker-ce.
If you want to build images locally you need Docker installed on your local system as well. (Ideally, this is not necessary)

## Image overview
All images are already built in our [Harbor](https://harbor.hb.dfki.de/harbor/projects/10/repositories) 

### ricbot
This image contains the [kobuki driver](https://github.com/helloric/docker-env-kobuki), the [robot description](https://github.com/helloric/ricbot_description), [navigation](https://github.com/helloric/ricbot_navigation) including a map and drivers for camera and laser sensor.

### [ui](https://github.com/helloric/svelte-ui)
The UI image provides the Svelte-UI for the robot. Note that the UI can not directly talk to ROS, it depends on the ui_com service.

### [ui_com](https://github.com/helloric/helloric_ui_com)
The ui-com image provides the backend via WebSocket for the UI and allows communication between the UI and the rest of the robot.

### [teleop](https://index.ros.org/r/teleop_twist_keyboard/#jazzy)
The teleop image can be used for debugging to move the robot around using the keyboard.

### [ds4](https://github.com/naoki-mizuno/ds4_driver)
**⚠ Using the Gamepad will tip the robot over! ⚠**

**It can only be used with extreme caution!**

The ds4 Image can be used moving the robot around using a PlayStation DualShock 4 controller.


## Building Images

You do not need to build the image manually however if you want to build it:
1. Checkout and update this repo including all submodules: `git submodule update --init --recursive`
1. Call the `build.bash`-script.

It will cross-build all required docker images from the code in the submodule-folders as the specified version.

## Deploying on the robot
Copy the "compose.yml" file from this repository to the robot, if it already exists you probably want to overwrite it. However backup the compose.yml-file before, like this:
```bash
# connect to the robot and move the compose file
ssh robot@10.250.X.X:
# make sure the compose file exists
ls
# rename the file
mv compose.yml compose_backup.yml
```

Now copy the new compose file to the robot:
```bash
# on your machine, change the path of the compose.yml and 
scp compose.yml robot@10.250.X.X:
```

Alternatively you can also just save the images you have build and use ssh to copy them to the robot. For the ricbot-image you can do something like this:


```bash
# on your PC
docker save -o ricbot.tar harbor.hb.dfki.de/helloric/ricbot:jazzy_arm64_001
# copy this to the robot, change X.X to the actual IP of the robot, do NOT remove the colon (:) at the end
scp ricbot.tar robot@10.250.X.X:

# now SSH  on the robot and load the image like this:
docker load -i ricbot.tar
```
See [docker documentation](https://docs.docker.com/reference/cli/docker/image/load/) for details

Because the image can be a few GB big its recommended to connect PC and robot via cable.

### Run the image
You can just run the image:
1. copy the `compose.yml` to the robot, for example using scp would look like this:  `scp compose.yml robot@10.250.X.X:`
1. run `docker compose up ricbot ui ds4 -d` that will start the basic ricbot, ui (with ui-com as it depends on it) and ds4 as defined in the `compose.yml` file in the background
1. if you want to get the log output you can run `docker compose logs -f`. Press <kbd>Ctrl</kbd>+<kbd>c</kbd> to quit logging.
1. to stop the docker container run `docker compose down`.

Note that the `up` and `run` commands on docker compose are different. `up` also activates the port forwarding, the run-command only starts a new instance without exposing ports to outside. You can not connect to your robot if you start a docker container with "run", so you always want to use `docker compose up` to start but `docker compose run ricbot bash` can be helpful to access a terminal with the same configuration as the robot if you like to test something locally.

## Contributing

Please use the [issue tracker](https://github.com/helloric/robot-nodes/issues) to submit bug reports and feature requests. Please use Pull Requests as described [here](/CONTRIBUTING.md) to add/adapt functionality. 

## License

This docker environment setup is distributed under the [3-clause BSD license](https://opensource.org/licenses/BSD-3-Clause).

## Maintainer / Authors / Contributers

- Andreas Bresser, andreas.bresser@dfki.de
- Adrian Auer, adrian.auer@dfki.de

