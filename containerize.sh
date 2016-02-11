#!/bin/bash

BASE=/root/containers
cd $BASE
. output.sh

# Make a ~50MB root
info "Making root volume..."
dd if=/dev/zero of=container-root.xfs bs=1024 count=50000
mkfs.xfs container-root.xfs
mkdir -p container_root

# Mount it
info "Mounting root volume..."
mount -o loop $BASE/container-root.xfs container_root/

# Copy the busybox root image into the volume
info "Extracting tarball into root..."
tar --strip-components=1 -C container_root -xf busybox_root.tar

# Start a busybox shell in some new namespaces!
# `unshare` from the `util-linux` package not good enough on 14.04
info "Entering container..."
./ns_child_exec -i -m -p $BASE/containerize-2.sh

# Clean up!
info "Cleaning up..."
sleep 0.5 # There is a race with the VFS here
umount container_root/proc > /dev/null 2>&1
umount container_root
rm container-root.xfs
