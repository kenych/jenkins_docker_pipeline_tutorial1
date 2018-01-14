#!/usr/bin/env bash

#check your ports are free
#sudo lsof -i tcp:8080 

docker pull jenkins:2.60.3

if [ ! -d downloads ]; then
    mkdir downloads
    curl -o downloads/apache-maven-3.5.2-bin.tar.gz http://mirror.vorboss.net/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
fi

docker build --no-cache  -t kayan/myjenkins .

if [ ! -d m2deps ]; then
    mkdir m2deps
fi

docker run -p 8080:8080  -v `pwd`/downloads:/var/jenkins_home/downloads \
    -v `pwd`/jobs:/var/jenkins_home/jobs/ \
    -v `pwd`/m2deps:/var/jenkins_home/.m2/repository/ --rm --name myjenkins \
    kayan/myjenkins