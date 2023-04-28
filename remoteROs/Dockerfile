FROM dustynv/ros:noetic-ros-base-l4t-r32.7.1

ENV ROS_PYTHON_VERSION=3


ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libopencv-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y lsb-release curl && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3-smbus i2c-tools adafruit-circuitpython-pca9685

RUN mkdir -p /root/catkin_ws/src
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && cd /root/catkin_ws && catkin_make"

# Install Jetson.GPIO
RUN pip3 install Jetson.GPIO

# Install Packaging
RUN pip3 install packaging
RUN pip3 install --upgrade pip

RUN apt-get update &&  apt-get install -y libffi-dev
RUN pip3 install markupsafe


# Clone and build RPLidar ROS package
# Set up environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

#Install jupyter notebook
RUN pip3 install jupyter

#Install matplotlib prerequesites
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg-dev libpng-dev

# Install necessary python packages
RUN pip3 install numpy matplotlib

# Expose jupyter notebook port
EXPOSE 8888

# Set entrypoint to jupyter notebook
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''"]
