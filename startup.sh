#!/bin/bash

HOME='/home/mannk'

# vncpasswd form docker run -e
sudo mkdir /var/run/sshd

[[ ! -f ${HOME}/.vnc/passwd ]] && {
  sudo mkdir ${HOME}/.vnc
  sudo x11vnc -storepasswd ${vncpasswd} ${HOME}/.vnc/passwd
}

sudo supervisord -c ${HOME}/supervisord.conf

while [ 1 ]; do
    /bin/bash
done
