#!/usr/bin/env bash
# By MB
# This script is just a wrapper to run the Panoply container with podman
CONTAINER_NAME=
# Create X11 authentication information
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

# Make sure there is at least one argument
ARGS="$HOME"
if [ $# -ne 0 ]; then
	ARGS="$@"
fi

if podman image exists nasa-panoply:latest; then
    # XAUTHORITY is needed to run the container with the user's X11 session
    # --userns keep-id is needed to run the container with the user's UID
    # --net=host is needed to run the container with the user's network (xauth is a network protocol)
    # -v $HOME:$HOME is needed to mount the user's home directory in the container
    podman run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /tmp/.docker.xauth:/tmp/.docker.xauth \
        -e XAUTHORITY=/tmp/.docker.xauth \
        -v $HOME:$HOME \
        --user=$(id -u):$(id -g) --ipc=host --userns keep-id \
        -e DISPLAY \
        --net=host nasa-panoply:latest \
        $ARGS
else
    # If the image does not exist, build it first
    VERSION=$(curl -s https://www.giss.nasa.gov/tools/panoply/download/ | grep -Eo 'PanoplyJ-.*.zip' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    echo "Building Panoply version $VERSION"
    podman build -t nasa-panoply:latest -f Dockerfile --build-arg VERSION=$VERSION . \
    && podman image exists nasa-panoply:latest \
    && podman run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /tmp/.docker.xauth:/tmp/.docker.xauth \
        -e XAUTHORITY=/tmp/.docker.xauth \
        -v $HOME:$HOME \
        --user=$(id -u):$(id -g) --ipc=host --userns keep-id \
        -e DISPLAY \
        --net=host nasa-panoply:latest \
        $ARGS
fi
