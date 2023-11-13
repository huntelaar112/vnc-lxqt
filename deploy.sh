#!/bin/bash

docker network create -o "com.docker.network.bridge.name"=ocrnetwork --subnet=172.172.0.0/16 ocrnetwork
docker rm -f manpc
docker run -idt --name manpc --hostname manpc --network ocrnetwork --ip 172.172.0.101 -p 8083:5900 -e vncpasswd="hanoi123" mannk98/vnc-lxqt
