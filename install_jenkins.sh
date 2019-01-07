#!/bin/sh
# Install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
newgrp docker
# Install Jenkins
# Instructions available : https://medium.com/@itsmattburgess/installing-jenkins-on-amazon-linux-16aaa02c369c
sudo yum -y update
sudo yum install java-1.8.0 -y
sudo yum remove java-1.7.0-openjdk -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo 
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key 
sudo yum install jenkins -y
sudo service jenkins start
sudo chkconfig --add jenkins

# install maven
if [[ ! -d /opt/apache-maven-3.1.1 ]];then
  cd /usr/src
    sudo wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
    sudo tar -xvzf apache-maven-3.1.1-bin.tar.gz
    sudo mv apache-maven-3.1.1 /opt/
  cd -
fi



