#!/bin/bash
echo $_KERNEL_DEVDIR
echo $_KERNEL_DEVDIR
if [ "$_KERNEL_TYPE" = "main" ]; then 
echo "pull main kernel"
echo $_CP_CMD
echo $_KERNEL_MAINDIR
echo $_SUFFIX
$_CP_CMD $_KERNEL_MAINDIR/zImage $_KERNEL_FILE
$_CP_CMD $_KERNEL_MAINDIR/arch/arm/boot/dts/$_DTB_NAME $_DTB_FILE
$_CP_CMD $_KERNEL_MAINDIR/arch/arm/boot/dts/$_DTS_NAME $_DTS_FILE
rm -r $_MOD_DIR/$_KERNEL_VER
$_CP_CMD $_KERNEL_MAINDIR/out/lib/modules/$_KERNEL_VER\-licheepi-zero+/kernel/ $_MOD_DIR/$_KERNEL_VER
else
echo "pull bsp kernel"
$_CP_CMD $_KERNEL_BSPDIR/output/zImage $_KERNEL_FILE
$_CP_CMD $_KERNEL_BSPDIR/../sys_config.fex $_FEX_FILE
fex2bin $_FEX_FILE $_SCRIPT_FILE
$_CP_CMD $_KERNEL_BSPDIR/output/lib/modules/$_KERNEL_VER/ $_MOD_DIR/
fi
