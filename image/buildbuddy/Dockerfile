FROM ubuntu:20.04
ENV TZ Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y build-essential openjdk-11-jdk rpm python2 python3 python-is-python2 unzip && \
    rm -rf /var/lib/apt/lists/*
