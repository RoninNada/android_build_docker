FROM ubuntu:22.04
ARG userid
ARG groupid
ARG username

RUN apt update && apt install -y apt-utils

# Ubuntu 22.04 will not build without at least attempting to set tzdata
RUN apt install -y tzdata

RUN apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git \
git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool \
libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
xsltproc zip zlib1g-dev

# For ubuntu versions < 23.10 & > 20.04
RUN apt install -y lib32ncurses5-dev libncurses5 libncurses5-dev

# LineageOS 17.1+: Python 3
RUN apt install -y python-is-python3

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username \
 && echo "export USER="$username >>/home/$username/.gitconfig
COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig
ENV HOME=/home/$username
ENV USER=$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
