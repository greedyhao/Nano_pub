#!/bin/sh
sudo mount "$1"2 mnt &&\
#sudo cp -R game/* mnt/usr/games/
#sudo chmod 777 -R mnt/usr/games
sudo rm -rf mnt/* &&\
sudo tar xzvf $_ROOTFS_FILE -C mnt/ &&\
# ./write_overlay.sh $1 &&\
sudo mkdir -p mnt/lib/modules/ &&\
sudo cp -r $_MOD_DIR/* mnt/lib/modules/ &&\
# ./write_swap.sh $1 &&\
sudo umount "$1"2 &&\
sync &&\
echo "###write partion 2 ok!"
sudo umount mnt >/dev/null 2>&1

