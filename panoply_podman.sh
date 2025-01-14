#!/bin/bash
# By MB
# This script is just a wrapper to run the Panoply container with podman
CONTAINER_NAME=nasa-panoply

if podman images | grep $CONTAINER_NAME; then
    # XAUTHORITY is needed to run the container with the user's X11 session
    # --userns keep-id is needed to run the container with the user's UID
    # --net=host is needed to run the container with the user's network (xauth is a network protocol)
    # -v $HOME:$HOME is needed to mount the user's home directory in the container
    podman run -it -v $XAUTHORITY:$HOME/.Xauthority -v $HOME:$HOME --userns keep-id -e DISPLAY --net=host ${CONTAINER_NAME}:5.5.5
else
    podman build -t ${CONTAINER_NAME}:5.5.5 -f Dockerfile .
    podman run -it -v $XAUTHORITY:$HOME/.Xauthority -v $HOME:$HOME --userns keep-id -e DISPLAY --net=host ${CONTAINER_NAME}:5.5.5
fi
