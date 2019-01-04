#!/bin/sh
sudo yum update -y
# install Java
sudo yum install java-1.8.0
# install Tools and Tomcat
sudo amazon-linux-extras install tomcat8.5

# change to Opt directory

#cd /opt
#sudo wget http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
#sudo tar -xvzf /opt/apache-tomcat-8.5.37.tar.gz
#sudo mv apache-tomcat-8.5.37 tomcat8

# set permissions to startup.sh and shutdown.sh
#sudo chmod 700 /opt/tomcat8/bin/*.sh

#start Tomcat
#sudo /opt/tomcat8/bin/startup.sh


