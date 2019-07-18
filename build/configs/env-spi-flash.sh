#!/bin/bash
source ../env.sh
#change here to your config
export _BOOT_DEV=spi-flash
export _KERNEL_TYPE=main
# export _KERNEL_VER=4.15.0
export _KERNEL_VER=5.2.0
export _DT_NAME=suniv-f1c100s-licheepi-nano
# export _MOD_FILE=$_MOD_DIR/$_BOOT_DEV/$_KERNEL_VER-next-20180202-licheepi-nano+
export _MOD_FILE=$_MOD_DIR/$_BOOT_DEV/$_KERNEL_VER-licheepi-nano

#do not change next
export _UBOOT_FILE=$_UBOOT_DIR/u-boot-$_BOOT_DEV.bin
export _DTB_NAME=$_DT_NAME.dtb
export _DTS_NAME=$_DT_NAME.dts
export _DTS_FILE=$_DTB_DIR/$_BOOT_DEV/$_DTS_NAME
export _DTB_FILE=$_DTB_DIR/$_BOOT_DEV/$_DTB_NAME
export _KERNEL_FILE=$_KERNEL_DIR/$_BOOT_DEV-zImage
export _ROOTFS_FILE=$_ROOTFS_DIR/rootfs-$_BOOT_DEV.tar.gz
export _IMG_FILE=$_IMG_DIR/Nano_flash_$_SCREEN_PRAM.bin
cd ..
echo "Done~"
