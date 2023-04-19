#FROM ubuntu:20.04
FROM quay.io/pypa/manylinux2014_x86_64
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
ARG username=ubuntu
ARG password=ubuntu
#RUN apt-get update &&\
#    apt-get -y install \
#    build-essential \
#    libcairo2-dev \
#    libgsl-dev \
#    libgtk-3-dev \
#    automake \
#    libtool \
#    curl \
#    swig3.0 \
#    python3 \
#    python3-dev \
#    python3-pip \
#    python3.8-venv

RUN yum -y install \
    cairo-devel \
    gsl-devel \
    gtk3-devel


#RUN python3 -m pip install -U wheel setuptools

#RUN adduser $username && \
#    chpasswd <<<"$username:$password" &&   usermod -aG sudo ubuntu &&   su - ubuntu && \
#    cd ~/

RUN mkdir /home/ubuntu && cd /home/ubuntu

COPY libibsimu-1.0.6dev_e8500a2.tar.gz .

COPY stlfile.hpp.patch .

RUN tar zxvf libibsimu-1.0.6dev_e8500a2.tar.gz &&\
    cd libibsimu-1.0.6dev_e8500a2 &&\
    patch src/stlfile.hpp < ../stlfile.hpp.patch &&\
    ./configure --prefix=/home/ubuntu &&\
    make -j 4 &&\
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/atlas make check &&\ 
    make install 

#COPY --chown=$username . /home/$username/

COPY . /home/ubuntu/

COPY vscode/* /.vscode/