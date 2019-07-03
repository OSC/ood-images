# Podman and Buildah OOD image creation

If you use RedHat's [podman](https://podman.io/) and [buildah](https://buildah.io/) stack then
you've come to the right place for creating contianers for your development environment. 


## Building an image
There are two shell scripts for building images. 

First run `make-ood-base-img.sh` and it will build, tag and commit `ood-base:latest` and this thing is 
big (like 1.2 GB big), so we seperated it out from configuration and what not because it builds very slowly. 
Run this shell and you'll have a base image to work off of.

Now you can run and hack `make-personal-img.sh` to make a personal image all for yourself. That is, if you 
want to add some files or reconfigure the `env` file, go for it! It's your image!


## Running the image

You'll need to specify the environment variable `OOD_APP_DEV_DIR`. This is the location on your filesystem where
your apps either are or will be on your host machine. This directory is going to be mounted in the container so that you can 
modify *your* actual files while still running OnDemand in a container. You'll want to put it into your `.bashrc` like
`export OOD_APP_DEV_DIR="<changme to an actual directory>"`. 

The helper script `ood-container` is provided for convienence. Execute this script and launch your container!

Note that in the building of the personal image, we created a user from the environment variable **$USER**. This
is the user you'll use to login to OnDemand and the password is also **$USER**.

### Extras

You may notice in the start script you can also load an extras file if you have `$HOME/.local/etc/ood-container.config`. 
This is for extra options you want to give, say extra stuff you want to mount to the container. 

Here's an example of my extras file. You'll see I mount the ruby gems directory (so I don't have multiple ruby 
envrionments) and I also mount other directories I may be working on that don't *need* to an Open OnDemand binary,
but, as with the ruby bit, I want to develop files against a single ruby installation. 

```sh
#!/bin/sh

GEMS="-v $HOME/.gem:$HOME/.gem"
OSC_CFG="-v $HOME/source/ood/osc-ood-config:$HOME/osc-ood-config"

EXTRA_ARGS="$GEMS $OSC_CFG"
```
