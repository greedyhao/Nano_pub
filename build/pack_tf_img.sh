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
    echo_err "please make sure you have configure the environment variables in ./env.sh correctly！"
    echo_err "please using: 	cd ./configs; source ./configs/xxx.sh to setup the variables."
    exit
fi

echo_tip "You configure your LCD parameters as $_SCREEN_PRAM"
echo_log "gen img size = $_IMG_SIZE MB"
_ROOTFS_SIZE=`gzip -l $_ROOTFS_FILE | sed -n '2p' | awk '{print $2}'`
_ROOTFS_SIZE=`echo "scale=3;$_ROOTFS_SIZE/1024/1024" | bc`
echo_tip "We dont enable overlay here"
# _OVERLAY_SIZE=`du $_OVERLAY_FILE --max-depth=0 | cut -f 1`
# _OVERLAY_SIZE=`echo "scale=3;$_OVERLAY_SIZE/1024" | bc`
_MOD_SIZE=`du $_MOD_FILE --max-depth=0 | cut -f 1`
_MOD_SIZE=`echo "scale=3;$_MOD_SIZE/1024" | bc`
_MIN_SIZE=`echo "scale=3;$_UBOOT_SIZE+$_P1_SIZE+$_ROOTFS_SIZE+$_MOD_SIZE+$_CFG_SIZEKB/1024" | bc` #+$_OVERLAY_SIZE
echo_log  "min img size = $_MIN_SIZE MB"
_FREE_SIZE=`echo "$_IMG_SIZE-$_MIN_SIZE"|bc`
# _OVERFLOW_FLAG=`echo "$_FREE_SIZE<=0"|bc`
# if [ $_OVERFLOW_FLAG -gt 0  ] ; then
# 	echo  "img size parm too small, set larger one"
# 	exit
# else
echo_log  "free space=$_FREE_SIZE MB"
# fi

rm $_IMG_FILE
if [ ! -e $_IMG_FILE ] ; then
    echo_log  "gen empty img..."
    dd if=/dev/zero of=$_IMG_FILE bs=1M count=$_IMG_SIZE
fi
if [ $? -ne 0 ]
then echo_err  "getting error in creating dd img!"
    exit
fi

_LOOP_DEV=$(sudo losetup -f)
if [ -z $_LOOP_DEV ]
then echo_err  "can not find a loop device!"
    exit
fi

sudo losetup $_LOOP_DEV $_IMG_FILE
if [ $? -ne 0 ]
then echo_err  "dd img --> $_LOOP_DEV error!"
    sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
fi

#############################################
#  			BOOT FROM TF CARD				#
#############################################
if [ "$_BOOT_DEV" = tf ] ; then
    echo_log  "creating partitions for tf image ..."
    #blockdev --rereadpt $_LOOP_DEV >/dev/null 2>&1
    # size only can be integer
