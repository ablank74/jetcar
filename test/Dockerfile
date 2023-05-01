# Use the specified image as a base
FROM dustynv/ros:noetic-ros-base-l4t-r32.7.1

# Set the working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    libusb-1.0-0-dev \
    libglfw3-dev \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*


RUN pip3 install --upgrade pip
RUN pip3 install scikit-build

# Install Python dependencies
RUN pip3 install \
    jupyter \
    jupyterlab

RUN apt-get update && apt-get install -y ninja-build python3-matplotlib

RUN apt-get update && apt-get install -y \
    python3-opencv

RUN apt-get update && apt-get install -y python3-smbus i2c-tools
RUN pip3 install adafruit-circuitpython-pca9685

RUN export PATH="/opt/ros/noetic/bin/roscore:$PATH" 

RUN pip3 install rplidar-roboticia

# Copy the Jupyter configuration file
COPY jupyter_notebook_config.py /root/.jupyter/

# Expose Jupyter port
EXPOSE 8888

# Define the command to run Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
