FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
ARG username=ubuntu
ARG password=ubuntu
RUN apt-get update &&\
    apt-get -y install \
    build-essential \
    libcairo2-dev \
    libgsl-dev \
    libgtk-3-dev \
    automake \
    libtool \
    curl

RUN adduser --gecos "" --disabled-password $username && \
    chpasswd <<<"$username:$password" &&   usermod -aG sudo ubuntu &&   su - ubuntu && \
    cd ~/

COPY libibsimu-1.0.6dev_9cbf04.tar.gz .

RUN tar zxvf libibsimu-1.0.6dev_9cbf04.tar.gz &&\
    cd libibsimu-1.0.6dev_9cbf04 &&\
    ./configure --prefix=/home/ubuntu &&\
    make &&\
    make check &&\ 
    make install 

COPY --chown=$username . /home/$username/

COPY vscode/* /.vscode/