#!/bin/sh
sudo mount "$1"2 mnt &&\
sudo dd if=/dev/zero of=mnt/swap bs=1M count=128 &&\
sudo mkswap mnt/swap &&\
sudo cp mnt/etc/fstab fstab &&\
sudo chmod 777 fstab &&\
sudo echo "/swap swap swap defaults 0 0" >> fstab &&\
sudo cp fstab mnt/etc/fstab &&\
sudo umount "$1"2 &&\
sync &&\
echo "###write swap ok!"
sudo umount mnt >/dev/null 2>&1

