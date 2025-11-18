#!/bin/bash
echo "saving ricbot..."
docker save -o ricbot.tar d-reg.hb.dfki.de/helloric/ricbot:jazzy_arm64_001
echo "saving ui..."
docker save -o ui.tar d-reg.hb.dfki.de/helloric/ui:arm64_001
echo "saving ui_com..."
docker save -o ui_com.tar d-reg.hb.dfki.de/helloric/ui_com:jazzy_arm64_001
echo "saving teleop..."
docker save -o teleop.tar d-reg.hb.dfki.de/helloric/teleop:jazzy_arm64_001
echo "saving ds4..."
docker save -o ds4.tar d-reg.hb.dfki.de/helloric/ds4:jazzy_arm64_001