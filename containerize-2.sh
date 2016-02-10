#!/bin/sh

# Set up the proc filesystem
mount -t proc proc container_root/proc

# Give us the new root
cd container_root
pivot_root `pwd` `pwd`/old_root
ls /

# Replace ourselves with a busybox shell
exec /bin/sh
