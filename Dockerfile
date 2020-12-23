# Kudos to DOROWU for his amazing VNC 16.04 KDE image
FROM dorowu/ubuntu-desktop-lxde-vnc:xenial
LABEL maintainer "ahmet.kabaoglu@gmail.com"

ENV CATKIN_WS /root/catkin_ws

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full \
		wget git nano
RUN rosdep init && rosdep update

# Update Gazebo 7
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update && apt-get install -y gazebo7 libignition-math2-dev

RUN apt-get install -y ros-kinetic-gazebo-ros-control 
RUN apt-get install -y ros-kinetic-ros-controllers
RUN apt update && apt-get install -y ros-kinetic-hector-*
RUN apt update && apt-get install -y ros-kinetic-ardrone-autonomy

WORKDIR ${CATKIN_WS}
RUN mkdir -p src

RUN /bin/bash -c "echo 'source /opt/ros/kinetic/setup.bash' >> /root/.bashrc && \
					echo 'source ${CATKIN_WS}/devel/setup.bash' >> /root/.bashrc && \
					source /root/.bashrc"

# Installing Vim Editor
RUN apt update && apt install -y vim

# Installing custom package
RUN cd src && git clone https://github.com/felixcapuano/tum_simulator.git
RUN cd src && git clone https://github.com/felixcapuano/ardrone-facetracker.git
RUN chmod 777 src/ardrone-facetracker/scripts/*

RUN sudo apt-get update && sudo apt-get -y upgrade
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd ${CATKIN_WS}; catkin_make'
COPY ./models/* /root/.gazebo/models/
