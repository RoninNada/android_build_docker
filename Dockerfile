FROM ubuntu:14.04
ARG userid
ARG groupid
ARG username

RUN apt-get update && apt-get install -y bc bison build-essential ccache curl flex \
g++-multilib gcc-multilib git git-core gnupg gperf imagemagick lib32ncurses5-dev \
lib32readline-dev lib32z-dev lib32z1-dev libc6-dev-i386 liblz4-tool libgl1-mesa-dev \
libncurses5 libncurses5-dev lib32ncurses5-dev libsdl1.2-dev libssl-dev libx11-dev \
libxml2 libxml2-utils libwxgtk2.8-dev lzop make pngcrush python python3 rsync schedtool \
squashfs-tools unzip x11proto-core-dev xsltproc zip

RUN mkdir /usr/lib/jvm/

RUN curl -o jdk8.tgz https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
 && tar -zxf jdk8.tgz linux-x86 \
 && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
 && rm -rf jdk8.tgz

# RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
#  && echo "e147f0392686c40cfd7d5e6f332c6ee74c4eab4d24e2694b3b0a0c037bf51dc5  /usr/local/bin/repo" | sha256sum --strict -c - \
#  && chmod a+x /usr/local/bin/repo

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username \
 && echo "export USER="$username >>/home/$username/.gitconfig
COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig
ENV HOME=/home/$username
ENV USER=$username

RUN echo 'export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"' >> /home/$username/.bashrc

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
