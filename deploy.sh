docker rm -f manpc
docker run -idt --name manpc --hostname manpc --network ocrnetwork --ip 172.172.0.101 -e passwd="hanoi123" mannk98/docker-lxde-vnc
