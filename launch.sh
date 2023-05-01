#!/bin/bash

# Check if the current user is in the Docker group
if [[ $(id -nG) =~ "docker" ]] ; then
    echo "$USER in Docker Group"
else
  # Add the current user to the Docker group
  echo "Adding $USER to the Docker group"
  sudo usermod -aG docker $USER
  echo "User added to the Docker group and restarting Docker"
  sudo systemctl restart docker
fi
# Check if the "test_car" image exists
if docker images -q test_car >/dev/null 2>&1 ; then
    echo "The 'test_car' image exists, launching with lidar at /dev/ttyUSB0 and camera at /dev/video0"
else
    echo "The 'test_car' image does not exist, creating it"
    ~/jetcar/build.sh
fi

docker run -it --rm --device=/dev/ttyUSB0:/dev/ttyUSB0 --device=/dev/video0:/dev/video0 -p 8888:8888 -p 5000:5000 -v ~jetcar/notebooks:/root/notebooks test_car