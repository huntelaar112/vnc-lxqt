#!/bin/bash

HOME='/home/mannk'

# vncpasswd form docker run -e
sudo mkdir /var/run/sshd

[[ ! -f /root/.vnc/passwd ]] && {
  sudo mkdir /root/.vnc
  sudo x11vnc -storepasswd ${vncpasswd} /root/.vnc/passwd
}

sudo supervisord -c ${HOME}/supervisord.conf

while [ 1 ]; do
    /bin/bash
done
