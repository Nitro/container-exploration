#!/bin/sh -e

# Create the namespace
ip netns add container

# Enable the loopback
ip netns exec container ip link set dev lo up

# Create the virtual ethernet pair
ip link add veth0 type veth peer name veth1

# Create the ip address on our end
ip addr add dev veth0 192.168.168.1/24
ip link set dev veth0 up

# Put one end of the pair into the container namespace
ip link set veth1 netns container
ip netns exec container ip addr add dev veth1 192.168.168.2/24
ip netns exec container ip link set dev veth1 up

exec ip netns exec container ./containerize.sh

# Clean up!
ip netns delete container
