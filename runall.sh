#!/usr/bin/env bash

#check your ports are free
#sudo lsof -i tcp:8080

docker run -p 8080:8080  -v `pwd`/downloads:/var/jenkins_home/downloads \
    -v `pwd`/jobs:/var/jenkins_home/jobs/ \
    -v `pwd`/m2deps:/var/jenkins_home/.m2/repository/ --rm --name myjenkins \
    kayan/myjenkins