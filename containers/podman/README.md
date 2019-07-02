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
your apps either are or will be. This directory is going to be mounted in the container so that you can 
modify *your* actual files while still running OnDemand in a container.

The helper script `ood-container` is provided for convienence. Execute this script and launch your container!

Note that in the building of the personal image, we created a user from the environment variable **$USER**. This
is the user you'll use to login to OnDemand and the password is also **$USER**. 
