docker run -it --rm --device=/dev/ttyUSB0:/dev/ttyUSB0 --device=/dev/video0:/dev/video0 -p 8888:8888 -v /home/jetson/jetcar/test/notebooks:/root/notebooks test_car
#