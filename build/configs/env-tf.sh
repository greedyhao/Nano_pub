#!/bin/bash
source ../env.sh
#change here to your config
export _CASE_NAME=V1
export _BOOT_DEV=tf
export _KERNEL_TYPE=main
# export _KERNEL_VER=4.15.0
export _KERNEL_VER=5.2.0
export _DT_NAME=suniv-f1c100s-licheepi-nano
# export _ROOTFS_TYPE=tf
export _IMG_SIZE=200
export _UBOOT_SIZE=1
export _CFG_SIZEKB=0
export _P1_SIZE=16
export _MOD_FILE=$_MOD_DIR/$_BOOT_DEV/$_KERNEL_VER-licheepi-nano
export _ADD_LITTLEVGL_DEMO=true

#do not change next
if [ "$_KERNEL_TYPE" = main ] ; then
    export _KERNEL_DEVDIR=$_KERNEL_MAINDIR
else
    export _KERNEL_DEVDIR=$_KERNEL_BSPDIR
fi
export _SUFFIX=$_CASE_NAME-$_BOOT_DEV$_KERNEL_TYPE
export _UBOOT_FILE=$_UBOOT_DIR/u-boot-$_BOOT_DEV.bin
export _DTB_NAME=$_DT_NAME.dtb
export _DTS_NAME=$_DT_NAME.dts
export _DTS_FILE=$_DTB_DIR/$_BOOT_DEV/$_DTS_NAME
export _DTB_FILE=$_DTB_DIR/$_BOOT_DEV/$_DTB_NAME
export _KERNEL_FILE=$_KERNEL_DIR/$_BOOT_DEV-zImage
export _ROOTFS_FILE=$_ROOTFS_DIR/rootfs-$_BOOT_DEV.tar.gz
export _IMG_FILE=$_IMG_DIR/Nano_$_BOOT_DEV\_$_SCREEN_PRAM.dd
source ../gen_scr.sh $_BOOT_DEV $_KERNEL_TYPE


