#
# NASA Panoply 5.5.5
# available: https://www.giss.nasa.gov/tools/panoply/
#
FROM docker.io/library/openjdk:11-slim-bullseye
MAINTAINER Michael Blaschek, michael.blaschek@univie.ac.at
# install xserver extensions and some other dependencies
ENV DEBIAN_FRONTEND='noninteractive'
RUN apt update && apt install -y x11-xserver-utils libxtst6 curl libfreetype6 fontconfig && apt clean -y && rm -rf /var/lib/apt/lists/*
# Copy all sources if available local
# COPY . /app
WORKDIR /app
# Download the tgz and extract
RUN curl -s -L -o /app/panoply.tgz https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-5.5.5.tgz && tar --strip-components=1 --no-same-owner -xvzf panoply.tgz && rm /app/panoply.tgz
# Entrypoint
CMD sh /app/panoply.sh
