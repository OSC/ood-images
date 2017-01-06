# Setup

    git clone https://github.com/treydock/ood-images.git
    cd ood-images

## Docker

Launch the container:

     docker run -p 8080:80 -d treydock/ood

## Vagrant

Launch and setup the VM:

    vagrant up

# Usage

Once the VM or container is online, the Open OnDemand interface can be accessed at localhost:8080

# Development

## Docker

    docker build -t treydock/ood:0.1.0 -t treydock/ood:latest .

## packer

Build image using packer

    packer build packer.json

Debugging

    PACKER_LOG=1 packer build -debug -on-error=ask packer.json

## Vagrant

