#!/bin/bash
echo_log ()
{
    echo "\033[32m$1\033[0m"
}

echo_tip ()
{
    echo "\033[33m$1\033[0m"
}

echo_err ()
{
    echo "\033[31m ERROR: $1\033[0m"
}

# check the environment variables roughly
if [ -z $_TOP_DIR ] ; then
    echo_err "Please make sure you have configure the environment variables in ./env.sh correctly！"
    echo_err "Please using: 	cd ./configs; source ./configs/xxx.sh to setup the variables."
    exit
fi

if [ -f $_IMG_FILE ] ; then
    echo_log "Image exist,rename it to .old"
    mv $_IMG_FILE $_IMG_FILE.old
    echo "Creating new an Image"
fi

rm -rf ./_temp 
mkdir _temp &&\
cd _temp &&\
echo "Generate bin..."
dd if=/dev/zero of=flashimg.bin bs=1M count=16 &&\
echo_log "Packing Uboot..."
dd if=$_UBOOT_FILE of=flashimg.bin bs=1K conv=notrunc &&\
echo_log "Packing dtb..."
dd if=$_DTB_FILE of=flashimg.bin bs=1K seek=1024  conv=notrunc &&\
echo_log "Packing zImage..."
cp $_KERNEL_FILE ./zImage &&\
dd if=./zImage of=flashimg.bin bs=1K seek=1088  conv=notrunc &&\
mkdir rootfs
echo_log "Packing rootfs..."
tar -zxvf $_ROOTFS_FILE -C ./rootfs >/dev/null &&\
cp -r $_MOD_FILE  rootfs/lib/modules/ &&\
mkfs.jffs2 -s 0x100 -e 0x10000 --pad=0xAE0000 -d rootfs/ -o jffs2.img &&\
dd if=jffs2.img of=flashimg.bin  bs=1K seek=5248  conv=notrunc &&\
mv ./flashimg.bin $_IMG_FILE &&\
echo_log "Bin update done!"
cd .. &&\
rm -rf ./_temp 
echo_tip "You configure your LCD parameters as $_SCREEN_PRAM"
echo_log "Pack $_IMG_FILE finished"
exit






