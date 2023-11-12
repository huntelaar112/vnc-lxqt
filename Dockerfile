FROM debian:12.2
MAINTAINER mannk98 <khacman98@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

WORKDIR /
#keep, not update
#RUN apt-mark hold initscripts udev plymouth mountall
#
RUN dpkg-divert --local --rename --add /sbin/init && ln -sf /bin/true /sbin/init

#RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
RUN echo " \
         deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware \
         deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware \
         deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware \
         deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware \
         deb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware \
         " > /etc/apt/sources.list

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    \
    apt-get update && apt-get upgrade -y --force-yes && apt-get dist-upgrade -y --force-yes \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
    openbox gnupg2 bmon gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
    libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils dbus-x11 x11-utils \
    \
    openssh-server sudo net-tools curl netcat-openbsd wget \
    lxqt-core lxqt task-lxqt-desktop x11vnc xvfb screen \
    chromium libreoffice fonts-wqy-microhei geany \
    gzip htop nano lxterminal iproute2 ibus ca-certificates \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

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

ADD startup.sh /
ADD supervisord.conf /
EXPOSE 5800
EXPOSE 5900
EXPOSE 22
ENTRYPOINT ["/startup.sh"]
