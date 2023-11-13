#!/bin/bash

# vncpasswd form docker run -e
# mkdir /var/run/sshd

HOME='/home/mannk'

[[ ! -f ${HOME}/.vnc/passwd ]] && {
  mkdir ${HOME}/.vnc
  x11vnc -storepasswd ${vncpasswd} ${HOME}/.vnc/passwd
}

sudo supervisord -c ${HOME}/supervisord.conf

while [ 1 ]; do
    /bin/bash
done
