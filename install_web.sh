#!/bin/sh
sudo yum update -y
# install Java
sudo yum install java-1.8.0
# change to tomcat directory
cd /opt
sudo wget http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.14/src/apache-tomcat-9.0.14-src.tar.gz
sudo tar -xvzf /opt/apache-tomcat-9.0.14-src.tar.gz

# set permissions to startup.sh and shutdown.sh
sudo chmod +x /opt/apache-tomcat-9.0.14-src/bin/startup.sh shutdown.sh

# create link files for tomcat startup.sh and shutdown.sh
sudo ln -s /opt/apache-tomcat-9.0.14-src/bin/startup.sh /usr/local/bin/tomcatup
sudo ln -s /opt/apache-tomcat-9.0.14-src/bin/shutdown.sh /usr/local/bin/tomcatdown
sudo tomcatup
