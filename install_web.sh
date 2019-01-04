#!/bin/sh
sudo yum update -y
# install Java
sudo yum install java-1.8.0
cd /opt
sudo wget http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
sudo tar -xvzf /opt/apache-tomcat-8.5.37.tar.gz
sudo mv apache-tomcat-8.5.37 tomcat8

# set permissions to startup.sh and shutdown.sh
sudo chmod +x /opt/tomcat8/bin
sudo /opt/tomcat8/bin/startup.sh

