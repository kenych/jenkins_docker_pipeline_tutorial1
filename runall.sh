#!/usr/bin/env bash

#check your ports are free
#sudo lsof -i tcp:8080 &&  sudo lsof -i tcp:9001

jenkins_port=8080
sonar_port=9001

docker pull jenkins:2.60.3
docker pull sonarqube:6.3.1

if [ ! -d downloads ]; then
    mkdir downloads
    curl -o downloads/jdk-8u144-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u144-linux-x64.tar.gz
    curl -o downloads/jdk-7u80-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz
    ##curl -o downloads/apache-maven-3.5.2-bin.tar.gz http://mirror.vorboss.net/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
    curl -o downloads/apache-maven-3.6.1-bin.tar.gz http://apache.mirror.anlx.net/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
fi

docker stop mysonar myjenkins

docker build --no-cache  -t myjenkins .


docker run  -p ${sonar_port}:9000 --rm --name mysonar sonarqube:6.3.1 &

IP=$(ifconfig en0 | awk '/ *inet /{print $2}')

echo "Host ip: ${IP}"

if [ ! -d m2deps ]; then
    mkdir m2deps
fi

docker run -p ${jenkins_port}:8080  -v `pwd`/downloads:/var/jenkins_home/downloads \
    -v `pwd`/jobs:/var/jenkins_home/jobs/ \
    -v `pwd`/m2deps:/var/jenkins_home/.m2/repository/ --rm --name myjenkins \
    -e SONARQUBE_HOST=http://${IP}:${sonar_port} \
    myjenkins:latest
