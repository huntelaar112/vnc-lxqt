docker hub: mannk98/container-vnc-lxde

Manual Build:
--
    git clone https://github.com/huntelaar112/container-vnc.git
    cd container-vnc
    ./build.sh

Run:
--
    docker run -idt --name container-vnc --hostname container-vnc -p 5900:5900 -p 5800:5800 -e passwd="your-pass-4-vnc" mannk98/container-vnc-lxde
