#!/bin/bash

BASE=/root/containers

cd $BASE

# Make a 100MB root
dd if=/dev/zero of=container-root.xfs bs=1024 count=100000
mkfs.xfs container-root.xfs
mkdir -p container_root

# Mount it
mount -o loop $BASE/container-root.xfs container_root/

# Copy the busybox root image into the volume
tar --strip-components=1 -C container_root -xf busybox_root.tar

# Start a busybox shell in some new namespaces!
./ns_child_exec -i -m -p $BASE/containerize-2.sh

# Clean up!
sleep 0.5 # There is a race with the VFS here
umount container_root/proc > /dev/null 2>&1
umount container_root
rm container-root.xfs
