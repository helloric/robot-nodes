#!/bin/bash
./build.bash
./save_all.bash
rsync -av --info=progress2 *.tar robot@10.250.3.46:~/docker-env-robot/
scp load_all.bash "robot@10.250.3.46:~/docker-env-robot/load_all.bash"
scp compose.yml "robot@10.250.3.46:~/docker-env-robot/compose.yml"
ssh robot@10.250.3.46 "cd ~/docker-env-robot/ && ./load_all.bash && /usr/bin/docker compose down && docker compose up -d ds4 ui ui_com ricbot"