FROM ubuntu:18.04
ARG userid
ARG groupid
ARG username

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex \
    bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib \
    libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev \
    ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python openjdk-8-jdk

COPY repo /usr/local/bin/repo
RUN  chmod a+x /usr/local/bin/repo

RUN groupadd -g ${groupid:-1000} $username \
    && useradd -m -u ${userid:-1000} -g ${groupid:-1000} $username \
    && echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username

VOLUME /home/$username
WORKDIR /home/$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
