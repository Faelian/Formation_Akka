#!/bin/sh

for i in $(seq 1 255); do
    ping -c 1 -W 1 192.168.1.$i | grep '64 bytes' &
done
