# Podman and Buildah OOD image creation

If you use RedHat's [podman](https://podman.io/) and [buildah](https://buildah.io/) stack then
you've come to the right place for creating contianers for your Open OnDemand development environment. 

# Image creation scripts

## Base Image
`make-ood-base-img.sh` will build, tag and commit `ood-base:latest` and this thing is
big (like 1.2 GB big), so we seperated it out from configuration and what not because it builds very slowly.
Run this shell and you'll have a base image to work off of.

This image has Open OnDemand (ood for short) installed in it, and that's really why it's so large.

## Personal Image
Now you can run and hack `make-personal-img.sh` to make a personal image all for yourself. That is, if you 
want to add some files or reconfigure the `env` file, go for it! It's your image!

This image starts from `ood-base:latest` what you created above and does things like adds yourself as a 
user and ensures that user has root privileges and so on. The real advantage to using podman is the flag
`--userns=keep-id` which maps your UID to the container. So, if you're UID 1000 on your host, you'll be 
UID 1000 inside this container as well.  Which means, you'll be able modify your files on your host and they'll
have no problem being used in the container!

This image is meant to be used when you want an Open OnDemand installation present and you want to hack
away on it or develop applications against it.


## Dev Image

If you're running `make-dev-img.sh`, congratulations, you're an OOD power user! This shell will make and 
tag an `ood-dev:latest` image for developmental purposes.  It does not install Open OnDemand, instead 
it installs all the things nessecary to *build* Open OnDemand! This image is what some maintainers use as their 
development environment so they don't have to install things like ruby or rpm-build on their host.

# Running the containers
The helper script `ood-container` is provided for convienence.

You'll need to specify the environment variable `OOD_APP_DEV_DIR`. This is the location on your filesystem where
your apps either are or will be on your host machine. This directory is going to be mounted in the container so that you can 
modify *your* actual files while still running OnDemand in a container. You'll want to put it into your `.bashrc` like
`export OOD_APP_DEV_DIR="<changme to an actual directory>"`. 

Note that in the building of the personal image, we created a user from the environment variable **$USER**. This
is the user you'll use to login to OnDemand and the password is also **$USER**.

If you want to run the development (`ood-dev`) container instead of `ood-$USER`, simply pass in the -d or --dev 
argument to the script. 

### APP Dev Dir

A note about application development should be stated here because it doesn't seem to be that intuitive. OnDemand 
can be configured in such a way as to give a user their own personal application development directory. How this works
in this container is as follows.

Your host directory is mounted to this location in the container. 
```sh
-v $OOD_APP_DEV_DIR:$HOME/ondemand/dev
```

Then when the container launches, it creates the app dev directory and symlinks it to this mounted directory.
```sh
APP_DEV_DIR="$HOME/ondemand/dev"
OOD_DEV_DIR="/var/www/ood/apps/dev/$USER"

sudo su root <<MKDEV
  mkdir -p $OOD_DEV_DIR 
  cd $OOD_DEV_DIR
  ln -s $APP_DEV_DIR gateway
MKDEV
```
By convention OnDemand knows that this is a development location for that user and will now show that user a 
'develop' dropdown menu.


### Extras

You may notice in the start script you can also load an extras file if you have `$HOME/.local/etc/ood-container.config`. 
This is for extra options you want to give, say extra stuff you want to mount to the container. 

Here's an example of my extras file. You'll see I mount the ruby gems directory (so I don't have multiple ruby 
envrionments) and I also mount other directories I may be working on that don't *need* to an Open OnDemand binary,
but, as with the ruby bit, I want to develop files against a single ruby installation. I even mount a different
.bashrc because I want to add some of the gems to my $PATH.

```sh
#!/bin/sh

# keep gems on my host
GEMS="-v $HOME/.gem:$HOME/.gem"

# another project I want to work on in the container
OSC_CFG="-v $HOME/source/ood/osc-ood-config:$HOME/osc-ood-config"

# use a special bashrc file
BASH="-v $HOME/.local/etc/ood-container.bashrc:$HOME/.bashrc"

EXTRA_ARGS="$GEMS $OSC_CFG $BASH"
```
