#!/bin/bash

echo_log ()
{
    echo "\033[32m$1\033[0m"
}

if [ -z $_IMG_FILE ] ; then
    echo_err "please using: 	cd ./configs; source ./configs/xxx.sh to setup the variables."
    exit
fi

if [ -f /usr/local/bin/sunxi-fel ] ; then
    echo "sunxi-fel ready!"
else
    echo "Installing sunxi-fel..."
    sudo apt-get install libusb-1.0-0-dev &&\
    git clone -b f1c100s-spiflash https://github.com/Icenowy/sunxi-tools.git &&\
    cd sunxi-tools 
    make && sudo make install
    cd ..
    rm -rf ./sunxi-tools
    echo "Install Finished..."
fi

if [ -f $_IMG_FILE ] ; then
    echo_log "image ready! start download..."
    sudo sunxi-fel -p spiflash-write 0 $_IMG_FILE 
else
    echo_log "image not exist! start packing..."
    sh pack_flash_img.sh &&\
    sudo sunxi-fel -p spiflash-write 0 $_IMG_FILE
fi

echo_log "finished!"
exit