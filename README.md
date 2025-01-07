# Panoply Container

The idea is to run [NASA's Panoply](https://www.giss.nasa.gov/tools/panoply/) in a container.

It is possible to run X11 apps inside a container, especially in podman.

```sh
# clone the repo
git clone https://github.com/MBlaschek/panoply-container.git

# build the container
cd panoply-container
podman build -t nasa-panoply:5.5.5 -f Dockerfile .

# install helpers

# create local directories if needed.
mkdir -p $HOME/.local/bin $HOME/.local/share/icons $HOME/.local/share/applications
# copy runscript
cp panoply-container/panoply-logo-small.png $HOME/.local/share/icons/
cp panoply-container/panoply_podman.sh $HOME/.local/bin/
chmod +x $HOME/.local/bin/panoply_podman.sh
# update the desktop files
update-desktop-database $HOME/.local/share/applications/
# now there should be an association with NetCDF files
```

Enjoy.

## Converting to an Apptainer

It is possible to convert the podman/docker image to an apptainer format.

```sh
# convert to a local file
podman push localhost/nasa-panoply:5.5.5 oci-archive:/tmp/nasa-panoply.tar
Getting image source signatures
Copying blob 92a4e8a3140f done   |
Copying blob eafe6e032dbd done   |
Copying blob e3abdc2e9252 done   |
Copying blob eb6ee5b9581f done   |
Copying blob af55d45e0e6e done   |
Copying blob d5ec59a0a6fd done   |
Copying config 6e319cd212 done   |
Writing manifest to image destination

# convert the image
apptainer build nasa-panoply.sif oci-archive:/tmp/nasa-panoply.tar
WARNING: 'nodev' mount option set on /tmp, it could be a source of failure during build process
INFO:    Starting build...
Copying blob bff869591f85 done   |
Copying blob e5b29faca6d4 done   |
Copying blob 758812ab6aa3 done   |
Copying blob 4d91a651af38 done   |
Copying blob da253ad7b46d done   |
Copying blob 00be24e4ee34 done   |
Copying config 6e319cd212 done   |
Writing manifest to image destination
2025/01/07 23:22:17  info unpack layer: sha256:bff869591f856c07fbbd580257567d3bb1fa7580a0c50b4c79b61598ce055135
2025/01/07 23:22:18  info unpack layer: sha256:e5b29faca6d4476fb7f59936061103ee6c0100a97445e9c9dce9e136da74a6ef
2025/01/07 23:22:18  info unpack layer: sha256:758812ab6aa3a867e97e1980b91c3a24a7a13720815cc5c891b72294e96daee1
2025/01/07 23:22:18  info unpack layer: sha256:4d91a651af38053dcfe739d33071275e5ffda2bd6a5f2e9b6ccee14c65ec5654
2025/01/07 23:22:20  info unpack layer: sha256:da253ad7b46dc5e0ba2605aaaeccf4e67d5dde3a47c9ae4d76fba693ae76410b
2025/01/07 23:22:21  info unpack layer: sha256:00be24e4ee3472ffe6b8759bd5915685e08399bc99d3c164200ebe465a1a5284
INFO:    Creating SIF file...
INFO:    Build complete: nasa-panoply.sif

# it is necessary to bind the XAUTHORITY into the container
apptainer run -B $XAUTHORITY nasa-panoply.sif
```
