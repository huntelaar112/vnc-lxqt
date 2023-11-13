FROM debian:12.2

LABEL maintainer="khacman98@gmail.com" \
      io.k8s.description="Headless VNC Container with LXQt Desktop manager" \
      io.k8s.display-name="Headless VNC Container based on Debian" \
      io.openshift.expose-services="5900:xvnc" \
      io.openshift.tags="vnc, debian, lxqt" \
      io.openshift.non-scalable=true

ENV DEBIAN_FRONTEND noninteractive
#ENV HOME /root
ENV USER mannk
ENV HOME=/home/mannk
ENV bashScript="https://github.com/huntelaar112/bash-script.sh.git"

#keep, not update
#RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/init && ln -sf /bin/true /sbin/init

#RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
RUN /bin/bash && echo 'deb http://deb.debian.org/debian/ bookworm main non-free-firmware \
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware \
deb http://security.debian.org/debian-security bookworm-security main non-free-firmware \
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware \
deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware \
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware' > /etc/apt/sources.list

#--no-install-recommends
#RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#      --mount=type=cache,target=/var/lib/apt,sharing=locked \
#    \
RUN    apt update && apt upgrade -y && apt dist-upgrade -y \
    && apt-get install -y supervisor \
    xdg-utils dbus-x11 x11-utils \
    \
    gnupg2 bmon openssh-server sudo net-tools curl netcat-openbsd wget \
    openbox obconf-qt lxqt pcmanfm-qt x11vnc xvfb screen \
    chromium libreoffice fonts-wqy-microhei geany \
    gzip htop nano lxterminal iproute2 ibus git ca-certificates\
    \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

#    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
#    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
#    libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
#    fonts-liberation libappindicator1 libnss3 lsb-release

# lxde-core lxde-icon-theme
# install gg chrome
#RUN curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null \
#    && echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list \
#    && apt update &&  apt install google-chrome-stable -y

#install firefox nightly
#RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/packages.mozilla.org.gpg > /dev/null \
#    && gpg --quiet --no-default-keyring --keyring /etc/apt/trusted.gpg.d/packages.mozilla.org.gpg --fingerprint | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}' \
#    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null \
#    && apt update && apt install firefox-nightly

#RUN git clone ${bashScript} && cd bash-script.sh && ./ \
#    && cd bash-script.sh \
#    && bash ./install.sh

RUN /bin/dbus-uuidgen --ensure && \
        useradd ${USER} && usermod -aG sudo ${USER} \
        && 	echo ""${USER}" ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers \

RUN chown ${USER}:${USER} ${HOME}

WORKDIR ${HOME}
USER mannk

RUN mkdir -p ${HOME}/.config/lxqt && \
        echo '[General]' >> ${HOME}/.config/lxqt/lxqt.conf && \
        echo 'theme=KDE-Plasma' >> ${HOME}/.config/lxqt/lxqt.conf \
        && \
        echo 'Xcursor.theme: breeze_cursors' >> ${HOME}/.Xdefaults \
        && \
        mkdir -p ${HOME}/.config/pcmanfm-qt/lxqt && \
        echo '[Desktop]' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
        echo 'Wallpaper=/usr/share/lxqt/wallpapers/kde-plasma.png' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
        echo 'WallpaperMode=stretch' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf \
        && \
        mkdir -p ${HOME}/.config/lxqt/ && \
        echo '[quicklaunch]' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\1\desktop=/usr/share/applications/qterminal.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\2\desktop=/usr/share/applications/pcmanfm-qt.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\size=3' >> ${HOME}/.config/lxqt/panel.conf \

ADD --chown=${USER}:${USER} supervisord.conf ./
ADD --chown=${USER}:${USER} startup.sh ./

EXPOSE 5800
EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["/home/mannk/startup.sh"]
