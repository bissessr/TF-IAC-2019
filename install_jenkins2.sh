#!/bin/bash
sudo yum update -y
# install percona mysql client
sudo yum install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm -y
sudo sed 's/^gpgcheck.*/gpgcheck=0/g' -i /etc/yum.repos.d/percona-release.repo
sudo yum install Percona-Server-client-55 -y

# install oracle jdk 1.8
cd /usr/src
  sudo yum install -y wget
  sudo wget -c --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.rpm"
  sudo yum localinstall jdk-8u73-linux-x64.rpm -y
cd -

# install jenkins and its requirements
sudo cat <<FILE > /etc/yum.repos.d/jenkins.repo
[jenkins]
name=Jenkins
baseurl=http://pkg.jenkins-ci.org/redhat
gpgcheck=0
FILE
sudo yum install -y git docker telnet jenkins

# install maven
if [[ ! -d /opt/apache-maven-3.1.1 ]];then
  cd /usr/src
    wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
    tar -xvzf apache-maven-3.1.1-bin.tar.gz
    mv apache-maven-3.1.1 /opt/
  cd -
fi

# change Jenkins default user and port
sudo sed "s/^JENKINS_USER=.*/JENKINS_USER=\"root\"/g" -i /etc/sysconfig/jenkins
sudo sed "s/^JENKINS_PORT=.*/JENKINS_PORT=\"8000\"/g" -i /etc/sysconfig/jenkins
sudo sudo service docker restart
service jenkins restart

