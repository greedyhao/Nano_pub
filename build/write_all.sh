#!/bin/sh
./clear_partion.sh $1 &&\
./write_partion.sh $1 &&\
./write_mkfs.sh $1 &&\
./write_boot.sh $1 &&\
./write_p1.sh $1 &&\
./write_p2.sh $1 &&\
echo "write ALL ok!"
umount mnt >/dev/null 2>&1
