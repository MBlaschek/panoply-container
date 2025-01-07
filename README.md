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