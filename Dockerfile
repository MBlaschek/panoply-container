#
# NASA Panoply 5.5.5 or later
# available: https://www.giss.nasa.gov/tools/panoply/
#
FROM docker.io/library/openjdk:11-slim-bullseye
MAINTAINER Michael Blaschek, michael.blaschek@univie.ac.at
# install xserver extensions and some other dependencies
ARG VERSION=5.7.1
# override version at build time: --build-arg VERSION=5.6.2
ENV VERSION=${VERSION:-5.7.1}
ENV DEBIAN_FRONTEND='noninteractive'
RUN apt update && apt install -y x11-xserver-utils libxtst6 curl libfreetype6 fontconfig unzip && apt clean -y && rm -rf /var/lib/apt/lists/*
# RUN apt update && apt-get install -y x11vnc xvfb curl && apt clean -y && rm -rf /var/lib/apt/lists/*
# Copy all sources if available local
# COPY . /app
WORKDIR /app
# Download the zip and extract
# https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-5.6.2.zip
# https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-5.7.1.zip
RUN curl -s -L -o /app/panoply.zip https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-${VERSION}.zip && unzip panoply.zip && rm /app/panoply.zip
# Entrypoint
ENTRYPOINT ["sh", "/app/PanoplyJ/panoply.sh"]
CMD [""]
