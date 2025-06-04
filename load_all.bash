#!/bin/bash
docker load -i ricbot.tar
docker load -i ui.tar
docker load -i ui_com.tar
docker load -i teleop.tar
docker load -i ds4.tar
docker system prune -f