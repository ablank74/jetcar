# Use the specified image as a base
#1
FROM dustynv/jetson-inference:r32.7.1

# Set the working directory
#2
WORKDIR /workspace

# Install system dependencies
#3
RUN apt-get update && apt-get install -y \
    python3-pip \
    libusb-1.0-0-dev \
    libglfw3-dev \
    #libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

#4
RUN pip3 install --upgrade pip
#5
RUN pip3 install \
    scikit-build \
    numpy

# Install Python dependencies
#6
RUN pip3 install \
    jupyter \
    jupyterlab

#7
RUN apt-get update && apt-get install -y \
    ninja-build \
    python3-matplotlib

#8
RUN apt-get update && apt-get install -y python3-opencv

#9
RUN apt-get update && apt-get install -y \
    python3-smbus \
    i2c-tools

#10
RUN pip3 install \
    adafruit-circuitpython-pca9685

#11
RUN export PATH="/opt/ros/noetic/bin/roscore:$PATH" 

#12
RUN pip3 install \
    rplidar-roboticia

# Copy the Jupyter configuration file
#12
COPY jupyter_notebook_config.py /root/.jupyter/

# Expose Jupyter port
#13
EXPOSE 8888
EXPOSE 5000

# Define the command to run Jupyter Notebook
#14
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
