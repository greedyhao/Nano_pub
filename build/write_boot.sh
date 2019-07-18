#!/bin/bash
sudo dd if=/dev/zero of=$1 bs=1024 seek=8 count=512 &&\
sudo dd if=$_UBOOT_FILE of=$1 bs=1024 seek=8 &&\
sync
