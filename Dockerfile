FROM ubuntu:18.04
ARG user
ARG uid
ARG repo

USER root

VOLUME /data

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
    bash eatmydata \
    git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev \
    gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev \
    libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip \
    openjdk-8-jdk-headless m4 bc rsync python \
    && apt-get purge -y --auto-remove \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* \
    && useradd -l -s /bin/bash -d /data -U -u "${uid:-1000}" "${user:-aosp}"

COPY ${repo:-repo} /usr/bin/repo

WORKDIR /data

USER ${uid:-1000}

CMD ["/bin/bash"]
