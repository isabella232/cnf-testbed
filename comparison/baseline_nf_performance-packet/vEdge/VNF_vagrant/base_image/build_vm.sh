#! /bin/bash

input="$1"

if [ "$input" == "clean" ]; then
  vagrant destroy -f
  vagrant box remove vedge
  virsh vol-delete vedge_vagrant_box_image_0.img --pool default
  virsh undefine vedge_vagrant_box_image_0
  virsh pool-refresh default
  rm -f vedge.box
  exit 0
fi

SUDO=$(which sudo)

if [ -z "$(which virt-sysprep)" ] ; then
  $SUDO apt-get --no-install-recommends install -y apt-utils ca-certificates libguestfs-tools
fi

# Build the VM with vagrant
vagrant up vedge
vagrant reload

# After it completes, shutdown the vm without destroying the vagrant image
vagrant halt vedge

# Create a vagrant box from the VM
vagrant package --output vedge.box vedge
vagrant box add vedge.box --name vedge
