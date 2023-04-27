FROM dustynv/ros:noetic-ros-base-l4t-r32.7.1
FROM nvcr.io/nvidia/l4t-ml:r32.7.1-py3
FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
FROM nvcr.io/nvidia/l4t-tensorflow:r32.7.1-tf1.15-py3

ARG ROS_PKG=ros_base
ENV ROS_DISTRO=noetic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3


ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /workspace


#Robot Interface
RUN apt-get update && \
    apt-get install -y python3-pip 
RUN pip3 install adafruit-circuitpython-pca9685
RUN pip3 install Jetson.GPIO
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install dependencies for RPILidar
RUN apt-get update && apt-get install -y \
    libboost-all-dev \
    libusb-1.0-0-dev \
    libudev-dev

#
# add the ROS deb repo to the apt sources list
#
RUN  apt-get update && apt-get install -y --no-install-recommends \
          git \
		cmake \
		build-essential \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

#
# install bootstrap dependencies
#
RUN  apt-get update && apt-get install -y --no-install-recommends \
          libpython3-dev \
          python3-rosdep \
          python3-rosinstall-generator \
          python3-vcstool \
          python3-empy \
          build-essential && \
    rosdep init && \
    rosdep update && \
    rm -rf /var/lib/apt/lists/*



#
# download/build the ROS source
#Step 17 of 35
RUN mkdir ros_catkin_ws && \
    cd ros_catkin_ws && \
    rosinstall_generator ${ROS_PKG} vision_msgs image_transport --rosdistro ${ROS_DISTRO} --deps --tar > ${ROS_DISTRO}-${ROS_PKG}.rosinstall && \
    mkdir src && \
    vcs import --input ${ROS_DISTRO}-${ROS_PKG}.rosinstall ./src && \
    apt-get update && \
    rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro ${ROS_DISTRO} --skip-keys python3-pykdl -y && \
    python3 ./src/catkin/bin/catkin_make_isolated --install --install-space ${ROS_ROOT} -DCMAKE_BUILD_TYPE=Release && \
    rm -rf /var/lib/apt/lists/*



WORKDIR /

#install base packages to reduce config time
RUN pip3 install matplotlib
RUN pip3 install pandas
RUN pip3 install cartographer
RUN pip3 install rplidar

RUN apt-get update && apt-get install -y build-essential libffi-dev python3-dev
# Install Jupyter
RUN pip3 install packaging

RUN pip3 install jupyterlab

# Expose port for Jupyter
EXPOSE 8888


# Set ROS environment variables
ENV ROS_PACKAGE_PATH /catkin_ws/src:$ROS_PACKAGE_PATH
ENV LD_LIBRARY_PATH /rplidar_ros/devel/lib:$LD_LIBRARY_PATH

# Set default command to launch RPILidar driver node
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root" "--NotebookApp.token=''"]

