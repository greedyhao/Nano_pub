#!/bin/sh
# need edit as your env
# export _SCREEN_PRAM=480272
export _SCREEN_PRAM=800480
# export _SCREEN_PRAM=800600
export _TOP_DIR=$PWD/../..
export _KERNEL_MAINDIR=$PWD/../../p1
export _UBOOT_DEVDIR=$PWD/../../uboot
export _BR_DEVDIR=$PWD/../../p2
export _CP_CMD="docker cp"

# don't need edit
export _KERNEL_DIR=$_TOP_DIR/p1
export _MOD_DIR=$_TOP_DIR/modules
export _UBOOT_DIR=$_TOP_DIR/uboot/$_SCREEN_PRAM
export _DTB_DIR=$_TOP_DIR/p1/dtb_$_SCREEN_PRAM
# export _FEX_DIR=$_TOP_DIR/fex
# export _OVERLAY_DIR=$_TOP_DIR/overlay
export _ROOTFS_DIR=$_TOP_DIR/rootfs
export _IMG_DIR=$_TOP_DIR/image

