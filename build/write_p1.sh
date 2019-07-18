#!/bin/sh
if [ "$_KERNEL_TYPE" = main ] ; then
sudo mount "$1"1 mnt &&\
sudo cp $_KERNEL_FILE mnt/zImage &&\
sudo cp $_DTB_FILE mnt/ &&\
sudo cp $_TOP_DIR/build/boot.scr mnt/boot.scr &&\
sync &&\
sudo umount "$1"1 &&\
echo "###write partion 1 ok!"
sudo umount mnt >/dev/null 2>&1
echo ""

fi
