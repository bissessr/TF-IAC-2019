#!/bin/sh
# Install Docker
yum update -y
yum install -y docker
service docker start
usermod -aG docker ec2-user

# Install Jenkins
# Instructions available : https://medium.com/@itsmattburgess/installing-jenkins-on-amazon-linux-16aaa02c369c

yum -y update
yum install java-1.8.0
yum remove java-1.7.0-openjdk
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins
service jenkins start
chkconfig --add jenkins

