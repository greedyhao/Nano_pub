#/bin/bash
# need set up env first, use source env-xxx.sh to setup env
cd ..
if [ "$_BOOT_DEV" = tf ]; then  #tf
	if [ "$_KERNEL_TYPE" = main ]; then #main
(
cat << EOF
setenv bootargs console=tty0 console=ttyS0,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw 
load mmc 0:1 0x80C00000 suniv-f1c100s-licheepi-nano.dtb
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
EOF
) > boot.cmd		
	else	#bsp
(
cat << EOF
setenv bootargs console=tty0 console=ttyS0,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw 
setenv bootm_boot_mode sec
setenv machid 1029
load mmc 0:1 0x80C00000 suniv-f1c100s-licheepi-nano.dtb
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
EOF
)> boot.cmd
	fi
else  #spi
    echo "main spi"
        else	#bsp
	echo "bspspi"
        fi
fi
mkimage -C none -A arm -T script -d boot.cmd boot.scr
