# Open OnDemand Images

This repo contains images in various technologies of the Open OnDemand platform

1. containers in [docker](docker/) and [podman](podman/)
2. vagrant image in [vagrant](vagrant/)
3. vagrant image in [vagrant-el8-with-slurm](vagrant-el8-with-slurm/) that contains a full Open OnDemand and SLURM environment  (CentOS 8)
4. vagrant image in [vagrant-with-gridengine](vagrant-with-gridengine/) that contains a full Open OnDemand and Grid Engine environment (CentOS 7)
5. vagrant image in [vagrant-with-lsf](vagrant-with-lsf/) that contains a full Open OnDemand and LSF environment (CentOS 7)
6. vagrant image in [vagrant-with-pbspro](vagrant-with-pbspro/) that contains a full Open OnDemand and PSBPro environment (CentOS 7)
7. vagrant image in [vagrant-with-slurm](vagrant-with-slurm/) that contains a full Open OnDemand and SLURM environment (CentOS 7)
8. fully fledged Virtual Machines in the [vm](vm) directory

# Setup

    git clone https://github.com/OSC/ood-images.git
    cd ood-images
    vagrant plugin install vagrant-vbguest  # only required once, and is not tied to a particular Vagrant file / directory