cat <<EOT |sudo  sfdisk $_IMG_FILE
${_UBOOT_SIZE}M,${_P1_SIZE}M,c
,,L
EOT
    sleep 2
    sudo partx -u $_LOOP_DEV
    sudo mkfs.vfat ${_LOOP_DEV}p1 ||exit
    sudo mkfs.ext4 ${_LOOP_DEV}p2 ||exit
    if [ $? -ne 0 ]
    then echo_err  "error in creating partitions"
        sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
        #sudo partprobe $_LOOP_DEV >/dev/null 2>&1 && exit
    fi
    
    echo_log  "writing u-boot-sunxi-with-spl to $_LOOP_DEV"
    # sudo dd if=/dev/zero of=$_LOOP_DEV bs=1K seek=1 count=1023  # clear except mbr
    sudo dd if=$_UBOOT_FILE of=$_LOOP_DEV bs=1024 seek=8
    if [ $? -ne 0 ]
    then echo_err  "writing u-boot error!"
        sudo losetup -d $_LOOP_DEV >/dev/null 2>&1 && exit
        #sudo partprobe $_LOOP_DEV >/dev/null 2>&1 && exit
    fi
    
    sudo sync
    mkdir -p p1 >/dev/null 2>&1
    mkdir -p p2 > /dev/null 2>&1
    sudo mount ${_LOOP_DEV}p1 p1
    sudo mount ${_LOOP_DEV}p2 p2
    echo_log  "copy boot and rootfs files..."
    sudo rm -rf  p1/* && sudo rm -rf p2/*
    #############################################
    # 			TF MAINLINE KERNEL				#
    #############################################
    echo_tip "TF MAINLINE KERNEL"
    if [ "$_KERNEL_TYPE" = main ] ; then
        sudo cp $_KERNEL_FILE p1/zImage &&\
        sudo cp $_DTB_FILE p1/ &&\
        sudo cp boot.scr p1/ &&\
        echo_log "p1 done~"
        sudo tar xzvf $_ROOTFS_FILE -C p2/ &&\
        echo_log "p2 done~"
        # sudo cp -r $_OVERLAY_BASE/*  p2/ &&\
        # sudo cp -r $_OVERLAY_FILE/*  p2/ &&\
        sudo mkdir -p p2/lib/modules/${_KERNEL_VER}-next-20180202-licheepi-nano+/ &&\
        sudo cp -r $_MOD_FILE/*  p2/lib/modules/${_KERNEL_VER}-next-20180202-licheepi-nano+/
        echo_log "modules done~"
        
        if [ $_ADD_LITTLEVGL_DEMO = true ]
        echo_tip "we gonna add littleVgl demo in your dir /root"
        then sudo mkdir -p p2/root/littlevgl_demo &&\
            sudo cp $_TOP_DIR/littlevgl_demo/$_SCREEN_PRAM/* p2/root/littlevgl_demo/
        fi
        
        if [ $? -ne 0 ]
        then echo_err  "copy files error! "
            sudo losetup -d $_LOOP_DEV >/dev/null 2>&1
            sudo umount ${_LOOP_DEV}p1  ${_LOOP_DEV}p2 >/dev/null 2>&1
            exit
        fi
        echo_log "The tf card image-packing task done~"
        
    else
        #############################################
        # 				TF BSP KERNEL				#
        #############################################
        echo_tip "TF BSP KERNEL"
        sudo cp $_KERNEL_FILE p1/zImage &&\
        sudo cp $_SCRIPT_FILE p1/script.bin &&\
        sudo cp boot.scr p1/ &&\
        sudo tar xzvf $_ROOTFS_FILE -C p2/ &&\
        # sudo cp -r $_OVERLAY_BASE/*  p2/ &&\
        # sudo cp -r $_OVERLAY_FILE/*  p2/ &&\
        sudo mkdir -p p2/lib/modules/${_KERNEL_VER}/ &&\
        sudo cp -r $_MOD_FILE/*  p2/lib/modules/${_KERNEL_VER}/
        if [ $? -ne 0 ] ; then
            echo_err  "copy files error! "
            sudo losetup -d $_LOOP_DEV >/dev/null 2>&1
            sudo umount ${_LOOP_DEV}p1  ${_LOOP_DEV}p2 >/dev/null 2>&1
            exit
        fi
        echo_log  "BSP task done~"
    fi
    
    
    sudo sync
    sudo umount p1 p2  && sudo losetup -d $_LOOP_DEV
    if [ $? -ne 0 ]
    then echo_err  "umount or losetup -d error!!"
        exit
    fi
    
else
    #############################################
    # 			BOOT FROM SPI FLASH				#
    #############################################
    echo_tip  "please using pack_flash_img.sh"
    exit
fi

echo_log  "The $_IMG_FILE has been created successfully!"
echo_tip "gen img size = $_IMG_SIZE MB"
echo_tip "min img size = $_MIN_SIZE MB"
echo_tip "free space = $_FREE_SIZE MB"
exit






