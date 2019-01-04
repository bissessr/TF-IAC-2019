#!/bin/sh
# Install Docker
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user

# Install Jenkins
# Instructions available : https://medium.com/@itsmattburgess/installing-jenkins-on-amazon-linux-16aaa02c369c

sudo yum -y update
sudo yum install java-1.8.0
sudo yum remove java-1.7.0-openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins
sudo service jenkins start
sudo chkconfig --add jenkins

